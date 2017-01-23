package imagsyd.imagination.services.tuio.listeners;
import com.imagination.delay.Delay;
import com.imagination.delay.DelayObject;
import com.imagination.util.signals.Signal.Signal1;
import haxe.Timer;
import imagsyd.imagination.managers.Marker;
import imagsyd.imagination.managers.TuioMarkerManager;
import imagsyd.imagination.services.tuio.listeners.TouchInputListener.TouchMap;
import imagsyd.imagination.services.tuio.process.IMarkerProcess;
import openfl.Vector;
import org.tuio.ITuioListener;
import org.tuio.TuioBlob;
import org.tuio.TuioCursor;
import org.tuio.TuioObject;
import starling.events.Touch;
import starling.events.TouchPhase;

/**
 * ...
 * @author Michal Moczynski
 */
@:rtti
@:keepSub
class MarkerInputListener implements ITuioListener 
{
	@inject public var tuioMarkerManager:TuioMarkerManager;
	
	public var width:Int = 100;
	public var height:Int = 100;
	
	private var markersPool:Array<Marker> = new Array<Marker>();
	private var markersMap:Map<UInt, Marker> = new Map<UInt, Marker>();
	
	public var processStack:Array<IMarkerProcess> = [];
		
	public function new() 
	{
		for (i in 0 ... 100) 
		{
			var m:Marker = new Marker();
			markersPool.push(m);
		}
	}
	
	public function addTuioObject(tuioObject:TuioObject):Void 
	{ 
		if (tuioObject.classID > 0 && tuioObject.classID % 5 == 0)
		{
			checkMarker(TouchPhase.BEGAN, tuioObject);
			trace("added " + tuioObject.classID);
		}
	}
	
	public function updateTuioObject(tuioObject:TuioObject):Void 
	{ 
		checkMarker(TouchPhase.MOVED, tuioObject);
	}	
	
	public function removeTuioObject(tuioObject:TuioObject):Void 
	{ 
		trace("removeTuioObject " + tuioObject.classID);
		/*
		var marker:Marker = checkMarker(TouchPhase.ENDED, tuioObject);
		marker.markerRemoved.dispatch(marker.id);
		marker.removeDelayObject = Delay.byTime( 1, markersMap.remove, [marker.id] );
		*/
		var marker:Marker = markersMap.get( tuioObject.classID );
		if (marker != null)
		{
			marker.markerRemoved.dispatch();
			markersMap.remove(tuioObject.classID);
		}
	}

	private function checkMarker(phase:String, tuioObject:TuioObject):Marker 
	{
		var classID:UInt = tuioObject.classID;
		
		var m:Marker;
		if ( markersMap.exists( classID ) )
		{			
			if(phase == TouchPhase.BEGAN)
				trace( "begin but exists" );
				
			m = markersMap.get( classID );
			m.x = tuioObject.x * width;
			m.y = tuioObject.y * height;
			m.rotation = tuioObject.a;		
			m.classID = tuioObject.classID;
			
			m = process( m );
			if (phase == TouchPhase.BEGAN)
				m.markerAdded.dispatch();
			else
				m.markerUpdated.dispatch();
		}
		else
		{
			m = markersPool.shift();
			markersPool.push(m);
			markersMap.set(classID, m);
			m.x = tuioObject.x * width;
			m.y = tuioObject.y * height;
			m.rotation = tuioObject.a;
			m.classID = tuioObject.classID;
			tuioMarkerManager.onBegin.dispatch( m );
			
			m = process( m );
			m.markerAdded.dispatch();
		}
		
//		Delay.clearObject(m.removeDelayObject);
		
		return m;
	}
	
	function process(m:Marker):Marker
	{
		if (processStack.length == 0)
			return m;
		else
		{
			for( proc in processStack ) 
			{
				proc.process(m);
			}
		}
		return m;		
	}

	
		
	public function addTuioBlob(tuioBlob:TuioBlob):Void { }
	public function updateTuioBlob(tuioBlob:TuioBlob):Void {}
	public function removeTuioBlob(tuioBlob:TuioBlob):Void { }	
	public function addTuioCursor(tuioCursor:TuioCursor):Void {	}	
	public function updateTuioCursor(tuioCursor:TuioCursor):Void {}	
	public function removeTuioCursor(tuioCursor:TuioCursor):Void {}
	
	public function newFrame(id:UInt):Void 
	{
		
	}
	
}
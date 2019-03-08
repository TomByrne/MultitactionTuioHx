package multitaction.tuio.processors.maker;
import imagsyd.signals.Signal.Signal1;
import multitaction.model.marker.MarkerObjectsModel;
import imagsyd.notifier.Notifier;
import multitaction.model.marker.MarkerObjectsModel.MarkerObjectElement;
import multitaction.tuio.listener.BasicProcessableTuioListener;
import multitaction.tuio.processors.maker.base.ITuioStackableProcessor;
import openfl.geom.Point;
import org.tuio.TuioObject;
import multitaction.model.marker.IMarkerObjectsModel;

/**
 * ...
 * @author Michal Moczynski
 */
class SimpleMarkerFromTuioProcessor implements ITuioStackableProcessor
{
	var doubleUpThreshold:Float = 200/1920;//distance in screen fraction (that's what tuio uses)
	var itemFound:Bool;
	var doubledToe:MarkerObjectElement;
	var markerObjectsModel:IMarkerObjectsModel;
	public var displayName:String = "Idle";
	public var angleThreshold:Float = 30;
	public var active:Notifier<Bool> = new Notifier<Bool>(true);

	public function new(active:Bool, markerObjectsModel:IMarkerObjectsModel) 
	{
		this.active.value = active;
		this.markerObjectsModel = markerObjectsModel;
	}

	public function process(listener:BasicProcessableTuioListener):Void
	{
		for ( moe in markerObjectsModel.markerObjectsMap)
		{
			moe.alive = false;			
		}
		
		for (  to in listener.tuioObjects ) 
		{
			if ( markerObjectsModel.tuioToMarkerMap.exists( "t" + to.sessionID ) == false )
			{
				addNewMarker( to );
			}
			else
			{
				updateMarker( to );
			}
		}
		
		for ( moe in markerObjectsModel.markerObjectsMap)
		{
			if ( moe.alive == false)
			{
				markerObjectsModel.frameRemovedMarkers.push( moe.uid );
				markerObjectsModel.markerObjectsMap.remove( moe.uid );				
				//this.log( "    removed moe with uid " + moe.uid);
			}
		}
	}
	
	function updateMarker(to:TuioObject) 
	{
		var moe:MarkerObjectElement = markerObjectsModel.markerObjectsMap.get( markerObjectsModel.tuioToMarkerMap.get("t" + to.sessionID ) );
		moe.rotation = to.a;
		moe.alive = true;
		moe.frameId = to.frameID;
		moe.fractPos.unshift( new Point( to.x, to.y));
		if (moe.fractPos.length > 10)
			moe.fractPos.pop();					
	}
	
	function addNewMarker( to:TuioObject ) 
	{
		var moe:MarkerObjectElement = {
			fractPos:new Array<Point>(), 
			pos:new Point(), 
			rotation:to.a, 
			uid:MarkerObjectsModel.getNextUID(), 
			cardId:to.classID, 
			previousCardId:null,
			tuioCardId:to.classID, 
			cardIdChanged:new Signal1<String>(),
			readCardIds:new Map<UInt,UInt>(), 
			lastCardChangeFrame:to.frameID,
			frameId:to.frameID,
			fromTuio:true, 
			alive:true, 
			safetyRadius:0.1};

		this.log( "    added moe with new uid " + moe.uid);
		moe.fractPos.unshift( new Point( to.x, to.y));
		
		markerObjectsModel.tuioToMarkerMap.set( "t" + to.sessionID, moe.uid);
		markerObjectsModel.markerObjectsMap.set( moe.uid, moe);
		markerObjectsModel.frameAddedMarkers.push( moe.uid );		
	}
	
	function findAllDoubleUp(tuioObjects:Map<UInt, TuioObject>, object:TuioObject):TuioObject
	{
//		var result:Array<TuioObject> = [];
		for (  to in tuioObjects ) 
		{
			var distance:Float = Point.distance( new Point(to.x, to.y), new Point(object.x, object.y));
			//Logger.log(this, "is double up? " + to.x + "," + to.y + " and " + object.x + " " + object.y + "distance " + distance );
			if (distance < doubleUpThreshold )
			{
				if (to == object)
				{
					itemFound = true;
				}
				else
				{
					return to;
					//TODO: check if returning the first rest is enough (should be)
				}
			}
		}
		return null;		
	}
	
}
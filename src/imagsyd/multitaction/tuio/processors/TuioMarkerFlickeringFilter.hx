package imagsyd.multitaction.tuio.processors;
import com.imagination.core.type.Notifier;
import imagsyd.multitaction.model.MarkerObjectsModel;
import imagsyd.multitaction.model.MarkerObjectsModel.MarkerObjectElement;
import imagsyd.multitaction.tuio.listener.BasicProcessableTuioListener;
import imagsyd.multitaction.tuio.processors.base.ITuioStackableProcessor;
import openfl.geom.Point;
import org.tuio.TuioObject;
import imagsyd.multitaction.model.IMarkerObjectsModel;

/**
 * ...
 * @author Michal Moczynski
 */
class TuioMarkerFlickeringFilter implements ITuioStackableProcessor
{
	var markerObjectsModel:IMarkerObjectsModel;
	public var distanceThreshold:Float = 200 / 1920;
	public var displayName:String = "Mastercard processor";
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
				if ( checkForDoubles( to ) == false)
				{
					addNewMarker( to );
				}
				else
				{
					
				}
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
			}
		}
	}
	
	function checkForDoubles( to:TuioObject ):Bool
	{
		var foundDouble:Bool = false;
		for (moe in markerObjectsModel.markerObjectsMap) 
		{
			if (Point.distance( new Point(to.x, to.y), moe.fractPos[0] ) < distanceThreshold )
			{
				markerObjectsModel.tuioToMarkerMap.set( "t" + to.sessionID, moe.uid );
				foundDouble = true;				
				//TODO: check if first found result is good enough
				return foundDouble;
			}			
		}		
		return foundDouble;
	}
	
	function updateMarker( to:TuioObject ) 
	{
		var moe:MarkerObjectElement = markerObjectsModel.markerObjectsMap.get( markerObjectsModel.tuioToMarkerMap.get( "t" + to.sessionID ) );
		moe.rotation = to.r;
		moe.alive = true;
		moe.frameId = to.frameID;
		moe.fractPos.unshift( new Point( to.x, to.y));
		if (moe.fractPos.length > 10)
			moe.fractPos.pop();					
	}
	
	function addNewMarker( to:TuioObject ):MarkerObjectElement
	{
		var moe:MarkerObjectElement = {fractPos:new Array<Point>(), pos:new Point(), rotation:to.r, uid:MarkerObjectsModel.getNextUID(), cardId:to.classID, frameId:to.frameID,fromTuio:true, alive:true};
		Logger.log(this, "    added moe with new uid " + moe.uid);
		moe.fractPos.unshift( new Point( to.x, to.y));
		
		markerObjectsModel.tuioToMarkerMap.set( "t" + to.sessionID, moe.uid);
		markerObjectsModel.markerObjectsMap.set( moe.uid, moe);
		markerObjectsModel.frameAddedMarkers.push( moe.uid );		
		return moe;
	}
	
}
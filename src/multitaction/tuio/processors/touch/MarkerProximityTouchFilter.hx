package multitaction.tuio.processors.touch;
import multitaction.model.marker.IMarkerObjectsModel;
import multitaction.model.touch.TouchObjectsModel;
import multitaction.tuio.listener.BasicProcessableTuioListener;
import multitaction.tuio.processors.marker.base.ITuioStackableProcessor;
import openfl.geom.Point;
import org.tuio.TuioCursor;
import imagsyd.notifier.Notifier;

/**
 * ...
 * @author Michal Moczynski
 */
class MarkerProximityTouchFilter implements ITuioStackableProcessor
{
	public var displayName:String = "Marker proximity fiter";
	public var active:Notifier<Bool> = new Notifier<Bool> (false);
	
	var markerObjectsModel:IMarkerObjectsModel;
	var touchObjectsModel:TouchObjectsModel;
	
	public var distanceThreshold:Float = 0.05; //0.053 in fraction (tuio)

	public function new(active:Bool, markerObjectsModel:IMarkerObjectsModel, touchObjectsModel:TouchObjectsModel) 
	{
		this.active.value = active;
		this.markerObjectsModel = markerObjectsModel;
		this.touchObjectsModel = touchObjectsModel;
	}
	
	public function process(listener:BasicProcessableTuioListener):Void
	{
		for (  tc in touchObjectsModel.cursorsAdded ) 
		{
			if ( isCursorCloseToMarker(tc) == true )
			{
				touchObjectsModel.cursorsAdded.remove( tc.sessionID );
				touchObjectsModel.touchesThatBeganMap.remove(tc.sessionID);
//				touchObjectsModel.removeTouch(tc.sessionID);
			}
			else
				touchObjectsModel.touchesThatBeganMap.set(tc.sessionID, true);
		}
		
		for (  tc in touchObjectsModel.cursorsUpdated) 
		{
			if ( isCursorCloseToMarker(tc) == true )
			{
				touchObjectsModel.cursorsUpdated.remove( tc.sessionID );
				//touchObjectsModel.touchesThatBeganMap.remove(tc.sessionID);
				//touchObjectsModel.removeTouch(tc.sessionID);
			}
		}
		
		/*
		for (  tc in touchObjectsModel.cursorsRemoved) 
		{
			if ( isCursorCloseToMarker(tc) == true )
			{
				touchObjectsModel.cursorsRemoved.remove( tc.sessionID );
				//touchObjectsModel.touchesThatBeganMap.remove(tc.sessionID);
				//touchObjectsModel.removeTouch(tc.sessionID);
			}
		}
		*/
	}
	
	function isCursorCloseToMarker(tuioCursor:TuioCursor):Bool
	{
		for (moe in markerObjectsModel.markerObjectsMap) 
		{
			if ( Point.distance( moe.fractPos[0], new Point(tuioCursor.x, tuioCursor.y)) < distanceThreshold)
			{
//				this.log("TOUCH TOO CLOSE TO THE MARKER " + Point.distance( moe.fractPos[0], new Point(tuioCursor.x, tuioCursor.y)));
				return true;
			}
		}
		
		return false;
	}
	
}
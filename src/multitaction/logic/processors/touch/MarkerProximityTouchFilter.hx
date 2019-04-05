package multitaction.logic.processors.touch;
import multitaction.model.marker.IMarkerObjectsModel;
import multitaction.model.touch.ITouchObjectsModel;
import multitaction.logic.listener.BasicProcessableTuioListener;
import multitaction.logic.processors.marker.base.ITuioStackableProcessor;
import org.tuio.TuioCursor;
import imagsyd.notifier.Notifier;
import multitaction.utils.GeomTools;

/**
 * ...
 * @author Michal Moczynski
 */
class MarkerProximityTouchFilter implements ITuioStackableProcessor
{
	public var displayName:String = "Marker proximity filter";
	public var active:Notifier<Bool> = new Notifier<Bool> (false);
	
	var markerObjectsModel:IMarkerObjectsModel;
	var touchObjectsModel:ITouchObjectsModel;
    var touchesThatBeganMap:Map<Int, Bool> = new Map<Int, Bool>();
	
	public var distanceThreshold:Float = 0.05; //0.053 in fraction (tuio)

	public function new(active:Bool, markerObjectsModel:IMarkerObjectsModel, touchObjectsModel:ITouchObjectsModel) 
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
				touchesThatBeganMap.remove(tc.sessionID);
			}
			else
				touchesThatBeganMap.set(tc.sessionID, true);
		}
		
		for (  tc in touchObjectsModel.cursorsUpdated) 
		{
			if ( isCursorCloseToMarker(tc) == true )
			{
				touchObjectsModel.cursorsUpdated.remove( tc.sessionID );
			}
		}
	}
	
	function isCursorCloseToMarker(tuioCursor:TuioCursor):Bool
	{
		for (moe in markerObjectsModel.markerObjectsMap) 
		{
			if ( GeomTools.dist( moe.fractPos[0].x, moe.fractPos[0].y, tuioCursor.x, tuioCursor.y) < distanceThreshold)
			{
				return true;
			}
		}
		
		return false;
	}
	
}
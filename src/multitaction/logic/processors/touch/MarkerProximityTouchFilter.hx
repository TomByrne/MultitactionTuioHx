package multitaction.logic.processors.touch;
import multitaction.model.marker.IMarkerObjectsModel;
import multitaction.model.touch.ITouchObjectsModel;
import multitaction.logic.listener.BasicProcessableTuioListener;
import multitaction.logic.processors.marker.base.ITuioStackableProcessor;
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
	
	public var distanceThreshold:Float = 0.05; //0.053 in fraction (tuio)

	public function new(active:Bool, markerObjectsModel:IMarkerObjectsModel, touchObjectsModel:ITouchObjectsModel) 
	{
		this.active.value = active;
		this.markerObjectsModel = markerObjectsModel;
		this.touchObjectsModel = touchObjectsModel;
	}
	
	public function process(listener:BasicProcessableTuioListener):Void
	{
        for( touch in touchObjectsModel.touchList)
        {
            if ( isCursorCloseToMarker(touch) == true )
			{
				touchObjectsModel.abortTouch( touch.id );
			}
        }
	}
	
	function isCursorCloseToMarker(touchObj:TouchObject):Bool
	{
		for (moe in markerObjectsModel.markerObjectsMap) 
		{
            var touchX:Float = touchObj.x / touchObj.rangeX;
            var touchY:Float = touchObj.y / touchObj.rangeY;
			if ( GeomTools.dist( moe.fractPos[0].x, moe.fractPos[0].y, touchX, touchY) < distanceThreshold)
			{
				return true;
			}
		}
		
		return false;
	}
	
}
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
	
	public var distanceThresholdX:Float = 140 / 3840;
	public var distanceThresholdY:Float = 140 / 2160;

	var ignored:Map<Int, Bool> = new Map();

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
			switch(touch.state){
				case TouchState.START:
					if ( isCursorCloseToMarker(touch) ){
						ignored.set( touch.id, true );
						touchObjectsModel.abortTouch( touch.id );
					}

				case TouchState.MOVE:
					if(ignored.get(touch.id)){
						touchObjectsModel.abortTouch( touch.id );

					}else if( isCursorCloseToMarker(touch) ){
						ignored.set( touch.id, true );
						touch.state = TouchState.END;
					}

				case TouchState.END:
					if(ignored.get(touch.id)){
						ignored.remove(touch.id);
						touchObjectsModel.abortTouch( touch.id );
					}
			}
            
        }
	}
	
	function isCursorCloseToMarker(touchObj:TouchObject):Bool
	{
		for (moe in markerObjectsModel.markerObjectsMap) 
		{
            var touchX:Float = touchObj.x / touchObj.rangeX;
            var touchY:Float = touchObj.y / touchObj.rangeY;
			if ( moe.fractPos.length > 0 && Math.abs(moe.fractPos[0].x - touchX) < moe.safetyRadiusX / 2 && Math.abs(moe.fractPos[0].y - touchY) < moe.safetyRadiusY  / 2)
			{
				return true;
			}
		}
		
		return false;
	}
	
}
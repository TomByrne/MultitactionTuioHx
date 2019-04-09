package multitaction.logic.processors.touch;

import imagsyd.notifier.Notifier;
import multitaction.logic.processors.marker.base.ITuioStackableProcessor;
import multitaction.model.touch.ITouchObjectsModel;
import multitaction.logic.listener.BasicProcessableTuioListener;

/**
 * ...
 * @author Michal Moczynski
 */
class FlipOrientationTouchProcessor implements ITuioStackableProcessor
{
	var touchObjectsModel:ITouchObjectsModel;

	public var displayName:String = "Flip Orientation";
	public var active:Notifier<Bool> = new Notifier<Bool>(true);
	
	public function new(active:Bool, touchObjectsModel:ITouchObjectsModel) 
	{
		this.active.value = active;
		this.touchObjectsModel = touchObjectsModel;
	}
	
	public function process(listener:BasicProcessableTuioListener):Void
	{
		for (  touch in touchObjectsModel.touches ) 
		{
			touch.x = touch.rangeX - touch.x;
			touch.y = touch.rangeY - touch.y;
        }
	}
	
}
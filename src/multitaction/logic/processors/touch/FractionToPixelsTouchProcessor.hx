package multitaction.logic.processors.touch;

import imagsyd.notifier.Notifier;
import multitaction.logic.listener.BasicProcessableTuioListener;
import multitaction.logic.processors.marker.base.ITuioStackableProcessor;
import multitaction.model.touch.ITouchObjectsModel;
import multitaction.utils.MarkerPoint;

/**
 * ...
 * @author Michal Moczynski
 */
 @:access(org.tuio.TuioCursor)
class FractionToPixelsTouchProcessor implements ITuioStackableProcessor
{
	var touchObjectsModel:ITouchObjectsModel;
	var nativeScreenSize:Notifier<MarkerPoint>;

	public var displayName:String = "Fraction to pixels";
	public var active:Notifier<Bool> = new Notifier<Bool>(true);
	
	public function new(active:Bool, touchObjectsModel:ITouchObjectsModel, nativeScreenSize:Notifier<MarkerPoint>) 
	{
		this.active.value = active;
		this.touchObjectsModel = touchObjectsModel;
		this.nativeScreenSize = nativeScreenSize;
	}
	
	public function process(listener:BasicProcessableTuioListener):Void
	{
        var screenW:Float = nativeScreenSize.value.x;
        var screenH:Float = nativeScreenSize.value.y;

		for (  tc in touchObjectsModel.cursorsAdded ) 
		{
			tc._x *= screenW;
			tc._y *= screenH;
		}
		for (  tc in touchObjectsModel.cursorsUpdated) 
		{
			tc._x *= screenW;
			tc._y *= screenH;
		}
        // Already multiplied
		/*for (  tc in touchObjectsModel.cursorsRemoved) 
		{
			tc._x *= screenW;
			tc._y *= screenH;
		}*/
	}
	
}
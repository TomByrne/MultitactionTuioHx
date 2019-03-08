package multitaction.logic;
import multitaction.model.touch.TuioTouchesSettingsModel;
import multitaction.tuio.view.starling.display.touches.TouchDebugView;
import starling.core.Starling;

/**
 * ...
 * @author Michal Moczynski
 */
@:rtti
@:keepSub
class TuioDebugViewsLogic 
{
	@inject public var tuioTouchesSettingsModel:TuioTouchesSettingsModel;	
	var touchesDebugView:TouchDebugView;

	public function new() 
	{
		
	}
	
	public function initialize() 
	{
		tuioTouchesSettingsModel.showTouches.add( handleShowTouchesChanged );
	}
	
	function handleShowTouchesChanged():Void
	{
		if (tuioTouchesSettingsModel.showTouches.value)
		{
			#if starling
			touchesDebugView = new TouchDebugView();
			Starling.current.stage.addChild( touchesDebugView );
			#else
			this.warn("Tuio touches debug view only implemented in Starling.");
			#end
		}
		else
		{
			if (touchesDebugView != null)
			{
				touchesDebugView.removeFromParent(true);
			}
		}
	}
	
}
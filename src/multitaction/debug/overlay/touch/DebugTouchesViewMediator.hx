package multitaction.debug.overlay.touch;

import robotlegs.bender.bundles.mvcs.Mediator;
import multitaction.model.settings.MultitactionSettingsModel;
import multitaction.model.touch.ITouchObjectsModel;

/**
 * ...
 * @author Michal Moczynski
 */
@:noCompletion
class DebugTouchesViewMediator extends Mediator 
{
	@inject public var view:DebugTouchesView;
	@inject public var multitactionSettingsModel:MultitactionSettingsModel;
    @inject public var touchObjectsModel:ITouchObjectsModel;
	
	public function new() 
	{
	}
	
	override public function initialize():Void
	{
		view.initialize(touchObjectsModel);
		
		handleShowChanged();
		multitactionSettingsModel.debugTouchShown.add( handleShowChanged );
	}
	
	function handleShowChanged():Void
	{
		view.visible = multitactionSettingsModel.debugTouchShown.value;
	}
	
	override public function destroy():Void
	{
		//view.dispose();
	}
	
	override public function postDestroy():Void
	{
		super.postDestroy();
	}
}
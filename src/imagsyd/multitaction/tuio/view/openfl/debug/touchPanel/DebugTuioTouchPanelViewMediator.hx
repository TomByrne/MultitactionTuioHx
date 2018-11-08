package imagsyd.multitaction.tuio.view.openfl.debug.touchPanel;
import imagsyd.multitaction.model.TuioTouchesSettingsModel;
import robotlegs.bender.bundles.mvcs.Mediator;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;

/**
 * ...
 * @author Michal Moczynski
 */

@:rtti
class DebugTuioTouchPanelViewMediator extends Mediator 
{
	@inject public var view:DebugTuioTouchPanelView;
	@inject public var mediatorMap:IMediatorMap;
	@inject public var tuioTouchSettingsModel:TuioTouchesSettingsModel;
	
	public function new() 
	{
	}
	
	override public function initialize():Void
	{
		mediatorMap.map(DebugToggleView).toMediator(DebugToggleViewMediator);
		view.initialize(tuioTouchSettingsModel.useTuioTouches, tuioTouchSettingsModel.useWindoesTouches, tuioTouchSettingsModel.showTouches);
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
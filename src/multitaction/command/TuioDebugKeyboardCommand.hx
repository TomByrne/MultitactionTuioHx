package multitaction.command;

import multitaction.model.settings.MultitactionSettingsModel;
import robotlegs.bender.bundles.mvcs.Command;
import imagsyd.hooks.model.HooksModel;

/**
 * ...
 * @author Michal Moczynski
 */
class TuioDebugKeyboardCommand extends Command
{
	@inject public var multitactionSettingsModel:MultitactionSettingsModel;
	@inject public var hooksModel:HooksModel;
	
	public function new() { }
	
	override public function execute():Void
	{
		hooksModel.add('multitaction.debug-touch.toggle', toggleDebugTouchShown, {description:"Toggle MT touch debug view"}, {key:T, ctrl:true, alt:true, shift:true});
		hooksModel.add('multitaction.debug-marker.toggle', toggleDebugMarkerShown, {description:"Toggle MT marker debug view"}, {key:M, ctrl:true, alt:true, shift:true});
	}
	
	function toggleDebugTouchShown():Void 
	{
		multitactionSettingsModel.debugTouchShown.value = !multitactionSettingsModel.debugTouchShown.value;
	}
	
	function toggleDebugMarkerShown():Void 
	{
		multitactionSettingsModel.debugMarkerShown.value = !multitactionSettingsModel.debugMarkerShown.value;
	}
}
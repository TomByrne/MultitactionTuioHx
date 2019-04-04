package multitaction.command;

import multitaction.model.settings.MultitactionSettingsModel;
import robotlegs.bender.bundles.mvcs.Command;
import keyboard.Keyboard;
import keyboard.Key;

/**
 * ...
 * @author Michal Moczynski
 */
class TuioDebugKeyboardCommand extends Command
{
	@inject public var multitactionSettingsModel:MultitactionSettingsModel;	
	
	public function new() { }
	
	override public function execute():Void
	{
        Keyboard.onPress(Key.T, toggleDebugTouchShown).shift(true).ctrl(true).alt(true);
        Keyboard.onPress(Key.M, toggleDebugMarkerShown).shift(true).ctrl(true).alt(true);
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
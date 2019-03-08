package multitaction.command;

import multitaction.model.touch.TuioTouchesSettingsModel;
import robotlegs.bender.bundles.mvcs.Command;
import keyboard.Keyboard;
import keyboard.Key;

/**
 * ...
 * @author Michal Moczynski
 */
class TuioDebugKeyboardCommand extends Command
{
	@inject public var tuioTouchSettingsModel:TuioTouchesSettingsModel;
	
	public function new() { }
	
	override public function execute():Void
	{
        Keyboard.onPress(Key.T, handleTuioNotifierChange).shift(true).ctrl(true);
        Keyboard.onPress(Key.W, handleWindowsNotifierChange).shift(true).ctrl(true);
        Keyboard.onPress(Key.D, handleTouchDebugNotifierChange).shift(true).ctrl(true).alt(true);
	}
	
	function handleTouchDebugNotifierChange():Void 
	{
		tuioTouchSettingsModel.showTouches.value = !tuioTouchSettingsModel.showTouches.value;
	}

	function handleTuioNotifierChange():Void 
	{
		tuioTouchSettingsModel.useTuioTouches.value = true;// !tuioTouchSettingsModel.useTuioTouches.value;
	}
	
	function handleWindowsNotifierChange():Void 
	{
		tuioTouchSettingsModel.useWindoesTouches.value = true;//!tuioTouchSettingsModel.useWindoesTouches.value;
	}	
}
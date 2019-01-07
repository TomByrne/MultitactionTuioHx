package imagsyd.multitaction.command;

import imagsyd.multitaction.model.touch.TuioTouchesSettingsModel;
import openfl.ui.Keyboard;
import robotlegs.bender.bundles.mvcs.Command;
import imagsyd.input.IKeyboardMap;

/**
 * ...
 * @author Michal Moczynski
 */
class TuioDebugKeyboardCommand extends Command
{
	@inject public var keyboardMap:IKeyboardMap;
	@inject public var tuioTouchSettingsModel:TuioTouchesSettingsModel;
	
	public function new() { }
	
	override public function execute():Void
	{
		keyboardMap.map(handleTuioNotifierChange, Keyboard.T, { shift:true, ctrl:true } );		
		keyboardMap.map(handleWindowsNotifierChange, Keyboard.W, { shift:true, ctrl:true } );	
		keyboardMap.map(handleTouchDebugNotifierChange, Keyboard.D, { alt:true,shift:true, ctrl:true } );	
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
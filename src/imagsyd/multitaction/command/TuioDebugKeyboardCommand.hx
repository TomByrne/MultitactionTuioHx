package imagsyd.multitaction.command;

import imagsyd.multitaction.model.TuioTouchesSettingsModel;
import openfl.ui.Keyboard;
import robotlegs.bender.bundles.mvcs.Command;
import robotlegs.bender.extensions.imag.api.services.keyboard.IKeyboardMap;

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
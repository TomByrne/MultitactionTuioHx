package multitaction.tuio;

import multitaction.command.TuioDebugKeyboardCommand;
import multitaction.logic.TuioDebugViewsLogic;
import multitaction.model.marker.*;
import multitaction.model.settings.TuioSettingsModel;
import multitaction.model.touch.*;
import multitaction.tuio.*;
import multitaction.tuio.listener.*;
import multitaction.tuio.view.openfl.debug.touchPanel.DebugTuioTouchPanelView;
import multitaction.tuio.view.openfl.debug.touchPanel.DebugTuioTouchPanelViewMediator;
import multitaction.tuio.view.openfl.debug.tuioMarkers.DebugTuioFiltersView;
import multitaction.tuio.view.openfl.debug.tuioMarkers.DebugTuioFiltersViewMediator;
import multitaction.tuio.view.starling.display.touches.TouchDebugView;
import multitaction.tuio.view.starling.display.touches.TouchDebugViewMediator;
import imagsyd.startup.signals.StartupCompleteSignal;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
import robotlegs.bender.framework.api.IConfig;
import robotlegs.bender.framework.api.IInjector;

/**
 * ...
 * @author Michal Moczynski
 */

@:rtti
@:keepSub
class TuioBundle implements IConfig 
{
	@inject public var injector:IInjector;
	@inject public var commandMap:ISignalCommandMap;
	@inject public var mediatorMap:IMediatorMap;
	
	public function new() { }
	
	public function configure():Void
	{
		injector.map(TuioTouchesSettingsModel).asSingleton();
		injector.map(MarkerObjectsModel).asSingleton();
		injector.map(TouchObjectsModel).asSingleton();
		injector.map(TuioSettingsModel).asSingleton();
		injector.map(TuioMarkersStackableProcessesModel).asSingleton();
		injector.map(TuioTouchesStackableProcessesModel).asSingleton();

		#if !omitTuioComms
		injector.map(TuioService).asSingleton();
		injector.map(MultitactionCardListener).asSingleton();
		#end
		injector.map(TuioDebugViewsLogic).asSingleton();
		
		mediatorMap.map(TouchDebugView).toMediator(TouchDebugViewMediator);
		mediatorMap.map(DebugTuioFiltersView).toMediator(DebugTuioFiltersViewMediator);
		mediatorMap.map(DebugTuioTouchPanelView).toMediator(DebugTuioTouchPanelViewMediator);		
		
		commandMap.map(StartupCompleteSignal).toCommand(TuioDebugKeyboardCommand);		
	}
}
package imagsyd.multitaction.tuio;

import imagsyd.multitaction.command.TuioDebugKeyboardCommand;
import imagsyd.multitaction.logic.TuioDebugViewsLogic;
import imagsyd.multitaction.model.MarkerObjectsModel;
import imagsyd.multitaction.model.TuioMarkersStackableProcessesModel;
import imagsyd.multitaction.model.TuioTouchesSettingsModel;
import imagsyd.multitaction.tuio.TuioService;
import imagsyd.multitaction.tuio.listener.MastercardCardListener;
import imagsyd.multitaction.tuio.touch.processors.StarlingTuioTouchProcessor;
import imagsyd.multitaction.tuio.view.openfl.debug.touchPanel.DebugTuioTouchPanelView;
import imagsyd.multitaction.tuio.view.openfl.debug.touchPanel.DebugTuioTouchPanelViewMediator;
import imagsyd.multitaction.tuio.view.openfl.debug.tuioMarkers.DebugTuioFiltersView;
import imagsyd.multitaction.tuio.view.openfl.debug.tuioMarkers.DebugTuioFiltersViewMediator;
import imagsyd.multitaction.tuio.view.starling.display.touches.TouchDebugView;
import imagsyd.multitaction.tuio.view.starling.display.touches.TouchDebugViewMediator;
import robotlegs.bender.extensions.imag.impl.signals.AppSetupCompleteSignal;
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
		injector.map(TuioService).asSingleton();
		injector.map(MastercardCardListener).asSingleton();			
		injector.map(MarkerObjectsModel).asSingleton();
		injector.map(TuioMarkersStackableProcessesModel).asSingleton();
		injector.map(StarlingTuioTouchProcessor).asSingleton();		
		injector.map(TuioDebugViewsLogic).asSingleton();	
		
		mediatorMap.map(TouchDebugView).toMediator(TouchDebugViewMediator);
		mediatorMap.map(DebugTuioFiltersView).toMediator(DebugTuioFiltersViewMediator);
		mediatorMap.map(DebugTuioTouchPanelView).toMediator(DebugTuioTouchPanelViewMediator);		
		
		commandMap.map(AppSetupCompleteSignal).toCommand(TuioDebugKeyboardCommand);		
	}
}
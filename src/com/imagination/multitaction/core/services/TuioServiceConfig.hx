package com.imagination.multitaction.core.services;

//import com.imagination.multitaction.core.services.session.SessionPlacementService;
//import com.imagination.multitaction.core.services.session.SessionService;
import com.imagination.multitaction.core.commands.tuio.touch.TuioMarkerCommand;
import com.imagination.multitaction.core.commands.tuio.touch.TuioTouchCommand;
import com.imagination.multitaction.core.managers.TuioMarkerManager;
import com.imagination.multitaction.core.services.tuio.listeners.BasicListener;
import com.imagination.multitaction.core.services.tuio.listeners.MarkerInputListener;
import com.imagination.multitaction.core.services.tuio.listeners.TouchInputListener;
import com.imagination.multitaction.core.services.tuio.TuioService;
import com.imagination.multitaction.core.services.tuioPlayback.TuioPlaybackService;
import com.imagination.multitaction.core.services.tuioRecorder.TuioRecorderService;
import robotlegs.bender.extensions.imag.impl.signals.AppSetupCompleteSignal;
import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
import robotlegs.bender.framework.api.IConfig;
import robotlegs.bender.framework.api.IInjector;

/**
 * ...
 * @author Michal Moczynski
 */

@:rtti
@:keepSub
class TuioServiceConfig implements IConfig 
{
	@inject public var injector:IInjector;
	@inject public var commandMap:ISignalCommandMap;
	
	public function new() { }
	
	public function configure():Void
	{
		injector.map(TuioService).asSingleton();
		injector.map(BasicListener).asSingleton();
		injector.map(TouchInputListener).asSingleton();
//		injector.map(TuioRecorderService).asSingleton();
//		injector.map(TuioPlaybackService).asSingleton();		
		injector.map(MarkerInputListener).asSingleton();			
		commandMap.map(AppSetupCompleteSignal).toCommand(TuioMarkerCommand);		
		commandMap.map(AppSetupCompleteSignal).toCommand(TuioTouchCommand);		
	}
}
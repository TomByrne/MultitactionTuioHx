package imagsyd.imagination.commands;

import imagsyd.imagination.commands.keyboard.KeyboardCommand;
import imagsyd.imagination.commands.startup.StartupCommand;
import imagsyd.imagination.commands.tuio.touch.TuioMarkerCommand;
import imagsyd.imagination.commands.tuio.touch.TuioTouchCommand;
import imagsyd.imagination.signals.context.ContentReadySignal;
import imagsyd.imagination.signals.example.ExampleSignal;
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
class CommandConfig implements IConfig 
{
	@inject public var commandMap:ISignalCommandMap;
	@inject public var injector:IInjector;
	
	public function new() { }
	
	public function configure():Void
	{
		commandMap.map(AppSetupCompleteSignal).toCommand(KeyboardCommand);
		commandMap.map(AppSetupCompleteSignal).toCommand(StartupCommand);
		commandMap.map(ContentReadySignal).toCommand(TuioTouchCommand);
		commandMap.map(ContentReadySignal).toCommand(TuioMarkerCommand);
		
		
		// Only if not already mapped to a command
		injector.map(ExampleSignal).asSingleton();
	}
}
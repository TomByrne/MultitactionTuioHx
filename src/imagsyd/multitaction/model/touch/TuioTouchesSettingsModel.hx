package imagsyd.multitaction.model.touch;
import imagsyd.notifier.Notifier;

/**
 * ...
 * @author Michal Moczynski
 */
class TuioTouchesSettingsModel 
{
	public var useTuioTouches:Notifier<Bool> = new Notifier<Bool>(true);
	public var useWindoesTouches:Notifier<Bool> = new Notifier<Bool>(true);
	public var showTouches:Notifier<Bool> = new Notifier<Bool>(true);
	
	public function new() 
	{
		useTuioTouches.change.add( handleTuioNotifierChange );
		useWindoesTouches.change.add( handleWindowsNotifierChange );
	}
	
	function handleTuioNotifierChange():Void 
	{
		useWindoesTouches.value = !useTuioTouches.value;
	}
	
	function handleWindowsNotifierChange():Void 
	{
		useTuioTouches.value = !useWindoesTouches.value;
	}	
}
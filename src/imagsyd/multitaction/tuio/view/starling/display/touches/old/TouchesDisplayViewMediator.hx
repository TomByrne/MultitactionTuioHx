package imagsyd.multitaction.tuio.view.starling.display.touches.old;
import com.imagination.core.managers.touch.TouchManager;
import imagsyd.multitaction.tuio.view.starling.display.touches.old.TouchesDisplayView;
import imagsyd.multitaction.tuio.view.starling.display.touches.old.touch.TouchPoint;
import imagsyd.multitaction.tuio.view.starling.display.touches.old.touch.TouchPointMediator;
import robotlegs.bender.bundles.mvcs.Mediator;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
import starling.core.Starling;
import starling.events.Touch;

/**
 * ...
 * @author Michal Moczynski
 */
class TouchesDisplayViewMediator extends Mediator 
{
	@inject public var view:TouchesDisplayView;
	@inject public var mediatorMap:IMediatorMap;
	
	public function new() 
	{
	}
	
	override public function initialize():Void
	{
		view.initialize();
	}
	
	function touchEnded(t:Touch) 
	{
		view.removeIndicator(t);
	}
	
	function touchMoved(t:Touch) 
	{
		view.updateIndicator(t);
	}
	
	function touchBegan(t:Touch) 
	{
		view.addIndicator(t);
	}
	
	override public function destroy():Void
	{
		view.dispose();
	}
	
	override public function postDestroy():Void
	{
		super.postDestroy();
	}
}
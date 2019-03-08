package multitaction.tuio.view.starling.display.touches.old.touch;
import multitaction.tuio.view.starling.display.touches.old.touch.TouchPoint;
import robotlegs.bender.bundles.mvcs.Mediator;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;

/**
 * ...
 * @author Michal Moczynski
 */
class TouchPointMediator extends Mediator 
{
	@inject public var view:TouchPoint;
	@inject public var mediatorMap:IMediatorMap;
	
	public function new() 
	{
	}
	
	override public function initialize():Void
	{
		view.initialize();
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
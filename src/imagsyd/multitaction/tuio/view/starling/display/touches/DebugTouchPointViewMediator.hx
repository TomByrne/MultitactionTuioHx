package imagsyd.multitaction.tuio.view.starling.display.touches;
import imagsyd.multitaction.tuio.view.starling.display.touches.DebugTouchPointView;
import robotlegs.bender.bundles.mvcs.Mediator;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;

/**
 * ...
 * @author Michal Moczynski
 */

@:rtti
class DebugTouchPointViewMediator extends Mediator 
{
	@inject public var view:DebugTouchPointView;
	@inject public var mediatorMap:IMediatorMap;
	
	public function new() 
	{
	}
	
	override public function initialize():Void
	{
		//mediatorMap.map(ChildView).toMediator(ChildViewMediator);
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
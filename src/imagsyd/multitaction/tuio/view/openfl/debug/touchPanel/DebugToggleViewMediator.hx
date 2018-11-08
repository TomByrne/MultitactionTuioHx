package imagsyd.multitaction.tuio.view.openfl.debug.touchPanel;
import openfl.events.MouseEvent;
import robotlegs.bender.bundles.mvcs.Mediator;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;

/**
 * ...
 * @author Michal Moczynski
 */

@:rtti
class DebugToggleViewMediator extends Mediator 
{
	@inject public var view:DebugToggleView;
	@inject public var mediatorMap:IMediatorMap;
	
	public function new() 
	{
	}
	
	override public function initialize():Void
	{
		//mediatorMap.map(ChildView).toMediator(ChildViewMediator);
		view.initialize();
		view.notifier.change.add( handleNotifierChange );
		view.addEventListener(MouseEvent.CLICK, handleMouseClick );
		view.updateIndicator(view.notifier.value);
	}
	
	function handleMouseClick(e:MouseEvent):Void 
	{
		view.notifier.value = !view.notifier.value;
	}
	
	function handleNotifierChange():Void
	{
		view.updateIndicator( view.notifier.value );		
	}
	
	override public function destroy():Void
	{
		//view.dispose();
	}
	
	override public function postDestroy():Void
	{
		super.postDestroy();
	}
}
package multitaction.view.openfl.debug.element;

import openfl.events.MouseEvent;
import robotlegs.bender.bundles.mvcs.Mediator;

/**
 * ...
 * @author Michal Moczynski
 */
 @:noCompletion
class MultitactionProcessDebugViewMediator extends Mediator 
{
	@inject public var view:MultitactionProcessDebugView;
	
	public function new() 
	{
	}
	
	override public function initialize():Void
	{
		view.processor.active.add( handleProcessorActveChanged );
		view.initialize();
		handleProcessorActveChanged();
		
		view.addEventListener( MouseEvent.CLICK, handleMouseClick);
	}
	
	function handleMouseClick(e:MouseEvent):Void 
	{
		view.processor.active.value = !view.processor.active.value;
	}
		
	function handleProcessorActveChanged():Void 
	{
		view.setActicve( view.processor.active.value );
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
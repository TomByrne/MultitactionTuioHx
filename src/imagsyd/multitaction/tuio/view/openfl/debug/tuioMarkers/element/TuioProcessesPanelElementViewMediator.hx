package imagsyd.multitaction.tuio.view.openfl.debug.tuioMarkers.element;
import com.imagination.core.managers.touch.TouchManager;
import openfl.events.MouseEvent;
import robotlegs.bender.bundles.mvcs.Mediator;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
import starling.events.Touch;

/**
 * ...
 * @author Michal Moczynski
 */

@:rtti
class TuioProcessesPanelElementViewMediator extends Mediator 
{
	@inject public var view:TuioProcessesPanelElementView;
	@inject public var mediatorMap:IMediatorMap;
	
	public function new() 
	{
	}
	
	override public function initialize():Void
	{
		view.processor.active.change.add( handleProcessorActveChanged );
		//mediatorMap.map(ChildView).toMediator(ChildViewMediator);
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
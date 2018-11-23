package imagsyd.multitaction.tuio.view.starling.display.touches;
import imagsyd.deprecated.touch.TouchManager;
import imagsyd.multitaction.model.TuioTouchesSettingsModel;
import imagsyd.multitaction.tuio.view.starling.display.touches.DebugTouchPointView;
import imagsyd.multitaction.tuio.view.starling.display.touches.DebugTouchPointViewMediator;
import imagsyd.multitaction.tuio.view.starling.display.touches.TouchDebugView;
import robotlegs.bender.bundles.mvcs.Mediator;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
import starling.core.Starling;
import starling.events.Touch;

/**
 * ...
 * @author Michal Moczynski
 */

@:rtti
class TouchDebugViewMediator extends Mediator 
{
	var active:Bool;
	@inject public var view:TouchDebugView;
	@inject public var mediatorMap:IMediatorMap;
	@inject public var tuioTouchSettingsModel:TuioTouchesSettingsModel;
	
	public function new() 
	{
	}
	
	override public function initialize():Void
	{
		mediatorMap.map(DebugTouchPointView).toMediator(DebugTouchPointViewMediator);
		view.initialize();
		
		TouchManager.add( view ).setBegin( handleTouchBegin );
		TouchManager.add( view ).setMove( handleTouchMove );
		TouchManager.add( view ).setEnd( handleTouchEnd );
		
		handleShowChanged();
		tuioTouchSettingsModel.showTouches.change.add( handleShowChanged );
	}
	
	function handleShowChanged():Void
	{
		active = tuioTouchSettingsModel.showTouches.value;
		view.visible = active;
	}	
	
	function handleTouchBegin(t:Touch):Void 
	{
		if(active)
			view.handleTouchBegin(t);
	}
	
	function handleTouchMove(t:Touch):Void 
	{
		if(active)
			view.handleTouchMove(t);
	}
	
	function handleTouchEnd(t:Touch):Void 
	{
		if(active)
			view.handleTouchEnd(t);
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
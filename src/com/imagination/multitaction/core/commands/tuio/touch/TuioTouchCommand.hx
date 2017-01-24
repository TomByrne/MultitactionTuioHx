package com.imagination.multitaction.core.commands.tuio.touch;

import com.imagination.core.managers.resize.Resize;
import com.imagination.multitaction.core.services.tuio.listeners.TouchInputListener;
import robotlegs.bender.bundles.mvcs.Command;
import robotlegs.bender.extensions.contextView.ContextView;
import starling.core.Starling;
import starling.events.Touch;

/**
 * ...
 * @author Michal Moczynski
 */
class TuioTouchCommand extends Command 
{
	@inject public var touchInputListener:TouchInputListener;
	@inject public var contextView:ContextView;
	
	public function TuioTouchCommand() { }
	
	override public function execute():Void
	{
		touchInputListener.width = contextView.view.stage.stageWidth;
		touchInputListener.height = contextView.view.stage.stageHeight;
		touchInputListener.onBegin.add(enqueue);
		touchInputListener.onMove.add(enqueue);
		touchInputListener.onEnd.add(enqueue);
		
		Resize.onResize.add(OnStageResize);
	}
	
	private function OnStageResize():Void 
	{
		touchInputListener.width = contextView.view.stage.stageWidth;
		touchInputListener.height = contextView.view.stage.stageHeight;
	}
	
	private function enqueue(touch:Touch):Void 
	{
		//log(this, "enqueue: " + touch);
//		trace("enqueue: " + touch);
		Starling.current.touchProcessor.enqueue(touch.id, touch.phase, touch.globalX, touch.globalY, 1, 20, 20);
	}
}

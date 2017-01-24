package com.imagination.multitaction.core.commands.tuio.touch;

import com.imagination.core.managers.resize.Resize;
import com.imagination.multitaction.core.services.tuio.listeners.MarkerInputListener;
import robotlegs.bender.bundles.mvcs.Command;
import robotlegs.bender.extensions.contextView.ContextView;
import starling.core.Starling;
import starling.events.Touch;

/**
 * ...
 * @author Michal Moczynski
 */
class TuioMarkerCommand extends Command 
{
	@inject public var markerInputListener:MarkerInputListener;
	@inject public var contextView:ContextView;
	
	public function TuioMarkerCommand() { }
	
	override public function execute():Void
	{
		markerInputListener.width = contextView.view.stage.stageWidth;
		markerInputListener.height = contextView.view.stage.stageHeight;
		/*
		markerInputListener.onBegin.add(enqueue);
		markerInputListener.onMove.add(enqueue);
		markerInputListener.onEnd.add(enqueue);
		*/
		
		Resize.onResize.add(OnStageResize);
	}
	
	private function OnStageResize():Void 
	{
		markerInputListener.width = contextView.view.stage.stageWidth;
		markerInputListener.height = contextView.view.stage.stageHeight;
	}
	
	private function enqueue(touch:Touch):Void 
	{
		Starling.current.touchProcessor.enqueue(touch.id, touch.phase, touch.globalX, touch.globalY, 1, 20, 20);
	}
}

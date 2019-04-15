package multitaction.debug.panel;

import multitaction.model.marker.IMarkerObjectsModel;
import multitaction.model.marker.MarkerProcessorsModel;
import multitaction.debug.panel.MultitactionDebugPanel;
import multitaction.debug.panel.element.MultitactionProcessDebugView;
import multitaction.debug.panel.element.MultitactionProcessDebugViewMediator;
import robotlegs.bender.bundles.mvcs.Mediator;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
import multitaction.model.settings.MultitactionSettingsModel;

/**
 * ...
 * @author Michal Moczynski
 */
class MultitactionDebugPanelMediator extends Mediator 
{
	@inject public var view:MultitactionDebugPanel;
	@inject public var mediatorMap:IMediatorMap;
	@inject public var tuioStackableProcessesModel:MarkerProcessorsModel;	
	@inject public var markerObjectsModel:IMarkerObjectsModel;
	@inject public var multitactionSettingsModel:MultitactionSettingsModel;
	
	public function new() 
	{
	}
	
	override public function initialize():Void
	{
		mediatorMap.map(MultitactionProcessDebugView).toMediator(MultitactionProcessDebugViewMediator);
		view.initialize(multitactionSettingsModel.debugTouchShown, multitactionSettingsModel.debugMarkerShown, tuioStackableProcessesModel.tuioMarkerProcessors, markerObjectsModel.markerObjectsMap);
	}
	
	override public function destroy():Void
	{
//		view.dispose();
	}
	
	override public function postDestroy():Void
	{
		super.postDestroy();
	}
}
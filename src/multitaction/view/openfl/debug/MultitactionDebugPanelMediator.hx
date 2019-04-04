package multitaction.view.openfl.debug;
import multitaction.model.marker.MarkerObjectsModel;
import multitaction.model.marker.MarkerProcessorsModel;
import multitaction.view.openfl.debug.MultitactionDebugPanel;
import multitaction.view.openfl.debug.element.MultitactionProcessDebugView;
import multitaction.view.openfl.debug.element.MultitactionProcessDebugViewMediator;
import robotlegs.bender.bundles.mvcs.Mediator;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
import multitaction.model.settings.MultitactionSettingsModel;

/**
 * ...
 * @author Michal Moczynski
 */

@:rtti
class MultitactionDebugPanelMediator extends Mediator 
{
	@inject public var view:MultitactionDebugPanel;
	@inject public var mediatorMap:IMediatorMap;
	@inject public var tuioStackableProcessesModel:MarkerProcessorsModel;	
	@inject public var markerObjectsModel:MarkerObjectsModel;
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
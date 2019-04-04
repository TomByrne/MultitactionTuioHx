package multitaction.view.starling.marker;

import multitaction.model.marker.IMarkerObjectsModel;
import robotlegs.bender.bundles.mvcs.Mediator;
import multitaction.model.settings.MultitactionSettingsModel;

/**
 * ...
 * @author Michal Moczynski
 */

@:rtti
class DebugMarkersViewMediator extends Mediator 
{
	@inject public var view:DebugMarkersView;
	@inject public var markerObjectsModel:IMarkerObjectsModel;
	@inject public var multitactionSettingsModel:MultitactionSettingsModel;
	
	public function new() 
	{
	}
	
	override public function initialize():Void
	{
		view.initialize(markerObjectsModel);
		multitactionSettingsModel.debugMarkerShown.add( handleShowChanged );
        handleShowChanged();
	}
	
	function handleShowChanged():Void
	{
		view.visible = multitactionSettingsModel.debugMarkerShown.value;
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
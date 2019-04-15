package multitaction.debug.overlay;

import robotlegs.bender.extensions.contextView.ContextView;
import multitaction.model.settings.MultitactionSettingsModel;
import multitaction.debug.overlay.touch.DebugTouchesView;
import multitaction.debug.overlay.marker.DebugMarkersView;
import org.swiftsuspenders.utils.DescribedType;
import openfl.Lib;

/**
 * ...
 * @author Michal Moczynski
 * @author Thomas Byrne
 */
class MultitactionDebugOverlays implements DescribedType
{
	@inject public var multitactionSettingsModel:MultitactionSettingsModel;	
	@inject public var contextView:ContextView;

	var debugTouchesView:DebugTouchesView;
	var debugMarkersView:DebugMarkersView;

	
	@:keep public function setup() 
	{
		multitactionSettingsModel.debugTouchShown.add( onDebugTouchShownChanged );
		multitactionSettingsModel.debugMarkerShown.add( onDebugMarkerShownChanged );

        onDebugTouchShownChanged();
        onDebugMarkerShownChanged();
	}
	
	function onDebugTouchShownChanged():Void
	{
		if (multitactionSettingsModel.debugTouchShown.value && debugTouchesView == null)
		{
			debugTouchesView = new DebugTouchesView();
            contextView.view.addChild(debugTouchesView);
		}
	}
	
	function onDebugMarkerShownChanged():Void
	{
		if (multitactionSettingsModel.debugMarkerShown.value && debugMarkersView == null)
		{
			debugMarkersView = new DebugMarkersView();
            contextView.view.addChild(debugMarkersView);
		}
	}
	
}
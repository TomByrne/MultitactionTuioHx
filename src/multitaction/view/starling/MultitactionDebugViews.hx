package multitaction.view.starling;

import multitaction.model.settings.MultitactionSettingsModel;
import multitaction.view.starling.touch.DebugTouchesView;
import multitaction.view.starling.marker.DebugMarkersView;
import starling.core.Starling;
import org.swiftsuspenders.utils.DescribedType;

/**
 * ...
 * @author Michal Moczynski
 * @author Thomas Byrne
 */
class MultitactionDebugViews implements DescribedType
{
	@inject public var multitactionSettingsModel:MultitactionSettingsModel;	

	static var debugTouchesView:DebugTouchesView;
	static var debugMarkersView:DebugMarkersView;

	
	public function setup() 
	{
		multitactionSettingsModel.debugTouchShown.add( onDebugTouchShownChanged );
		multitactionSettingsModel.debugMarkerShown.add( onDebugMarkerShownChanged );

        onDebugTouchShownChanged();
        onDebugMarkerShownChanged();
	}
	
	function onDebugTouchShownChanged():Void
	{
		if (multitactionSettingsModel.debugTouchShown.value)
		{
			debugTouchesView = new DebugTouchesView();
			Starling.current.stage.addChild( debugTouchesView );
		}
		else if (debugTouchesView != null)
        {
            debugTouchesView.removeFromParent(true);
        }
	}
	
	function onDebugMarkerShownChanged():Void
	{
		if (multitactionSettingsModel.debugMarkerShown.value)
		{
			debugMarkersView = new DebugMarkersView();
			Starling.current.stage.addChild( debugMarkersView );
		}
		else if (debugMarkersView != null)
        {
            debugMarkersView.removeFromParent(true);
        }
	}
	
}
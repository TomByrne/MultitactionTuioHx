package multitaction.logic.processors;

import imagsyd.base.ISettings;
import org.swiftsuspenders.utils.DescribedType;
import multitaction.model.touch.TouchProcessorsModel;
import multitaction.model.marker.IMarkerObjectsModel;
import multitaction.model.touch.ITouchObjectsModel;
import multitaction.logic.processors.touch.*;
import multitaction.model.settings.MultitactionSettingsModel;

class TouchProcessorsLogic implements DescribedType
{
	@inject public var markerObjectsModel:IMarkerObjectsModel;
	@inject public var touchObjectsModel:ITouchObjectsModel;
	@inject public var touchProcessorsModel:TouchProcessorsModel;
	@inject public var multitactionSettingsModel:MultitactionSettingsModel;
	@inject public var settings:ISettings;

    @:keep public function setup()
    {
		touchProcessorsModel.tuioTouchProcessors.push( new FlipOrientationTouchProcessor(settings.bool('tuioFlippedOrientation', false), touchObjectsModel ));
		touchProcessorsModel.tuioTouchProcessors.push( new MarkerProximityTouchFilter(true, markerObjectsModel, touchObjectsModel ));
		touchProcessorsModel.tuioTouchProcessors.push( new FractionToPixelsTouchProcessor(true, touchObjectsModel, multitactionSettingsModel.nativeScreenSize ));
    }
}
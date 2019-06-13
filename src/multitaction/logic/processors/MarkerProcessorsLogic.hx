package multitaction.logic.processors;

import imagsyd.base.ISettings;
import org.swiftsuspenders.utils.DescribedType;
import multitaction.logic.processors.marker.*;
import multitaction.model.marker.MarkerProcessorsModel;
import multitaction.model.marker.IMarkerObjectsModel;
import multitaction.model.settings.MultitactionSettingsModel;

class MarkerProcessorsLogic implements DescribedType
{
	@inject public var settings:ISettings;
	@inject public var markerObjectsModel:IMarkerObjectsModel;
	@inject public var markerProcessorsModel:MarkerProcessorsModel;
	@inject public var multitactionSettingsModel:MultitactionSettingsModel;
	@inject public var appSpaceConversionMarkerProcessor:AppSpaceConversionMarkerProcessor;

    @:keep public function setup()
    {
//		markerProcessorsModel.tuioMarkerProcessors.push( new FlipOrientationMarkerProcessor(settings.bool('tuioFlippedOrientation', false), markerObjectsModel ));
		markerProcessorsModel.tuioMarkerProcessors.push( new SimpleMarkerFromMarkerProcessor(false, markerObjectsModel) );
		markerProcessorsModel.tuioMarkerProcessors.push( new FlickeringFilterMarkerProcessor(true, markerObjectsModel, settings.get('tuio_safety_width'), settings.get('tuio_safety_speed_max_multi') ));
		markerProcessorsModel.tuioMarkerProcessors.push( new RotateMarkersMarkerProcessor(true, markerObjectsModel, settings.get('tuioRotationOffset')));
		markerProcessorsModel.tuioMarkerProcessors.push( new SnapAnglesMarkerProcessor(false, markerObjectsModel));
		markerProcessorsModel.tuioMarkerProcessors.push( new FractionToPixelsMarkerProcessor(true, markerObjectsModel, multitactionSettingsModel.nativeScreenSize ) );
		markerProcessorsModel.tuioMarkerProcessors.push( new SmoothMarkerProcessor(false, markerObjectsModel, multitactionSettingsModel.nativeScreenSize) );
		markerProcessorsModel.tuioMarkerProcessors.push( appSpaceConversionMarkerProcessor );
    }
}
package multitaction.logic.processors;

import org.swiftsuspenders.utils.DescribedType;
import multitaction.logic.processors.marker.*;
import multitaction.model.marker.MarkerProcessorsModel;
import multitaction.model.marker.IMarkerObjectsModel;
import multitaction.model.settings.MultitactionSettingsModel;

class MarkerProcessorsLogic implements DescribedType
{
	@inject public var markerObjectsModel:IMarkerObjectsModel;
	@inject public var markerProcessorsModel:MarkerProcessorsModel;
	@inject public var multitactionSettingsModel:MultitactionSettingsModel;
	@inject public var appSpaceConversionMarkerProcessor:AppSpaceConversionMarkerProcessor;

    public function setup()
    {
		markerProcessorsModel.tuioMarkerProcessors.push( new SimpleMarkerFromMarkerProcessor(false, markerObjectsModel) );
		markerProcessorsModel.tuioMarkerProcessors.push( new FlickeringFilterMarkerProcessor(true, markerObjectsModel));
		markerProcessorsModel.tuioMarkerProcessors.push( new SnapAnglesMarkerProcessor(false, markerObjectsModel));
		markerProcessorsModel.tuioMarkerProcessors.push( new FractionToPixelsMarkerProcessor(true, markerObjectsModel, multitactionSettingsModel.nativeScreenSize ) );
		markerProcessorsModel.tuioMarkerProcessors.push( new SmoothMarkerProcessor(false, markerObjectsModel, multitactionSettingsModel.nativeScreenSize) );
		markerProcessorsModel.tuioMarkerProcessors.push( appSpaceConversionMarkerProcessor );
    }
}
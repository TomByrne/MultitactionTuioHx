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

    public function setup()
    {
		markerProcessorsModel.tuioMarkerProcessors.push( new SimpleMarkerFromTuioProcessor(false, markerObjectsModel) );
		markerProcessorsModel.tuioMarkerProcessors.push( new FlickeringFilterMarkerFromTuioProcessor(true, markerObjectsModel));
		markerProcessorsModel.tuioMarkerProcessors.push( new SnapAnglesTuioProcessor(false, markerObjectsModel));
		markerProcessorsModel.tuioMarkerProcessors.push( new FractionToPixelsTuioProcessor(true, markerObjectsModel, multitactionSettingsModel.nativeScreenSize ) );
		markerProcessorsModel.tuioMarkerProcessors.push( new SmoothProcessor(false, markerObjectsModel, multitactionSettingsModel.nativeScreenSize) );
    }
}
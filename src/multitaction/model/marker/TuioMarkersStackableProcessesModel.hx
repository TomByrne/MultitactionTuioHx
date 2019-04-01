package multitaction.model.marker;
import multitaction.model.marker.MarkerObjectsModel;
import multitaction.model.settings.TuioSettingsModel;
import multitaction.tuio.processors.marker.SimpleMarkerFromTuioProcessor;
import multitaction.tuio.processors.marker.FractionToPixelsTuioProcessor;
import multitaction.tuio.processors.marker.FlickeringFilterMarkerFromTuioProcessor;
import multitaction.tuio.processors.marker.SmoothProcessor;
import multitaction.tuio.processors.marker.SnapAnglesTuioProcessor;
import multitaction.tuio.processors.marker.base.ITuioStackableProcessor;

/**
 * ...
 * @author Michal Moczynski
 */
@:rtti
class TuioMarkersStackableProcessesModel 
{
	@inject public var markerObjectsModel:MarkerObjectsModel;
	@inject public var tuioSettingsModel:TuioSettingsModel;
	public var tuioMarkerProcessors:Array<ITuioStackableProcessor> = [];
	
	
	public function new() 
	{
	}
	
	public function start()
	{
		tuioMarkerProcessors.push( new SimpleMarkerFromTuioProcessor(false, markerObjectsModel) );
		tuioMarkerProcessors.push( new FlickeringFilterMarkerFromTuioProcessor(true, markerObjectsModel));
//		tuioMarkerProcessors.push( new SnapAnglesTuioProcessor(true, markerObjectsModel));
		tuioMarkerProcessors.push( new FractionToPixelsTuioProcessor(true, markerObjectsModel, tuioSettingsModel.nativeScreenSize.value ) );
		tuioMarkerProcessors.push( new SmoothProcessor(false, markerObjectsModel) );
	}
	
}

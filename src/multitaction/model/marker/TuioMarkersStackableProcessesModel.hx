package multitaction.model.marker;
import multitaction.model.marker.MarkerObjectsModel;
import multitaction.model.settings.TuioSettingsModel;
import multitaction.tuio.processors.maker.SimpleMarkerFromTuioProcessor;
import multitaction.tuio.processors.maker.FractionToPixelsTuioProcessor;
import multitaction.tuio.processors.maker.FlickeringFilterMarkerFromTuioProcessor;
import multitaction.tuio.processors.maker.SmoothProcessor;
import multitaction.tuio.processors.maker.SnapAnglesTuioProcessor;
import multitaction.tuio.processors.maker.base.ITuioStackableProcessor;

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

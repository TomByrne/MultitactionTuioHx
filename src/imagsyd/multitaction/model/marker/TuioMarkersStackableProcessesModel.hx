package imagsyd.multitaction.model.marker;
import imagsyd.multitaction.model.marker.MarkerObjectsModel;
import imagsyd.multitaction.model.settings.TuioSettingsModel;
import imagsyd.multitaction.tuio.processors.maker.SimpleMarkerFromTuioProcessor;
import imagsyd.multitaction.tuio.processors.maker.FractionToPixelsTuioProcessor;
import imagsyd.multitaction.tuio.processors.maker.FlickeringFilterMarkerFromTuioProcessor;
import imagsyd.multitaction.tuio.processors.maker.SmoothProcessor;
import imagsyd.multitaction.tuio.processors.maker.SnapAnglesTuioProcessor;
import imagsyd.multitaction.tuio.processors.maker.base.ITuioStackableProcessor;

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

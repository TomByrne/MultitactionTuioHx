package imagsyd.multitaction.model;
import com.imagination.util.time.Delay;
import imagsyd.multitaction.tuio.processors.SimpleMarkerFromTuioProcessor;
import imagsyd.multitaction.tuio.processors.FractionToPixelsTuioProcessor;
import imagsyd.multitaction.tuio.processors.FlickeringFilterMarkerFromTuioProcessor;
import imagsyd.multitaction.tuio.processors.SmoothProcessor;
import imagsyd.multitaction.tuio.processors.base.ITuioStackableProcessor;
import imagsyd.multitaction.tuio.processors.SnapAnglesTuioProcessor;

/**
 * ...
 * @author Michal Moczynski
 */
@:rtti
class TuioMarkersStackableProcessesModel 
{
	@inject public var markerObjectsModel:MarkerObjectsModel;
	public var tuioProcessors:Array<ITuioStackableProcessor> = [];
	
	
	public function new() 
	{
	}
	
	public function start()
	{
		Delay.byTime(1, startFitering);
	}
	
	function startFitering():Void 
	{
		tuioProcessors.push( new SimpleMarkerFromTuioProcessor(false, markerObjectsModel) );
		tuioProcessors.push( new FlickeringFilterMarkerFromTuioProcessor(true, markerObjectsModel));
//		tuioProcessors.push( new SnapAnglesTuioProcessor(true, markerObjectsModel));
		tuioProcessors.push( new FractionToPixelsTuioProcessor(false, markerObjectsModel) );
		tuioProcessors.push( new SmoothProcessor(true, markerObjectsModel) );
	}
	
}

package imagsyd.multitaction.model;
import imagsyd.time.Delay;
import imagsyd.multitaction.tuio.processors.ForwardTuioProcessor;
import imagsyd.multitaction.tuio.processors.FractionToPixelsTuioProcessor;
import imagsyd.multitaction.tuio.processors.TuioMarkerFlickeringFilter;
import imagsyd.multitaction.tuio.processors.base.ITuioStackableProcessor;
import imagsyd.multitaction.tuio.processors.RemoveOldTuioProcessor;
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
		tuioProcessors.push( new ForwardTuioProcessor(true, markerObjectsModel) );
//		tuioProcessors.push( new TuioMarkerFlickeringFilter(false));
//		tuioProcessors.push( new RemoveOldTuioProcessor(true));//rather keep it before movin rom fracion to pixels
//		tuioProcessors.push( new SnapAnglesTuioProcessor(true));
		tuioProcessors.push( new FractionToPixelsTuioProcessor(true, markerObjectsModel) );
	}
	
}

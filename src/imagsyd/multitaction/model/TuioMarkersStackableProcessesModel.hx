package imagsyd.multitaction.model;
import imagsyd.multitaction.tuio.processors.ForwardTuioProcessor;
import imagsyd.multitaction.tuio.processors.base.ITuioStackableProcessor;
import imagsyd.multitaction.tuio.processors.RemoveOldTuioProcessor;
import imagsyd.multitaction.tuio.processors.SnapAnglesTuioProcessor;

/**
 * ...
 * @author Michal Moczynski
 */
class TuioMarkersStackableProcessesModel 
{
	public var tuioProcessors:Array<ITuioStackableProcessor> = [];
	
	public function new() 
	{
		tuioProcessors.push( new ForwardTuioProcessor(true));
		tuioProcessors.push( new RemoveOldTuioProcessor(true));
		tuioProcessors.push( new SnapAnglesTuioProcessor(true));
	}
	
}

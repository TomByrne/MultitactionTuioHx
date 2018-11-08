package imagsyd.multitaction.model;
import imagsyd.multitaction.tuio.processors.SnapAnglesTuioProcessor;

/**
 * ...
 * @author Michal Moczynski
 */
class TuioTouchStackableProcessesModel 
{

	public var tuioProcessors:Array<ITuioStackableProcessor> = [];
	
	public function new() 
	{
		tuioProcessors.push( new ForwardTuioProcessor());
		tuioProcessors.push( new MastercardTuioProcessor());
		tuioProcessors.push( new SnapAnglesTuioProcessor());
	}
	
}

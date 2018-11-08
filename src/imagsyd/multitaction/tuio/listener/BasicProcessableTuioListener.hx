package imagsyd.multitaction.tuio.listener;
import imagsyd.multitaction.model.ITuioObjectsModel;
import imagsyd.multitaction.tuio.processors.base.ITuioStackableProcessor;
import org.tuio.TuioObject;

/**
 * @author Michal Moczynski
 */
class BasicProcessableTuioListener extends BasicTuioListener
{
	public var tuioObjects:Map<UInt, TuioObject> = new Map<UInt, TuioObject>(); // by sessionID that is unique every time you puta marker	
	public var processes:Array<ITuioStackableProcessor> = new Array<ITuioStackableProcessor>();
	public var frame:Int;
	
	public var tuioObjectsModel:ITuioObjectsModel;
	
	public function new() 
	{
		super();
	}
	
	override public function newFrame(id:Int):Void 
	{
		super.newFrame(id);
		frame = id;
		
		for (i in 0 ... processes.length) 
		{
			if (processes[i].active.value)
			{
				processes[i].process(this, tuioObjectsModel.tuioObjects, tuioObjectsModel.tuioObjectsMap);
			}
		}
	}
	
	public function addProcess( process:ITuioStackableProcessor )
	{
		processes.push( process );
	}	
	
	public function removeProcess( process:ITuioStackableProcessor )
	{
		var i:Int = 0;
		for ( p in processes) 
		{
			if ( p == process)
			{
				processes.splice(i, 1);
				break;
			}
			i++;
		}
		Logger.warn(this, "Tuio stackable process requested to be removed but not found in processes stack");
	}
	
	public function addProcessAt( process:ITuioStackableProcessor, position:Int )
	{
		if (position < 0)
		{
			Logger.warn(this, "Tuio stackable process requested to be added at position " + position + ". Position has to be greater than 0. Adding at " + processes.length);
			position = 0;
		}
		else if (processes.length < position)
		{
			Logger.warn(this, "Tuio stackable process requested to be added at position " + position + " but the current length of the stack is " + processes.length + ". Adding at " + processes.length);
			position = processes.length;
		}
		
		if (processes.length == position)
		{
			processes.push(process);
		}
		else if ( position == 0)
		{
			processes.unshift(process);
		}
		else
		{
			processes.insert(position, process);
		}
		
	}
	
	
}
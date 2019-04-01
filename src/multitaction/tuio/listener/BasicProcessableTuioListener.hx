package multitaction.tuio.listener;
import multitaction.model.marker.IMarkerObjectsModel;
import multitaction.model.touch.ITouchObjectsModel;
import multitaction.tuio.processors.marker.base.ITuioStackableProcessor;
import org.tuio.TuioCursor;
import org.tuio.TuioObject;

/**
 * @author Michal Moczynski
 */
class BasicProcessableTuioListener extends BasicTuioListener
{
	var numberOfStoredRemovedTuio:Int = 10;
	public var tuioObjects:Map<UInt, TuioObject> = new Map<UInt, TuioObject>(); // by sessionID that is unique every time you puta marker	
	public var tuioCursors:Map<UInt, TuioCursor> = new Map<UInt, TuioCursor>(); // by sessionID that is unique every time you puta marker	
	public var removedTuioObjects:Array<TuioObject> = new Array<TuioObject>();
	public var markerProcesses:Array<ITuioStackableProcessor> = new Array<ITuioStackableProcessor>();
	public var touchProcesses:Array<ITuioStackableProcessor> = new Array<ITuioStackableProcessor>();
	public var frame:Int;
	
	public var markerObjectsModel:IMarkerObjectsModel;
	public var touchObjectsModel:ITouchObjectsModel;
	
	public function new() 
	{
		super();
	}
	
	override public function newFrame(id:Int):Void 
	{
		super.newFrame(id);
		frame = id;
		
		for (i in 0 ... markerProcesses.length) 
		{
			markerObjectsModel.tick();
			if (markerProcesses[i].active.value)
			{
				markerProcesses[i].process(this);
			}
			markerObjectsModel.processed();
		}
		
		for (i in 0 ... touchProcesses.length) 
		{
			touchObjectsModel.tick();
			if (touchProcesses[i].active.value)
			{
				touchProcesses[i].process(this);
			}
			touchObjectsModel.processed();
		}
	}
	
	public function addMarkerProcess( process:ITuioStackableProcessor )
	{
		markerProcesses.push( process );
	}	
	
	public function removeMarkerProcess( process:ITuioStackableProcessor )
	{
		var i:Int = 0;
		for ( p in markerProcesses) 
		{
			if ( p == process)
			{
				markerProcesses.splice(i, 1);
				break;
			}
			i++;
		}
		this.warn("Tuio stackable process requested to be removed but not found in markerProcesses stack");
	}
	
	public function addMarkerProcessAt( process:ITuioStackableProcessor, position:Int )
	{
		if (position < 0)
		{
			this.warn("Tuio stackable process requested to be added at position " + position + ". Position has to be greater than 0. Adding at " + markerProcesses.length);
			position = 0;
		}
		else if (markerProcesses.length < position)
		{
			this.warn("Tuio stackable process requested to be added at position " + position + " but the current length of the stack is " + markerProcesses.length + ". Adding at " + markerProcesses.length);
			position = markerProcesses.length;
		}
		
		if (markerProcesses.length == position)
		{
			markerProcesses.push(process);
		}
		else if ( position == 0)
		{
			markerProcesses.unshift(process);
		}
		else
		{
			markerProcesses.insert(position, process);
		}
		
	}
	
	
}
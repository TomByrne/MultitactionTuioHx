package multitaction.model.touch;

import org.tuio.TuioCursor;
import imagsyd.signals.Signal;

/**
 * ...
 * @author Michal Moczynski
 */
@:rtti
class TouchObjectsModel implements ITouchObjectsModel
{
	public var cursorsAdded:Map<UInt, TuioCursor> = new Map<UInt, TuioCursor>();
	public var cursorsUpdated:Map<UInt, TuioCursor> = new Map<UInt, TuioCursor>();
	public var cursorsRemoved:Map<UInt, TuioCursor> = new Map<UInt, TuioCursor>();
    
	public var onProcessed:Signal0 = new Signal0();
	
	public var touchesArray:Array<TuioCursor> = new Array<TuioCursor>();

	public function new() 
	{
		
	}

	public function tick()
	{
		touchesArray = [];
	}

    public function processed()
	{
        onProcessed.dispatch();
		cursorsAdded = new Map<UInt, TuioCursor>();
		cursorsUpdated = new Map<UInt, TuioCursor>();
		cursorsRemoved = new Map<UInt, TuioCursor>();
    }
	
}
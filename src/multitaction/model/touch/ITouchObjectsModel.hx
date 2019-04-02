package multitaction.model.touch;

import org.tuio.TuioCursor;
import imagsyd.signals.Signal;

/**
 * ...
 * @author Michal Moczynski
 */
interface ITouchObjectsModel 
{
	public var cursorsAdded:Map<UInt, TuioCursor>;
	public var cursorsUpdated:Map<UInt, TuioCursor>;
	public var cursorsRemoved:Map<UInt, TuioCursor>;
    
	public var onProcessed:Signal0;
	
	public function tick():Void;
	public function processed():Void;
}
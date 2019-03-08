package multitaction.model.touch;
import org.tuio.TuioCursor;

/**
 * ...
 * @author Michal Moczynski
 */
interface ITouchObjectsModel 
{
	public var cursorsAdded:Map<UInt, TuioCursor>;
	public var cursorsUpdated:Map<UInt, TuioCursor>;
	public var cursorsRemoved:Map<UInt, TuioCursor>;
	
	public function tick():Void;
	public function processed():Void;
}
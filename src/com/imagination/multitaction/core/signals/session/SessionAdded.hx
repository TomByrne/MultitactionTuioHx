package imagination.multitaction.core.signals.session;
import com.imagination.multitaction.core.model.session.Session;
import msignal.Signal.Signal0;
/**
 * ...
 * @author Thomas Byrne
 */
@:rtti
@:keepSub
class SessionAdded extends Signal0
{
	public var session:Session;
	
	public function new() 
	{
		
	}
	
	public function run(session:Session):Void 
	{
		this.session = session;
		dispatch();
	}
	
}
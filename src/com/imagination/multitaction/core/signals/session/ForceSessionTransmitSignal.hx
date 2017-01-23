package imagsyd.imagination.signals.session;
import imagsyd.imagination.model.session.Session;
import msignal.Signal.Signal0;

/**
 * ...
 * @author Thomas Byrne
 */
class ForceSessionTransmitSignal extends Signal0
{
	public var session:Session;
	
	public function new() 
	{
		super();
	}
	
	public function run(session:Session):Void {
		this.session = session;
		dispatch();
	}
}
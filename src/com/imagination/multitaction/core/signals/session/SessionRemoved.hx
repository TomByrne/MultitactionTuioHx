package imagsyd.imagination.signals.session;
import imagsyd.imagination.model.session.Session;
import msignal.Signal.Signal0;

/**
 * ...
 * @author Thomas Byrne
 */
class SessionRemoved extends Signal0
{
	public var session:Session;
	public var showTrans:Bool;
	
	public function new() 
	{
		super();
		
	}
	
	public function run(session:Session, showTrans:Bool):Void 
	{
		this.session = session;
		this.showTrans = showTrans;
		dispatch();
	}
}
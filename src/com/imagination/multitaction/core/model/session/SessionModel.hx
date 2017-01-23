package imagsyd.imagination.model.session;

//import imagsyd.imagination.core.model.content.ContentVO;
//import imagsyd.imagination.core.model.content.IndustryVO;
//import imagsyd.imagination.core.model.content.ObjectVO;
import imagsyd.imagination.signals.session.SessionAdded;
import imagsyd.imagination.signals.session.SessionRemoved;
import flash.utils.Dictionary;
import imagsyd.imagination.model.session.Session;
import openfl.Vector;
import org.osflash.signals.Signal;
/**
 * ...
 * @author Thomas Byrne
 */
@:rtti
@:keepSub
class SessionModel 
{
	@inject public var sessionAdded:SessionAdded;
	@inject public var sessionRemoved:SessionRemoved;
	
	public var sessionsChanged:Signal = new Signal();
	
	private var _sessions:Vector<Session>;
	private var _markerLookup:Map<SessionMarker, Session>;
	
	public function new() 
	{
		_sessions = new Vector<Session>();
		_markerLookup = new Map<SessionMarker, Session>();
	}
	
	public function createSession(marker:SessionMarker):Session {
		trace("\t\tSessionModel.createSession: "+marker.getMarkerId());
		var ret:Session = new Session();
		ret.marker = marker;
		marker.session = ret;
		_markerLookup.set(marker, ret);
		_sessions.push(ret);
		sessionAdded.run(ret);
		sessionsChanged.dispatch();
		return ret;
	}
	
	public function removeSession(marker:SessionMarker, showTrans:Bool):Void {
		trace("\t\tSessionModel.removeSession: "+marker.getMarkerId(), showTrans);
		var session:Session = _markerLookup.get(marker);
		var ind:Int = _sessions.indexOf(session);
		if (ind == -1) return;
		sessionRemoved.run(session, showTrans);
		_sessions.splice(ind, 1);
		_markerLookup.remove(marker);
		sessionsChanged.dispatch();
	}
	
	public function get_sessions():Vector<Session> 
	{
		return _sessions;
	}
	
	public function get_sessionCount():Int 
	{
		return _sessions.length;
	}
	
	
	/*
	public function selectIndustry(industry:IndustryVO, session:Session):Void 
	{
		session.selectIndustry(industry);
	}
	
	public function selectContent(content:ContentVO, session:Session):Void 
	{
		session.selectContent(content);
	}
	
	public function selectAsset(asset:ObjectVO, session:Session):Void 
	{
		session.selectAsset(asset);
	}
	*/
}
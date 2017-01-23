package imagsyd.imagination.services;

//import imagsyd.imagination.services.session.SessionPlacementService;
//import imagsyd.imagination.services.session.SessionService;
import imagsyd.imagination.managers.TuioMarkerManager;
import imagsyd.imagination.services.content.ContentService;
import imagsyd.imagination.services.tuio.listeners.BasicListener;
import imagsyd.imagination.services.tuio.listeners.MarkerInputListener;
import imagsyd.imagination.services.tuio.listeners.TouchInputListener;
import imagsyd.imagination.services.tuio.TuioService;
import imagsyd.imagination.services.tuioPlayback.TuioPlaybackService;
import imagsyd.imagination.services.tuioRecorder.TuioRecorderService;
import robotlegs.bender.framework.api.IConfig;
import robotlegs.bender.framework.api.IInjector;

/**
 * ...
 * @author Michal Moczynski
 */

@:rtti
@:keepSub
class ServiceConfig implements IConfig 
{
	@inject public var injector:IInjector;
	
	public function new() { }
	
	public function configure():Void
	{
		injector.map(TuioService).asSingleton();
		injector.map(BasicListener).asSingleton();
		injector.map(TouchInputListener).asSingleton();
		injector.map(TuioRecorderService).asSingleton();
		injector.map(TuioPlaybackService).asSingleton();
		injector.map(ContentService).asSingleton();
		
		injector.map(MarkerInputListener).asSingleton();
		injector.map(TuioMarkerManager).asSingleton();
//		injector.map(SessionService).asSingleton();
//		injector.map(SessionPlacementService).asSingleton();
	}
}
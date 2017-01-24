package imagination.multitaction.core.services;

//import com.imagination.multitaction.core.services.session.SessionPlacementService;
//import com.imagination.multitaction.core.services.session.SessionService;
import com.imagination.multitaction.core.managers.TuioMarkerManager;
import com.imagination.multitaction.core.services.content.ContentService;
import com.imagination.multitaction.core.services.tuio.listeners.BasicListener;
import com.imagination.multitaction.core.services.tuio.listeners.MarkerInputListener;
import com.imagination.multitaction.core.services.tuio.listeners.TouchInputListener;
import com.imagination.multitaction.core.services.tuio.TuioService;
import com.imagination.multitaction.core.services.tuioPlayback.TuioPlaybackService;
import com.imagination.multitaction.core.services.tuioRecorder.TuioRecorderService;
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
		
	}
}
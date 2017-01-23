package imagsyd.imagination.services.tuio;
import com.imagination.delay.Delay;
import flash.net.DatagramSocket;
import flash.net.ServerSocket;
import imagsyd.imagination.services.tuio.listeners.BasicListener;
import imagsyd.imagination.model.config.ConfigModel;
import imagsyd.imagination.services.tuio.listeners.MarkerInputListener;
import imagsyd.imagination.services.tuio.listeners.TouchInputListener;
import imagsyd.imagination.services.tuio.process.RoundCoordinatesMarkerProcess;
import imagsyd.imagination.services.tuio.process.SnapAngleMarkerProcess;
import imagsyd.imagination.services.tuioRecorder.TuioRecorderService;
import starling.core.Starling;
import org.tuio.connectors.UDPConnector;
import org.tuio.osc.IOSCConnector;
import org.tuio.TuioClient;
import org.tuio.debug.TuioDebug;

/**
 * @author Michal Moczynski
 */
@:rtti
@:keepSub
class TuioService extends DatagramSocket
{
	@inject public var configModel:ConfigModel;
	@inject public var touchInputListener:TouchInputListener;
	@inject public var tuioRecorderService:TuioRecorderService;
	@inject public var markerInputListener:MarkerInputListener;
	
	private var tc:TuioClient;
	var connector:IOSCConnector;

	
	public function new() 
	{
		super();
	}
	
		
	public function setup(starling:Starling):Void
	{
		var connector:IOSCConnector = new UDPConnector(configModel.tuioServer, configModel.tuioPort, true);
		
		markerInputListener.processStack.push( new RoundCoordinatesMarkerProcess() );
		markerInputListener.processStack.push( new SnapAngleMarkerProcess() );
		
		tc = new TuioClient(connector);
		tc.addListener(touchInputListener);
		tc.addListener(markerInputListener);

	}	

}
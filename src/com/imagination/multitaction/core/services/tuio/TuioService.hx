package com.imagination.multitaction.core.services.tuio;

import com.imagination.delay.Delay;
import com.imagination.multitaction.core.managers.TuioMarkerManager;
import com.imagination.multitaction.core.services.tuioPlayback.TuioPlaybackService;
import flash.net.DatagramSocket;
import flash.net.ServerSocket;
import com.imagination.multitaction.core.services.tuio.listeners.BasicListener;
import com.imagination.multitaction.core.services.tuio.listeners.MarkerInputListener;
import com.imagination.multitaction.core.services.tuio.listeners.MarkerInputListener;
import com.imagination.multitaction.core.services.tuio.listeners.TouchInputListener;
import com.imagination.multitaction.core.services.tuio.process.SnapAngleMarkerProcess;
import com.imagination.multitaction.core.services.tuioRecorder.TuioRecorderService;
import com.imagination.multitaction.core.services.tuio.process.RoundCoordinatesMarkerProcess;
import imagsyd.imagination.model.config.ConfigModel;
import imagsyd.imagination.services.content.ContentService;
import robotlegs.bender.framework.api.IInjector;
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
	
	@inject public var injector:IInjector;
	@inject public var tuioService:TuioService;
	
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

		injector.map(TuioService).asSingleton();
		injector.map(BasicListener).asSingleton();
		injector.map(TouchInputListener).asSingleton();
		injector.map(TuioRecorderService).asSingleton();
		injector.map(TuioPlaybackService).asSingleton();
		injector.map(ContentService).asSingleton();
		
		injector.map(MarkerInputListener).asSingleton();
		
		tuioService.setup(Starling.current);		
	}
}
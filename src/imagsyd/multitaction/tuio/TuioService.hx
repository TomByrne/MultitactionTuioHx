package imagsyd.multitaction.tuio;

import imagsyd.base.ISettings;
import imagsyd.debug.model.DebuggerModel;
import imagsyd.multitaction.logic.TuioDebugViewsLogic;
import imagsyd.multitaction.model.marker.TuioMarkersStackableProcessesModel;
import imagsyd.multitaction.model.touch.TuioTouchesStackableProcessesModel;
import imagsyd.multitaction.tuio.listener.MastercardCardListener;
import imagsyd.multitaction.tuio.processors.touch.base.StarlingTuioTouchProcessor;
import imagsyd.multitaction.tuio.view.openfl.debug.touchPanel.DebugTuioTouchPanelView;
import imagsyd.multitaction.tuio.view.openfl.debug.tuioMarkers.DebugTuioFiltersView;
import openfl.errors.Error;
import org.tuio.ITuioListener;
import org.tuio.connectors.UDPConnector;
import org.tuio.osc.IOSCConnector;
import org.tuio.TuioClient;
import starling.core.Starling;

/**
 * @author Michal Moczynski
 */
@:rtti
@:keepSub
class TuioService
{
	@inject public var settings:ISettings;	
	@inject public var starlingTuioTouchProcessor:StarlingTuioTouchProcessor;
	@inject public var mastercardCardListener:MastercardCardListener;
	@inject public var tuioDebugViewsLogic:TuioDebugViewsLogic;
	@inject public var tuioMarkersStackableProcessesModel:TuioMarkersStackableProcessesModel;
	@inject public var tuioTouchesStackableProcessesModel:TuioTouchesStackableProcessesModel;
	@inject public var debuggerModel:DebuggerModel;
	
	private var tc:TuioClient;
	//var connector:IOSCConnector;

	
	public function new() 
	{
	}
	
		
	public function setup():Void
	{
		settings.watch(['tuioServer', 'tuioPort'], onSettingsChanged);
		onSettingsChanged();
	}
	
	function onSettingsChanged() 
	{
		var tuioServer:String = settings.string('tuioServer', '127.0.0.1');
		var tuioPort:Null<Int> = settings.int('tuioPort', 3333);
		
		if (tuioServer == null || tuioPort == null) return;
		
		if (tc != null) return; // TODO: Make it able to reconnect when settings change
		
		this.log("tuio start at " + tuioServer + ":" + tuioPort);
		var connector:IOSCConnector;
		
		try 
		{
			#if air
			connector = new UDPConnector(tuioServer, tuioPort, true);
			#else
			connector = new UDPConnector("192.168.1.100", 3333, true);
			#end
			
			tc = new TuioClient(connector);
		}
		catch (err:Error)
		{
			this.error(err.message);
		}

		//set starling touch processor
		#if starling
		if(Starling.current != null)
			Starling.current.touchProcessor = starlingTuioTouchProcessor;
		else
		this.warn("Trying to set starling touch processor before Starling initialization. Tuio touches may not work properly.");
		#else
		this.warn("Tuio touch functionality currently implemented only for Starling.");
		#end
		
		//add tuio object listener
		addListener( mastercardCardListener );		
		mastercardCardListener.initialize();		
		
		//add openfl debug panels
		debuggerModel.addPanelType(DebugTuioFiltersView);
		debuggerModel.addPanelType(DebugTuioTouchPanelView);	
		
		tuioDebugViewsLogic.initialize();
		tuioMarkersStackableProcessesModel.start();
		tuioTouchesStackableProcessesModel.start();
	}
	
	public function addListener(  listener:ITuioListener ):Void
	{
		if (tc != null)
		{
			tc.addListener(listener);
		}
	}
	
	public function removeListener(  listener:ITuioListener ):Void
	{
		if (tc != null)
		{
			tc.removeListener(listener);
		}
	}
}
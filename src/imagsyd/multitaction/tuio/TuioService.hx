package imagsyd.multitaction.tuio;

import com.imagination.core.model.debug.DebuggerModel;
import imagsyd.multitaction.logic.TuioDebugViewsLogic;
import imagsyd.multitaction.model.TuioMarkersStackableProcessesModel;
import imagsyd.multitaction.tuio.listener.MastercardCardListener;
import imagsyd.multitaction.tuio.touch.processors.StarlingTuioTouchProcessor;
import imagsyd.multitaction.tuio.view.openfl.debug.touchPanel.DebugTuioTouchPanelView;
import imagsyd.multitaction.tuio.view.openfl.debug.tuioMarkers.DebugTuioFiltersView;
import robotlegs.bender.extensions.imag.api.model.config.IConfigModel;
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
	@inject public var configModel:IConfigModel;	
	@inject public var starlingTuioTouchProcessor:StarlingTuioTouchProcessor;
	@inject public var mastercardCardListener:MastercardCardListener;
	@inject public var tuioDebugViewsLogic:TuioDebugViewsLogic;
	@inject public var tuioMarkersStackableProcessesModel:TuioMarkersStackableProcessesModel;
	
	private var tc:TuioClient;
	var connector:IOSCConnector;

	
	public function new() 
	{
	}
	
		
	public function setup(debuggerModel:DebuggerModel):Void
	{
		Logger.log(this, "tuio start at " + configModel.get("tuioServer") + ":" + configModel.get("tuioPort"));
		var connector:IOSCConnector;
		
		try 
		{
			#if air
			connector = new UDPConnector(configModel.get("tuioServer"), configModel.get("tuioPort"), true);
			#else
			connector = new UDPConnector("192.168.1.100", 3333, true);
			#end
			
			tc = new TuioClient(connector);
		}
		catch (err:Error)
		{
			Logger.error(this, err.message);
		}

		//set starling touch processor
		#if starling
		if(Starling.current != null)
			Starling.current.touchProcessor = starlingTuioTouchProcessor;
		else
		Logger.warn(this, "Trying to set starling touch processor before Starling initialization. Tuio touches may not work properly.");
		#else
		Logger.warn(this, "Tuio touch functionality currently implemented only for Starling.");
		#end
		
		//add tuio object listener
		addListener( mastercardCardListener );		
		mastercardCardListener.initialize();		
		
		//add openfl debug panels
		debuggerModel.addPanelType(DebugTuioFiltersView);
		debuggerModel.addPanelType(DebugTuioTouchPanelView);	
		
		tuioDebugViewsLogic.initialize();
		tuioMarkersStackableProcessesModel.start();
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
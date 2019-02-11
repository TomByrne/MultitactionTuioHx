package imagsyd.multitaction.tuio;

import imagsyd.base.ISettings;
import imagsyd.debug.model.DebuggerModel;
import imagsyd.multitaction.logic.TuioDebugViewsLogic;
import imagsyd.multitaction.model.marker.TuioMarkersStackableProcessesModel;
import imagsyd.multitaction.model.touch.TouchObjectsModel;
import imagsyd.multitaction.model.touch.TuioTouchesSettingsModel;
import imagsyd.multitaction.model.touch.TuioTouchesStackableProcessesModel;
import imagsyd.multitaction.tuio.listener.MultitactionCardListener;
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
	@inject public var mastercardCardListener:MultitactionCardListener;
	@inject public var tuioDebugViewsLogic:TuioDebugViewsLogic;
	@inject public var tuioMarkersStackableProcessesModel:TuioMarkersStackableProcessesModel;
	@inject public var tuioTouchesStackableProcessesModel:TuioTouchesStackableProcessesModel;
	@inject public var debuggerModel:DebuggerModel;
	@inject public var tuioTouchesSettingsModel:TuioTouchesSettingsModel;
	@inject public var touchObjectsModel:TouchObjectsModel;
	
	private var tc:TuioClient;
	var _validCodes:Array<Int> = null;
	public var validCodes(null, set):Array<Int>;
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
		var tuioEnabled:Bool = settings.bool('tuioEnabled', true);
		var tuioServer:String = settings.string('tuioServer', '127.0.0.1');
		var tuioPort:Null<Int> = settings.int('tuioPort', 3333);
		var minTuioCardNumber:Int = settings.int('minTuioCardNumber', 1);
		var maxTuioCardNumber:Int = settings.int('maxTuioCardNumber', 32);
		
		if (!tuioEnabled || tuioServer == null || tuioPort == null) return;
		
		if (tc != null) return; // TODO: Make it able to reconnect when settings change
		
		//this.log("tuio start at " + tuioServer + ":" + tuioPort);
		var connector:IOSCConnector;
		
		try 
		{
			connector = new UDPConnector(tuioServer, tuioPort, true);			
			tc = new TuioClient(connector, minTuioCardNumber, maxTuioCardNumber);
			if(_validCodes != null)
				tc.setValidCodes(_validCodes);
		}
		catch (err:Error)
		{
			this.error(err.message);
		}

		//set starling touch processor
		#if starling
		if (Starling.all.length >  0 )
		{
			touchObjectsModel.starlingTuioTouchProcessors = [];
			
			for ( starling in Starling.all)
			{
				var tarlingTuioTouchProcessor:StarlingTuioTouchProcessor = new StarlingTuioTouchProcessor(starling.stage, tuioTouchesSettingsModel);
				starling.touchProcessor = tarlingTuioTouchProcessor;
				touchObjectsModel.starlingTuioTouchProcessors.push(tarlingTuioTouchProcessor);
			}
		}
		else
		this.error("Trying to set starling touch processor before Starling initialization. Tuio touches may not work properly.");
		#else
		this.error("Tuio touch functionality currently implemented only for Starling.");
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
	
	function set_validCodes(value:Array<Int>):Array<Int> 
	{
		if(tc!= null)
			tc.setValidCodes( value );
		
		_validCodes = value;
		return value;
	}
}
package multitaction.tuio;

import imagsyd.network.util.NetworkHardware;
import imagsyd.base.ISettings;
import imagsyd.debug.model.DebuggerModel;
import multitaction.logic.TuioDebugViewsLogic;
import multitaction.model.marker.TuioMarkersStackableProcessesModel;
import multitaction.model.touch.TuioTouchesSettingsModel;
import multitaction.model.touch.TuioTouchesStackableProcessesModel;
import multitaction.tuio.listener.MultitactionCardListener;
import multitaction.tuio.view.openfl.debug.touchPanel.DebugTuioTouchPanelView;
import multitaction.tuio.view.openfl.debug.tuioMarkers.DebugTuioFiltersView;
import openfl.errors.Error;
import org.tuio.ITuioListener;
import org.tuio.connectors.UDPConnector;
import org.tuio.TuioClient;

/**
 * @author Michal Moczynski
 */
@:rtti
@:keepSub
class TuioService
{
	@inject public var settings:ISettings;	
	@inject public var multitactionCardListener:MultitactionCardListener;
	@inject public var tuioDebugViewsLogic:TuioDebugViewsLogic;
	@inject public var tuioMarkersStackableProcessesModel:TuioMarkersStackableProcessesModel;
	@inject public var tuioTouchesStackableProcessesModel:TuioTouchesStackableProcessesModel;
	@inject public var debuggerModel:DebuggerModel;
	@inject public var tuioTouchesSettingsModel:TuioTouchesSettingsModel;
	
	var _validCodes:Array<Int> = null;
	public var validCodes(null, set):Array<Int>;
	
	var tuioClient:TuioClient;
	var connector:UDPConnector;
	var _listeners:Array<ITuioListener> = [];
	var flippedOrientation:Bool;
	
	public function new() 
	{
	}
	
		
	public function setup():Void
	{
		settings.watch(['tuioEnabled', 'tuioServer', 'tuioPort', 'minTuioCardNumber', 'maxTuioCardNumber', 'tuioFlippedOrientation'], onSettingsChanged);
		onSettingsChanged();

		NetworkHardware.onIpChange(onIpChange);
	}

	function onIpChange()
	{
		var tuioServer:String = settings.string('tuioServer', null);
		if (tuioServer == null) onSettingsChanged();
	}
	
	function onSettingsChanged() 
	{

		var tuioEnabled:Bool = settings.bool('tuioEnabled', true);
		var tuioServer:String = settings.string('tuioServer', null);
		var tuioPort:Null<Int> = settings.int('tuioPort', 3333);
		var minTuioCardNumber:Int = settings.int('minTuioCardNumber', 1);
		var maxTuioCardNumber:Int = settings.int('maxTuioCardNumber', 32);
		flippedOrientation = settings.bool('tuioFlippedOrientation', false);

		if(tuioServer == null) tuioServer = NetworkHardware.ipAddress;
		

		if (!tuioEnabled || tuioServer == null || tuioPort == null) return;
	
		if(multitactionCardListener != null)
			multitactionCardListener.flippedOrientation = flippedOrientation;


		if(tuioClient != null)
		{
			this.info('TUIO Reconnecting on port ${tuioServer}');
			for(listener in _listeners)
			{
				tuioClient.removeListener(listener);
			}

			connector.close();
			
			connector = new UDPConnector(tuioServer, tuioPort, true);			
			tuioClient = new TuioClient(connector, minTuioCardNumber, maxTuioCardNumber);
			
			if(_validCodes != null) tuioClient.setValidCodes( _validCodes );

			for(listener in _listeners)
			{
				tuioClient.addListener(listener);
			}

			return;
		}
		this.info('TUIO Connecting on port ${tuioServer}');
		
		try 
		{
			connector = new UDPConnector(tuioServer, tuioPort, true);			
			tuioClient = new TuioClient(connector, minTuioCardNumber, maxTuioCardNumber);
			if(_validCodes != null)
				tuioClient.setValidCodes(_validCodes);
		}
		catch (err:Error)
		{
			this.error(err.message);
		}
		
		//add tuio object listener
		addListener( multitactionCardListener );		
		multitactionCardListener.initialize(flippedOrientation);		
		
		//add openfl debug panels
		debuggerModel.addPanelType(DebugTuioFiltersView);
		debuggerModel.addPanelType(DebugTuioTouchPanelView);	
		
		tuioDebugViewsLogic.initialize();
		tuioMarkersStackableProcessesModel.start();
		tuioTouchesStackableProcessesModel.start();
	}
	
	public function addListener(  listener:ITuioListener ):Void
	{
		_listeners.push(listener);

		if (tuioClient != null)
		{
			tuioClient.addListener(listener);
		}
	}
	
	public function removeListener(  listener:ITuioListener ):Void
	{
		_listeners.remove(listener);
		
		if (tuioClient != null)
		{
			tuioClient.removeListener(listener);
		}
	}
	
	function set_validCodes(value:Array<Int>):Array<Int> 
	{
		if(tuioClient!= null)
			tuioClient.setValidCodes( value );
		
		_validCodes = value;
		return value;
	}
}
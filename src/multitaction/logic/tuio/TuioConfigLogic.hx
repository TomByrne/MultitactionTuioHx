package multitaction.logic.tuio;

import imagsyd.network.util.NetworkHardware;
import imagsyd.base.ISettings;
import org.swiftsuspenders.utils.DescribedType;
import org.tuio.ITuioListener;
import org.tuio.connectors.UDPConnector;
import org.tuio.TuioClient;
import notifier.Notifier;

/**
 * @author Michal Moczynski
 */
class TuioConfigLogic implements DescribedType
{
	@inject public var settings:ISettings;
	
	var _validCodes:Array<Int> = null;
	public var validCodes(null, set):Array<Int>;
	
	var tuioClient:TuioClient;
	var connector:UDPConnector;
	var _listeners:Array<ITuioListener> = [];
	var orientationFlipped:Notifier<Bool> = new Notifier<Bool>();
	
	public function new() 
	{
	}
	
		
	@:keep public function setup():Void
	{
		settings.watch(['tuioEnabled', 'tuioServer', 'tuioPort', 'minTuioCardNumber', 'maxTuioCardNumber'/*, 'tuioFlippedOrientation'*/], onSettingsChanged);
		orientationFlipped = settings.get('tuio_flipped_orientation');
		orientationFlipped.add( handleOrientationFlipped, false, true);
		onSettingsChanged();

		NetworkHardware.onIpChange(onIpChange);
	}

	function handleOrientationFlipped()
	{
		if(tuioClient != null)
			tuioClient.orientationFlipped = orientationFlipped.value;
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

		if(tuioServer == null) tuioServer = NetworkHardware.ipAddress;
		

		if (!tuioEnabled || tuioServer == null || tuioPort == null) return;


		if(tuioClient != null)
		{
			this.info('TUIO Reconnecting on port ${tuioServer}');
			for(listener in _listeners)
			{
				tuioClient.removeListener(listener);
			}

			connector.close();
			
			connector = new UDPConnector(tuioServer, tuioPort, true);			
			tuioClient = new TuioClient(connector, minTuioCardNumber, maxTuioCardNumber, orientationFlipped.value);
			
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
			tuioClient = new TuioClient(connector, minTuioCardNumber, maxTuioCardNumber, orientationFlipped.value);
			if(_validCodes != null)
				tuioClient.setValidCodes(_validCodes);
		}
		catch (err:Dynamic)
		{
			this.error(err);
		}
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
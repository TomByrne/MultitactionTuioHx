package imagsyd.imagination.managers;
import com.imagination.delay.DelayObject;
import com.imagination.util.signals.Signal.Signal0;
import com.imagination.util.signals.Signal.Signal1;

/**
 * ...
 * @author Michal Moczynski
 */
class Marker
{
	public var id:Int;
	public var x:Float = 0;
	public var y:Float = 0;
	public var rotation:Float = 0;
	public var classID:UInt;
	public var markerUpdated:Signal0 = new Signal0();
	public var markerAdded:Signal0 = new Signal0();
	public var markerRemoved:Signal0 = new Signal0();
	public var removeDelayObject:DelayObject;
	
	public function new() 
	{
		
	}
	
}
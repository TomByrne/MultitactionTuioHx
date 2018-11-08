package imagsyd.multitaction.tuio.processors;
import imagsyd.multitaction.model.TuioObjectsModel;
import com.imagination.core.type.Notifier;
import imagsyd.multitaction.model.TuioObjectsModel.TuioObjectElement;
import imagsyd.multitaction.tuio.listener.BasicProcessableTuioListener;
import imagsyd.multitaction.tuio.processors.base.ITuioStackableProcessor;
import openfl.geom.Point;
import org.tuio.TuioObject;

/**
 * ...
 * @author Michal Moczynski
 */
class SnapAnglesTuioProcessor implements ITuioStackableProcessor
{
	public var displayName:String = "Snap Angles";
	public var angleThreshold:Float = Math.PI/6;
	var PIhalf:Float = Math.PI/2;
	public var active:Notifier<Bool> = new Notifier<Bool>(true);

	public function new(active:Bool) 
	{
		this.active.value = active;
	}

	public function process(listener:BasicProcessableTuioListener, outputArray:Array<TuioObjectElement>, outputArrayMap:Map<UInt, UInt> ):Void
	{
		for ( to in listener.tuioObjects ) 
		{
			
			if (outputArrayMap.exists(to.sessionID))
			{
				var r:Float = to.a % PIhalf;
			
				if ( r < angleThreshold || r - PIhalf > -angleThreshold)
				{
					var snapped:Float = Math.round(to.a % PIhalf) * PIhalf;
//					Logger.log( this, "angle " + r + " " +angleThreshold + " " + (r < angleThreshold) + " " + (r - PIhalf > -angleThreshold));//to.a + " " + snapped);
					outputArray[outputArrayMap.get(to.sessionID)].r = snapped;
				}
			}
		}
	}
	
	
}
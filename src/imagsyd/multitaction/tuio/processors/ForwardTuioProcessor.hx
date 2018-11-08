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
class ForwardTuioProcessor implements ITuioStackableProcessor
{
	public var displayName:String = "Idle";
	public var angleThreshold:Float = 30;
	public var active:Notifier<Bool> = new Notifier<Bool>(true);

	public function new(active:Bool) 
	{
		this.active.value = active;
	}

	public function process(listener:BasicProcessableTuioListener, outputArray:Array<TuioObjectElement>, outputArrayMap:Map<UInt, UInt> ):Void
	{
		for (  to in listener.tuioObjects ) 
		{
			if (outputArrayMap.exists(to.sessionID))
			{
				update( outputArray[outputArrayMap.get(to.sessionID)], to );
			}
			else
			{
				var toe:TuioObjectElement = {pos:new Array<Point>(), r:to.r, sessionId:to.sessionID, classId:to.classID, frameId:to.frameID};
				toe.pos.unshift( new Point( to.x, to.y));
				outputArray.push(toe);
				outputArrayMap.set(to.sessionID, outputArray.length - 1);
			}
		}
	}
	
	function update(tuioObjectElement:TuioObjectElement, tuioObject:TuioObject) 
	{
		tuioObjectElement.pos.unshift(new Point(tuioObject.x, tuioObject.y));
		if ( tuioObjectElement.pos.length > 10)
		{
			tuioObjectElement.pos.pop();
		}
		tuioObjectElement.r = tuioObject.a;
		tuioObjectElement.classId = tuioObject.classID;
		tuioObjectElement.frameId = tuioObject.frameID;
	}	
	
}
package imagsyd.multitaction.tuio.processors;
import imagsyd.multitaction.model.TuioObjectsModel;
import com.imagination.core.type.Notifier;
import imagsyd.multitaction.model.TuioObjectsModel.TuioObjectElement;
import imagsyd.multitaction.tuio.listener.BasicProcessableTuioListener;
import imagsyd.multitaction.tuio.processors.base.ITuioStackableProcessor;
import org.tuio.TuioObject;

/**
 * @author Michal Moczynski
 */
class RemoveOldTuioProcessor implements ITuioStackableProcessor
{

	public var displayName:String = "Mastercard processor";
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
				var toe:TuioObjectElement = outputArray[outputArrayMap.get(to.sessionID)];
				//position didn't change - dummy
				if (toe.pos.length == 10 && toe.pos[0].x == toe.pos[9].x && toe.pos[0].y == toe.pos[9].y)
				{
					listener.removeTuioObject( to );
				}
			}
		}
		
	}

	
}
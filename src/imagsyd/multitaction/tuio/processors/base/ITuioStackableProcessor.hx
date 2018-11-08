package imagsyd.multitaction.tuio.processors.base;
import imagsyd.multitaction.model.TuioObjectsModel;
import com.imagination.core.type.Notifier;
import imagsyd.multitaction.model.TuioObjectsModel.TuioObjectElement;
import imagsyd.multitaction.tuio.listener.BasicProcessableTuioListener;

/**
 * @author Michal Moczynski
 */

interface ITuioStackableProcessor 
{
	public var displayName:String;
	public var active:Notifier<Bool>;
	
	function process(listener:BasicProcessableTuioListener, outputArray:Array<TuioObjectElement>, outputArrayMap:Map<UInt, UInt> ):Void;
}
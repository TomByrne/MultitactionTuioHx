package imagsyd.multitaction.tuio.processors.base;
import imagsyd.multitaction.model.MarkerObjectsModel;
import imagsyd.notifier.Notifier;
import imagsyd.multitaction.model.MarkerObjectsModel.MarkerObjectElement;
import imagsyd.multitaction.tuio.listener.BasicProcessableTuioListener;
import imagsyd.multitaction.model.IMarkerObjectsModel;

/**
 * @author Michal Moczynski
 */

interface ITuioStackableProcessor 
{
	public var displayName:String;
	public var active:Notifier<Bool>;
	
	function process(listener:BasicProcessableTuioListener):Void;
}
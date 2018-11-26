package imagsyd.multitaction.tuio.processors.maker.base;
import imagsyd.multitaction.model.marker.MarkerObjectsModel;
import imagsyd.notifier.Notifier;
import imagsyd.multitaction.model.marker.MarkerObjectsModel.MarkerObjectElement;
import imagsyd.multitaction.tuio.listener.BasicProcessableTuioListener;
import imagsyd.multitaction.model.marker.IMarkerObjectsModel;

/**
 * @author Michal Moczynski
 */

interface ITuioStackableProcessor 
{
	public var displayName:String;
	public var active:Notifier<Bool>;
	
	function process(listener:BasicProcessableTuioListener):Void;
}
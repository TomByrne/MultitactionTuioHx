package multitaction.tuio.processors.maker.base;
import multitaction.model.marker.MarkerObjectsModel;
import imagsyd.notifier.Notifier;
import multitaction.model.marker.MarkerObjectsModel.MarkerObjectElement;
import multitaction.tuio.listener.BasicProcessableTuioListener;
import multitaction.model.marker.IMarkerObjectsModel;

/**
 * @author Michal Moczynski
 */

interface ITuioStackableProcessor 
{
	public var displayName:String;
	public var active:Notifier<Bool>;
	
	function process(listener:BasicProcessableTuioListener):Void;
}
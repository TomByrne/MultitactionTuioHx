package imagsyd.multitaction.tuio.processors;
import imagsyd.multitaction.model.MarkerObjectsModel;
import imagsyd.notifier.Notifier;
import imagsyd.multitaction.model.MarkerObjectsModel.MarkerObjectElement;
import imagsyd.multitaction.tuio.listener.BasicProcessableTuioListener;
import imagsyd.multitaction.tuio.processors.base.ITuioStackableProcessor;
import org.tuio.TuioObject;
import imagsyd.multitaction.model.IMarkerObjectsModel;

/**
 * @author Michal Moczynski
 */
class RemoveOldTuioProcessor implements ITuioStackableProcessor
{
	var markerObjectsModel:IMarkerObjectsModel;

	public var displayName:String = "Mastercard processor";
	public var active:Notifier<Bool> = new Notifier<Bool>(true);
	
	public function new(active:Bool, markerObjectsModel:IMarkerObjectsModel) 
	{
		this.active.value = active;
		this.markerObjectsModel = markerObjectsModel;
	}
	
	public function process(listener:BasicProcessableTuioListener):Void
	{
		
	}	
}
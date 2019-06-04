package multitaction.logic.processors.marker;

import multitaction.model.marker.MarkerObjectsModel;
import imagsyd.notifier.Notifier;
import multitaction.model.marker.IMarkerObjectsModel.MarkerObjectElement;
import multitaction.logic.listener.BasicProcessableTuioListener;
import multitaction.logic.processors.marker.base.ITuioStackableProcessor;
import multitaction.model.marker.IMarkerObjectsModel;
import multitaction.utils.MarkerPoint;


class FlipOrientationMarkerProcessor implements ITuioStackableProcessor
{
	var markerObjectsModel:IMarkerObjectsModel;

	public var displayName:String = "Flip Orientation";
	public var active:Notifier<Bool> = new Notifier<Bool>(true);
	
	public function new(active:Bool, markerObjectsModel:IMarkerObjectsModel) 
	{
		this.active.value = active;
		this.markerObjectsModel = markerObjectsModel;
	}
	
	public function process(listener:BasicProcessableTuioListener):Void
	{
        for(to in listener.tuioObjects)
        {
			this.log("to " + to.x + " " + to.y);
            to.flip();
        }
	}
	
}
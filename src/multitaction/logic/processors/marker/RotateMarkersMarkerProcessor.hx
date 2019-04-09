package multitaction.logic.processors.marker;

import imagsyd.notifier.Notifier;
import multitaction.logic.listener.BasicProcessableTuioListener;
import multitaction.logic.processors.marker.base.ITuioStackableProcessor;
import multitaction.model.marker.IMarkerObjectsModel;


class RotateMarkersMarkerProcessor implements ITuioStackableProcessor
{
	var markerObjectsModel:IMarkerObjectsModel;
	var rotation:Notifier<Float>;

	public var displayName:String = "Rotate Markers";
	public var active:Notifier<Bool> = new Notifier<Bool>(true);

    var lastFrameIds:Map<String, UInt> = new Map();
	
	public function new(active:Bool, markerObjectsModel:IMarkerObjectsModel, rotation:Notifier<Float>) 
	{
		this.active.value = active;
		this.markerObjectsModel = markerObjectsModel;
        this.rotation = rotation;
	}
	
	public function process(listener:BasicProcessableTuioListener):Void
	{
        var rotation:Null<Float> = rotation.value;
        if(rotation == null || rotation == 0) return;

        for(moe in markerObjectsModel.markerObjectsMap)
        {
            if(lastFrameIds.get(moe.uid) == moe.frameId) continue;

            lastFrameIds.set(moe.uid, moe.frameId);
            moe.rotation += rotation;
        }
	}
	
}
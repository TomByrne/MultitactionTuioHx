package multitaction.logic.processors.marker;

import org.swiftsuspenders.utils.DescribedType;
import multitaction.logic.processors.marker.base.ITuioStackableProcessor;
import multitaction.model.marker.IMarkerObjectsModel;
import multitaction.logic.listener.BasicProcessableTuioListener;
import imagsyd.notifier.Notifier;

class AppSpaceConversionMarkerProcessor implements ITuioStackableProcessor implements DescribedType
{

    @inject public var markerObjectsModel:IMarkerObjectsModel;
    
    public var displayName:String = "App Space Conversion";
	public var active:Notifier<Bool> = new Notifier<Bool>(true);

    public var scale:Float = 1;
    public var offsetX:Float = 0;
    public var offsetY:Float = 0;

	public function new(active:Bool=true, ?markerObjectsModel:IMarkerObjectsModel) 
	{
		this.active.value = active;
		this.markerObjectsModel = markerObjectsModel;
	}
	
	public function process(listener:BasicProcessableTuioListener):Void
	{
		for ( moe in markerObjectsModel.markerObjectsMap)
		{
			moe.posScreen.x = moe.posApp.x * scale + offsetX;
			moe.posScreen.y = moe.posApp.y * scale + offsetY;
		}
    }
}
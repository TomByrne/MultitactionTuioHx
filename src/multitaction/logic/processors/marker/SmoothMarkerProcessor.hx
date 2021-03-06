package multitaction.logic.processors.marker;

import imagsyd.notifier.Notifier;
import multitaction.logic.listener.BasicProcessableTuioListener;
import multitaction.logic.processors.marker.base.ITuioStackableProcessor;
import multitaction.utils.MarkerPoint;
import multitaction.model.marker.IMarkerObjectsModel;

/**
 * ...
 * @author Michal Moczynski
 */
class SmoothMarkerProcessor implements ITuioStackableProcessor
{
	public var displayName:String = "Smooth movement";
	public var active:Notifier<Bool> = new Notifier<Bool>(true);
    
	var markerObjectsModel:IMarkerObjectsModel;
	var nativeScreenSize:Notifier<MarkerPoint>;

	public function new(active:Bool, markerObjectsModel:IMarkerObjectsModel, nativeScreenSize:Notifier<MarkerPoint>) 
	{
		this.active.value = active;
		this.markerObjectsModel = markerObjectsModel;
        this.nativeScreenSize = nativeScreenSize;
	}

	public function process(listener:BasicProcessableTuioListener):Void
	{
        var screenW:Float = nativeScreenSize.value.x;
        var screenH:Float = nativeScreenSize.value.y;
		for ( moe in markerObjectsModel.markerObjectsMap ) 
		{
			if (moe.fractPos.length > 3 && moe.fromTuio == true)
			{
				moe.posScreen.x = Math.round( screenW * (moe.fractPos[0].x + moe.fractPos[1].x + moe.fractPos[2].x + moe.fractPos[3].x) / 4 );
				moe.posScreen.y = Math.round( screenH * (moe.fractPos[0].y + moe.fractPos[1].y + moe.fractPos[2].y + moe.fractPos[3].y) / 4 );
			}
		}
	}
	
	
}
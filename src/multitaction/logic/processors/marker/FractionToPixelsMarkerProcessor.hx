package multitaction.logic.processors.marker;
import multitaction.model.marker.MarkerObjectsModel;
import imagsyd.notifier.Notifier;
import multitaction.model.marker.IMarkerObjectsModel.MarkerObjectElement;
import multitaction.logic.listener.BasicProcessableTuioListener;
import multitaction.logic.processors.marker.base.ITuioStackableProcessor;
import multitaction.model.marker.IMarkerObjectsModel;
import multitaction.utils.MarkerPoint;

/**
 * ...
 * @author Michal Moczynski
 */
class FractionToPixelsMarkerProcessor implements ITuioStackableProcessor
{
	var markerObjectsModel:IMarkerObjectsModel;
	var nativeScreenSize:Notifier<MarkerPoint>;

	public var displayName:String = "Fraction to pixels";
	public var active:Notifier<Bool> = new Notifier<Bool>(true);
	
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
		for (  to in listener.tuioObjects ) 
		{
			if (markerObjectsModel.markerObjectsMap.exists( markerObjectsModel.tuioToMarkerMap.get("t" + to.sessionID ) ))
			{
				var moe:MarkerObjectElement = markerObjectsModel.markerObjectsMap.get( markerObjectsModel.tuioToMarkerMap.get("t" + to.sessionID) );
				if (moe != null && moe.fromTuio == true)
				{
					moe.posScreen.x = Math.round( moe.fractPos[0].x * screenW );
					moe.posScreen.y = Math.round( moe.fractPos[0].y * screenH );
				}
			}
		}
		
	}
	
}
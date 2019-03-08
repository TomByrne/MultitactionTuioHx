package multitaction.tuio.processors.maker;
import multitaction.model.marker.MarkerObjectsModel;
import imagsyd.notifier.Notifier;
import multitaction.model.marker.MarkerObjectsModel.MarkerObjectElement;
import multitaction.tuio.listener.BasicProcessableTuioListener;
import multitaction.tuio.processors.maker.base.ITuioStackableProcessor;
import starling.core.Starling;
import multitaction.model.marker.IMarkerObjectsModel;
import openfl.geom.Point;

/**
 * ...
 * @author Michal Moczynski
 */
class FractionToPixelsTuioProcessor implements ITuioStackableProcessor
{
	var markerObjectsModel:IMarkerObjectsModel;
	var nativeScreenSize:Point;

	public var displayName:String = "Fraction to pixels";
	public var active:Notifier<Bool> = new Notifier<Bool>(true);
	
	public function new(active:Bool, markerObjectsModel:IMarkerObjectsModel, nativeScreenSize:Point) 
	{
		this.active.value = active;
		this.markerObjectsModel = markerObjectsModel;
		this.nativeScreenSize = nativeScreenSize;
	}
	
	public function process(listener:BasicProcessableTuioListener):Void
	{
		for (  to in listener.tuioObjects ) 
		{
			if (markerObjectsModel.markerObjectsMap.exists( markerObjectsModel.tuioToMarkerMap.get("t" + to.sessionID ) ) && Starling.current != null)
			{
				var moe:MarkerObjectElement = markerObjectsModel.markerObjectsMap.get( markerObjectsModel.tuioToMarkerMap.get("t" + to.sessionID) );
				if (moe != null && moe.fromTuio == true)
				{
					moe.pos.x = Math.round( moe.fractPos[0].x * nativeScreenSize.x );
					moe.pos.y = Math.round( moe.fractPos[0].y * nativeScreenSize.y );
				}
			}
		}
		
	}
	
}
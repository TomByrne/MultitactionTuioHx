package multitaction.tuio.processors.maker;
import multitaction.model.marker.MarkerObjectsModel;
import imagsyd.notifier.Notifier;
import multitaction.model.marker.MarkerObjectsModel.MarkerObjectElement;
import multitaction.tuio.listener.BasicProcessableTuioListener;
import multitaction.tuio.processors.maker.base.ITuioStackableProcessor;
import openfl.geom.Point;
import org.tuio.TuioObject;
import multitaction.model.marker.IMarkerObjectsModel;
import starling.core.Starling;

/**
 * ...
 * @author Michal Moczynski
 */
class SmoothProcessor implements ITuioStackableProcessor
{
	public var displayName:String = "SmoothProcessor";
	var markerObjectsModel:IMarkerObjectsModel;
	public var active:Notifier<Bool> = new Notifier<Bool>(true);

	public function new(active:Bool, markerObjectsModel:IMarkerObjectsModel) 
	{
		this.active.value = active;
		this.markerObjectsModel = markerObjectsModel;
	}

	public function process(listener:BasicProcessableTuioListener):Void
	{
		for ( moe in markerObjectsModel.markerObjectsMap ) 
		{
			if (moe.fractPos.length > 3)
			{
				moe.pos.x = Math.round( Starling.current.stage.stageWidth * (moe.fractPos[0].x + moe.fractPos[1].x + moe.fractPos[2].x + moe.fractPos[3].x) / 4 );
				moe.pos.y = Math.round( Starling.current.stage.stageHeight * (moe.fractPos[0].y + moe.fractPos[1].y + moe.fractPos[2].y + moe.fractPos[3].y) / 4 );
			}
		}
	}
	
	
}
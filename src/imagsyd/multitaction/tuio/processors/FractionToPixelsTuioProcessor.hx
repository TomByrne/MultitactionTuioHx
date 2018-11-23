package imagsyd.multitaction.tuio.processors;
import imagsyd.notifier.Notifier;
import imagsyd.multitaction.model.MarkerObjectsModel.MarkerObjectElement;
import imagsyd.multitaction.tuio.listener.BasicProcessableTuioListener;
import imagsyd.multitaction.tuio.processors.base.ITuioStackableProcessor;
import starling.core.Starling;
import imagsyd.multitaction.model.IMarkerObjectsModel;

/**
 * ...
 * @author Michal Moczynski
 */
class FractionToPixelsTuioProcessor implements ITuioStackableProcessor
{
	var markerObjectsModel:IMarkerObjectsModel;

	public var displayName:String = "Fraction to pixels";
	public var active:Notifier<Bool> = new Notifier<Bool>(true);
	
	public function new(active:Bool, markerObjectsModel:IMarkerObjectsModel) 
	{
		this.active.value = active;
		this.markerObjectsModel = markerObjectsModel;
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
					moe.pos.x = Math.round( moe.fractPos[0].x * Starling.current.stage.stageWidth );
					moe.pos.y = Math.round( moe.fractPos[0].y * Starling.current.stage.stageHeight );
				}
			}
		}
		
	}
	
}
package multitaction.logic.processors.marker;

import imagsyd.notifier.Notifier;
import multitaction.model.marker.MarkerObjectsModel.MarkerObjectElement;
import multitaction.logic.listener.BasicProcessableTuioListener;
import multitaction.logic.processors.marker.base.ITuioStackableProcessor;
import multitaction.model.marker.IMarkerObjectsModel;

/**
 * ...
 * @author Michal Moczynski
 */
class SnapAnglesMarkerProcessor implements ITuioStackableProcessor
{
	public var displayName:String = "Snap Angles";
	public var angleThreshold:Float = Math.PI/6;
	var PIhalf:Float = Math.PI/2;
	var markerObjectsModel:IMarkerObjectsModel;
	public var active:Notifier<Bool> = new Notifier<Bool>(true);

	public function new(active:Bool, markerObjectsModel:IMarkerObjectsModel) 
	{
		this.active.value = active;
		this.markerObjectsModel = markerObjectsModel;
	}

	public function process(listener:BasicProcessableTuioListener):Void
	{
		for ( to in listener.tuioObjects ) 
		{
			
			if (markerObjectsModel.markerObjectsMap.exists( markerObjectsModel.tuioToMarkerMap.get( "t" + to.sessionID) ))
			{
				var r:Float = to.a % PIhalf;
			
				if ( r < angleThreshold || r - PIhalf > -angleThreshold)
				{
					var snapped:Float = Math.round(to.a % PIhalf) * PIhalf;
					var moe:MarkerObjectElement = markerObjectsModel.markerObjectsMap.get( markerObjectsModel.tuioToMarkerMap.get("t" + to.sessionID) );
					moe.rotation = snapped;
				}
			}
		}
	}
	
	
}
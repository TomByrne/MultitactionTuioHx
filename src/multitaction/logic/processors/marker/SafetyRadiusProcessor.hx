package multitaction.logic.processors.marker;

import imagsyd.signals.Signal.Signal1;
import imagsyd.notifier.Notifier;
import multitaction.logic.listener.BasicProcessableTuioListener;
import multitaction.logic.processors.marker.base.ITuioStackableProcessor;
import org.tuio.TuioObject;
import multitaction.model.marker.IMarkerObjectsModel;
import multitaction.utils.MarkerUID;
import multitaction.utils.GeomTools;
import multitaction.utils.MarkerPoint;

/**
 * ...
 * @author Michal Moczynski
 */
class SafetyRadiusProcessor implements ITuioStackableProcessor
{
	var markerObjectsModel:IMarkerObjectsModel;
	var frameId:Int;
	
	public var velocityThreshold:Float = 0.08;
	public var movementThreshold:Float = 0.0008;//0.0008;
	public var rotationThreshold:Float = 0.017;
	public var nominalSpeed:Float = 0.02;
	public var distanceThresholdX:Float = 300 / 3840;
	public var distanceThresholdY:Float = 300 / 2160;
	public var maxSpeedMiutiplier:Float = 1;	
	public var displayName:String = "Safety Radius";
	public var active:Notifier<Bool> = new Notifier<Bool>(true);
	
	public var toAge:Map<String, Int> = new Map<String, Int>();
	public var moeUpdatedByAge:Map<String, Int> = new Map<String, Int>();

	var retreiveOnlyTheSameCardId:Bool = false;

	var safeZoneSizeNotifier:Notifier<Float>;
	var safeZoneMaxMultiNotifier:Notifier<Float>;
	var keepAliveNotifier:Notifier<Float>;
	
	public function new(active:Bool, markerObjectsModel:IMarkerObjectsModel, safeZoneSizeNotifier:Notifier<Float>, safeZoneMaxMultiNotifier:Notifier<Float>) 
	{
		this.active.value = active;
		this.markerObjectsModel = markerObjectsModel;
		this.safeZoneSizeNotifier = safeZoneSizeNotifier;
		this.safeZoneMaxMultiNotifier = safeZoneMaxMultiNotifier;
		this.safeZoneSizeNotifier.add( handleSafeZoneSizeChanged, false, true );
		this.safeZoneMaxMultiNotifier.add( handleSafeZoneMaxMultiChanged, false, true );
	}

	function handleSafeZoneMaxMultiChanged(val:Float)
	{
		maxSpeedMiutiplier = val;
	}

	function handleSafeZoneSizeChanged(val:Float)
	{
		distanceThresholdX = val/3840;
		distanceThresholdY = val/2160;
	}
	
	public function process(listener:BasicProcessableTuioListener):Void
	{
        for(moe in markerObjectsModel.markerObjectsMap)
        {
            calculateSafeRadius(moe);
        }
	}
	
	function calculateSafeRadius(moe:MarkerObjectElement)
	{
		var speedMult:Float = 1;
		if(moe.fractPos.length > 3)
		{
			var pos = moe.fractPos[0];
			var pos1 = moe.fractPos[3];
			speedMult = 1 + GeomTools.dist( pos.x, pos.y, pos1.x, pos1.y ) / 0.025;
			if(speedMult > maxSpeedMiutiplier)
				speedMult = maxSpeedMiutiplier;
		}
		moe.safetyRadiusX = distanceThresholdX * speedMult;
		moe.safetyRadiusY = distanceThresholdY * speedMult;
	}

}
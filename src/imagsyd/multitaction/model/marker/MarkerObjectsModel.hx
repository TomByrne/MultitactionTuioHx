package imagsyd.multitaction.model.marker;

import imagsyd.multitaction.model.marker.IMarkerObjectsModel;
import imagsyd.signals.Signal.Signal1;
import openfl.geom.Point;
import org.tuio.TuioObject;

/**
 * ...
 * @author Michal Moczynski
 */
@:rtti
class MarkerObjectsModel implements IMarkerObjectsModel
{
	static private var lastUID:UInt = 0;
//	public var tuioObjects:Array<MarkerObjectElement> = [];
	public var tuioToMarkerMap:Map<String, String> = new Map<String, String>();
	public var markerObjectsMap:Map<String, MarkerObjectElement> = new Map<String, MarkerObjectElement>();//tuioObjects array id by tuio objectelement id
	
	public var removeMarkersSignal :Signal1<Array<String>> = new Signal1<Array<String>>();
	public var addMarkerSignal :Signal1<Array<String>> = new Signal1<Array<String>>();
	
	public var frameAddedMarkers:Array<String> = new Array<String>();
	public var frameRemovedMarkers:Array<String> = new Array<String>();
	public var frameUpdatedMarkers:Array<String> = new Array<String>();
	
	public var angleOffset:Float = -Math.PI / 2;
	
	public function new() 
	{
		
	}
	
	public function tick()
	{
		frameAddedMarkers = [];
		frameRemovedMarkers = [];
	}
	
	public function processed()
	{
		if(frameAddedMarkers.length > 0)
			addMarkerSignal.dispatch( frameAddedMarkers );
			
		if(frameRemovedMarkers.length > 0)
			removeMarkersSignal.dispatch( frameRemovedMarkers );
	}
	
	static public function getNextUID():String
	{
		return "t" + lastUID++;
	}
	
}

typedef MarkerObjectElement =
{
	pos:Point,//in pixels
	fractPos:Array<Point>,
	rotation:Float,
	uid:String,//sessionId
	cardId:UInt,//classId
	frameId:UInt,
	fromTuio:Bool,
	alive:Bool,
	safetyRadius:Float
}
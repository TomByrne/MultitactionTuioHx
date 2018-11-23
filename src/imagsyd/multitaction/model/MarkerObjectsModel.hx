package imagsyd.multitaction.model;
import com.imagination.util.signals.Signal.Signal1;
import haxe.ds.Map;
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
	public var removeTuioSignal :Signal1<String> = new Signal1<String>();
	public var addMarkerSignal :Signal1<String> = new Signal1<String>();
	
	public var frameAddedMarkers:Array<String> = new Array<String>();
	public var frameRemovedMarkers:Array<String> = new Array<String>();
	
	
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
	alive:Bool
}
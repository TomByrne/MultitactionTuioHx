package multitaction.model.marker;

import imagsyd.signals.Signal.Signal1;
import multitaction.utils.MarkerPoint;

/**
 * ...
 * @author Michal Moczynski
 */
interface IMarkerObjectsModel 
{
//	public var tuioObjects:Array<MarkerObjectElement>;
	public var tuioToMarkerMap:Map<String, String>;
	public var markerObjectsMap:Map<String, MarkerObjectElement>;
	
	public var removeMarkersSignal:Signal1<Array<String>>;
	public var addMarkerSignal:Signal1<Array<String>>;
	
	public var frameAddedMarkers:Array<String>;
	public var frameRemovedMarkers:Array<String>;
	public var frameUpdatedMarkers:Array<String>;
	
	function tick():Void;
	function processed():Void;	
}

typedef MarkerObjectElement =
{
	posApp:MarkerPoint,//in pixels (app space)
	posScreen:MarkerPoint,//in pixels (screen space)

	fractPos:Array<MarkerPoint>,
	rotation:Float,
	uid:String,//sessionId
	cardId:UInt,//the card id that our logic decided it is - it may be different from current tuio card id
	previousCardId:UInt,//previously recognised card id (before it changed)
	tuioCardId:UInt,//card id coming from tuio (no filtering on this one)
	cardIdChanged:Signal1<String>,//signal with this moe's uid dispatches when the card id changes
	readCardIds:Map<UInt,UInt>,//store the number of all card ids that were recognised for this marker and the number of those recognitions (key - cardId, value - number of recognitions)
	lastCardChangeFrame:UInt,//needed to calculate strenghts of different card ids if it changes over time (or flickers)
	frameId:UInt,
	fromTuio:Bool,
	alive:Bool,
	safetyRadius:Float
}
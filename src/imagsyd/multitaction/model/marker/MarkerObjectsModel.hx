package imagsyd.multitaction.model.marker;

import imagsyd.multitaction.model.marker.IMarkerObjectsModel;
import imagsyd.signals.Signal.Signal1;
import openfl.geom.Point;
import imagsyd.notifier.Notifier;

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
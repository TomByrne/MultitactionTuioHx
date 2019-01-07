package imagsyd.multitaction.model.marker;
import imagsyd.multitaction.model.marker.MarkerObjectsModel.MarkerObjectElement;
import imagsyd.signals.Signal.Signal1;

/**
 * ...
 * @author Michal Moczynski
 */
interface IMarkerObjectsModel 
{
//	public var tuioObjects:Array<MarkerObjectElement>;
	public var tuioToMarkerMap:Map<String, String> = new Map<String, String>();
	public var markerObjectsMap:Map<String, MarkerObjectElement>;
	
	public var removeMarkersSignal:Signal1<Array<String>> = new Signal1<Array<String>>();
	public var addMarkerSignal:Signal1<Array<String>> = new Signal1<Array<String>>();
	
	public var frameAddedMarkers:Array<String> = new Array<String>();
	public var frameRemovedMarkers:Array<String> = new Array<String>();
	public var frameUpdatedMarkers:Array<String> = new Array<String>();
	
	public var angleOffset:Float;
	
	function tick():Void;
	function processed():Void;	
}
package multitaction.model.marker;
import multitaction.model.marker.MarkerObjectsModel.MarkerObjectElement;
import imagsyd.signals.Signal.Signal1;

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
	
	public var angleOffset:Float;
	
	function tick():Void;
	function processed():Void;	
}
package imagsyd.multitaction.model;
import com.imagination.util.signals.Signal.Signal1;
import imagsyd.multitaction.model.MarkerObjectsModel;
import imagsyd.multitaction.model.MarkerObjectsModel.MarkerObjectElement;

/**
 * ...
 * @author Michal Moczynski
 */
interface IMarkerObjectsModel 
{
//	public var tuioObjects:Array<MarkerObjectElement>;
	public var tuioToMarkerMap:Map<String, String> = new Map<String, String>();
	public var markerObjectsMap:Map<String, MarkerObjectElement>;
	
	public var removeTuioSignal:Signal1<String> = new Signal1<String>();
	public var addMarkerSignal:Signal1<String> = new Signal1<String>();
	
	public var frameAddedMarkers:Array<String> = new Array<String>();
	public var frameRemovedMarkers:Array<String> = new Array<String>();
	
	function tick():Void;
	function processed():Void;
}
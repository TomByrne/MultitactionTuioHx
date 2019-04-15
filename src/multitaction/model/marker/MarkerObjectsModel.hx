package multitaction.model.marker;

import multitaction.model.marker.IMarkerObjectsModel;
import multitaction.utils.MarkerPoint;
import imagsyd.signals.Signal.Signal1;
import imagsyd.notifier.Notifier;

/**
 * ...
 * @author Michal Moczynski
 */
class MarkerObjectsModel implements IMarkerObjectsModel
{
//	public var tuioObjects:Array<MarkerObjectElement> = [];
	public var tuioToMarkerMap:Map<String, String> = new Map<String, String>();
	public var markerObjectsMap:Map<String, MarkerObjectElement> = new Map<String, MarkerObjectElement>();//tuioObjects array id by tuio objectelement id
	
	public var removeMarkersSignal :Signal1<Array<String>> = new Signal1<Array<String>>();
	public var addMarkerSignal :Signal1<Array<String>> = new Signal1<Array<String>>();
	
	public var frameAddedMarkers:Array<String> = new Array<String>();
	public var frameRemovedMarkers:Array<String> = new Array<String>();
	public var frameUpdatedMarkers:Array<String> = new Array<String>();
	
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
	
}
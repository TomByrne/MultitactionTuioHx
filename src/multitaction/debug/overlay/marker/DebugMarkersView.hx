package multitaction.debug.overlay.marker;

import multitaction.debug.overlay.marker.DebugMarkerView;
import imagsyd.time.EnterFrame;
import multitaction.model.marker.IMarkerObjectsModel;
import openfl.display.Sprite;

/**
 * ...
 * @author Michal Moczynski
 */
class DebugMarkersView extends Sprite 
{
	var markerById:Map<String, DebugMarkerView>;
	var markerObjectsModel:IMarkerObjectsModel;

	public function new() 
	{
		super();
		
	}
	
	public function initialize(markerObjectsModel:IMarkerObjectsModel) 
	{
		this.markerObjectsModel = markerObjectsModel;
		
		markerById = new Map<String, DebugMarkerView>();
		
		EnterFrame.add( handleFrame );
	}
	
	function handleFrame():Void 
	{
		
		for ( markerObjectsElement in markerObjectsModel.markerObjectsMap) 
		{
			if (markerById.exists(markerObjectsElement.uid))
			{
				moveMarker( markerObjectsElement.uid, markerObjectsElement );
			}
			else
			{
				addMarker( markerObjectsElement.cardId, markerObjectsElement.uid );
				moveMarker( markerObjectsElement.uid, markerObjectsElement);
			}
		}
		
		for ( key in markerById.keys())
		{
			if (markerObjectsModel.markerObjectsMap.exists( key ) == false)
			{
				removeMarker(key);
			}
		}
    }
	
	public function removeMarker(uid:String) 
	{
		if (!markerById.exists(uid))
			return;
			
		var markerView:DebugMarkerView = markerById.get(uid);
		markerById.remove(uid);
        markerView.parent.removeChild(markerView);
	}
	
	public function addMarker(cardId:UInt, uid:String) 
	{
		if (markerById.exists(uid))
			return;			
		
		var markerView:DebugMarkerView = new DebugMarkerView();
		addChild(markerView);
		markerView.setID( cardId, uid );
		markerById.set(uid, markerView);		
	}
	
	public function moveMarker(sessionID:String, markerObjectsElement:MarkerObjectElement) 
	{
		if (!markerById.exists(sessionID))
			return;
			
		var markerView:DebugMarkerView = markerById.get(sessionID);
        markerView.update(markerObjectsElement);		
	}
	
}
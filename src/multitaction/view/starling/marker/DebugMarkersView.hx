package multitaction.view.starling.marker;
import multitaction.model.marker.MarkerObjectsModel;
import multitaction.view.starling.marker.DebugMarkerView;

import imagsyd.time.EnterFrame;
import multitaction.model.marker.IMarkerObjectsModel;
import multitaction.model.marker.MarkerObjectsModel.MarkerObjectElement;
import starling.display.Quad;
import starling.display.Sprite;

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
		markerView.removeFromParent(true);
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
		markerView.x = markerObjectsElement.posScreen.x;
		markerView.y = markerObjectsElement.posScreen.y;
		markerView.scale =  markerObjectsElement.safetyRadius / 0.1;
		markerView.rotation = markerObjectsElement.rotation;		
	}
	
}
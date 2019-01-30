package imagsyd.multitaction.tuio.view.starling.display.debugMarkers;
import imagsyd.multitaction.model.marker.MarkerObjectsModel;
import imagsyd.multitaction.tuio.view.starling.display.debugMarkers.marker.TuioDebugMarkerView;

import imagsyd.time.EnterFrame;
import imagsyd.multitaction.model.marker.IMarkerObjectsModel;
import imagsyd.multitaction.model.marker.MarkerObjectsModel.MarkerObjectElement;
import imagsyd.multitaction.tuio.listener.MultitactionCardListener;
import starling.display.Quad;
import starling.display.Sprite;

/**
 * ...
 * @author Michal Moczynski
 */
class DebugMarkersView extends Sprite 
{
	var markerById:Map<String, TuioDebugMarkerView>;
	var markerObjectsModel:IMarkerObjectsModel;

	public function new() 
	{
		super();
		
	}
	
	public function initialize(markerObjectsModel:IMarkerObjectsModel) 
	{
		this.markerObjectsModel = markerObjectsModel;
		
		markerById = new Map<String, TuioDebugMarkerView>();
		
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
			
		var markerView:TuioDebugMarkerView = markerById.get(uid);
		markerById.remove(uid);
		markerView.removeFromParent(true);
	}
	
	public function addMarker(cardId:UInt, uid:String) 
	{
		if (markerById.exists(uid))
			return;			
		
		var markerView:TuioDebugMarkerView = new TuioDebugMarkerView();
		addChild(markerView);
		markerView.setID( cardId, uid );
		markerById.set(uid, markerView);		
	}
	
	public function moveMarker(sessionID:String, markerObjectsElement:MarkerObjectElement) 
	{
		if (!markerById.exists(sessionID))
			return;
			
		var markerView:TuioDebugMarkerView = markerById.get(sessionID);
		markerView.x = markerObjectsElement.pos.x;
		markerView.y = markerObjectsElement.pos.y;
		markerView.scale =  markerObjectsElement.safetyRadius / 0.1;
//		markerView.rotation = markerObjectsElement.rotation;		
	}
	
}
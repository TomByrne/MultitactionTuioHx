package imagsyd.multitaction.tuio.view.starling.display.debugMarkers;
import imagsyd.multitaction.model.MarkerObjectsModel;
import imagsyd.multitaction.tuio.view.starling.display.debugMarkers.marker.TuioDebugMarkerView;

import imagsyd.time.EnterFrame;
import imagsyd.multitaction.model.IMarkerObjectsModel;
import imagsyd.multitaction.model.MarkerObjectsModel.MarkerObjectElement;
import imagsyd.multitaction.tuio.listener.MastercardCardListener;
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
		
		for ( tuioObjectsElement in markerObjectsModel.markerObjectsMap) 
		{
			if (markerById.exists(tuioObjectsElement.uid))
			{
				moveMarker( tuioObjectsElement.uid, tuioObjectsElement );
			}
			else
			{
				addMarker( tuioObjectsElement.cardId, tuioObjectsElement.uid );
				moveMarker( tuioObjectsElement.uid, tuioObjectsElement);
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
	
	public function moveMarker(sessionID:String, tuioObjectsElement:MarkerObjectElement) 
	{
		if (!markerById.exists(sessionID))
			return;
			
		var markerView:TuioDebugMarkerView = markerById.get(sessionID);
		markerView.x = tuioObjectsElement.pos.x * 1920;
		markerView.y = tuioObjectsElement.pos.y * 1080;
		markerView.rotation = tuioObjectsElement.rotation;		
	}
	
}
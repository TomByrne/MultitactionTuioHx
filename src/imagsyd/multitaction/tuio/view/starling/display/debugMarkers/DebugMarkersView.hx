package imagsyd.multitaction.tuio.view.starling.display.debugMarkers;
import imagsyd.multitaction.model.TuioObjectsModel;
import imagsyd.multitaction.tuio.view.starling.display.debugMarkers.marker.TuioDebugMarkerView;

import com.imagination.util.time.EnterFrame;
import haxe.ds.Map;
import imagsyd.multitaction.model.ITuioObjectsModel;
import imagsyd.multitaction.model.TuioObjectsModel.TuioObjectElement;
import imagsyd.multitaction.tuio.listener.MastercardCardListener;
import starling.display.Quad;
import starling.display.Sprite;

/**
 * ...
 * @author Michal Moczynski
 */
class DebugMarkersView extends Sprite 
{
	var markerById:haxe.ds.Map<UInt, TuioDebugMarkerView>;
	var tuioObjectsModel:ITuioObjectsModel;

	public function new() 
	{
		super();
		
	}
	
	public function initialize(tuioObjectsModel:ITuioObjectsModel) 
	{
		this.tuioObjectsModel = tuioObjectsModel;
		
		markerById = new Map<UInt, TuioDebugMarkerView>();
		
		EnterFrame.add( handleFrame );
	}
	
	function handleFrame():Void 
	{
		
		for ( tuioObjectsElement in tuioObjectsModel.tuioObjects) 
		{
			if (markerById.exists(tuioObjectsElement.sessionId))
			{
				moveMarker( tuioObjectsElement.sessionId, tuioObjectsElement );
			}
			else
			{
				addMarker( tuioObjectsElement.classId, tuioObjectsElement.sessionId );
				moveMarker( tuioObjectsElement.sessionId, tuioObjectsElement);
			}
		}
		
		for ( key in markerById.keys())
		{
			if (tuioObjectsModel.tuioObjectsMap.exists( key ) == false)
			{
				removeMarker(key);
			}
		}
    }
	
	public function removeMarker(sessionID:UInt) 
	{
		if (!markerById.exists(sessionID))
			return;
			
		var markerView:TuioDebugMarkerView = markerById.get(sessionID);
		markerById.remove(sessionID);
		markerView.removeFromParent(true);
	}
	
	public function addMarker(classID:UInt, sessionID:Int) 
	{
		if (markerById.exists(sessionID))
			return;			
		
		var markerView:TuioDebugMarkerView = new TuioDebugMarkerView();
		addChild(markerView);
		markerView.setID( classID, sessionID );
		markerById.set(sessionID, markerView);		
	}
	
	public function moveMarker(sessionID:UInt, tuioObjectsElement:TuioObjectElement) 
	{
		if (!markerById.exists(sessionID))
			return;
			
		var markerView:TuioDebugMarkerView = markerById.get(sessionID);
		markerView.x = tuioObjectsElement.pos[0].x * 1920;
		markerView.y = tuioObjectsElement.pos[0].y * 1080;
		markerView.rotation = tuioObjectsElement.r;		
	}
	
}
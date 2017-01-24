package com.imagination.multitaction.core.services.tuio.listeners;

//import com.imagination.multitaction.core.services.session.SessionService;
import com.imagination.util.signals.Signal.Signal1;
import flash.utils.Dictionary;
import openfl.Vector;
import org.osflash.signals.Signal;
import org.tuio.ITuioListener;
import org.tuio.TuioBlob;
import org.tuio.TuioCursor;
import org.tuio.TuioObject;
import starling.events.Touch;
import starling.events.TouchPhase;
/**
 * ...
 * @author P.J.Shand
 */
class TouchInputListener implements ITuioListener 
{
//	@inject public var sessionService:SessionService;
	
	public var width:Int = 100;
	public var height:Int = 100;
	
	private var touches:Map<String, Touch> = new Map<String, Touch>();
	
	private var touchMaps:Vector<TouchMap> = new Vector<TouchMap>();
	
	public var onBegin:Signal1<Touch> = new Signal1(Touch);
	public var onMove:Signal1<Touch> = new Signal1(Touch);
	public var onEnd:Signal1<Touch> = new Signal1(Touch);
	
	private var keepAlive:Int = 10;
	private var filteredTouchSessionIDs:Map<UInt, Bool> = new Map<UInt, Bool>();
	
	public function new() 
	{
		
	}
	
	public function addTuioObject(tuioObject:TuioObject):Void {}
	public function updateTuioObject(tuioObject:TuioObject):Void {}
	public function removeTuioObject(tuioObject:TuioObject):Void {}
	public function addTuioBlob(tuioBlob:TuioBlob):Void { }
	public function updateTuioBlob(tuioBlob:TuioBlob):Void { }
	public function removeTuioBlob(tuioBlob:TuioBlob):Void { }
	
	public function addTuioCursor(tuioCursor:TuioCursor):Void 
	{
		createTouch(TouchPhase.BEGAN, tuioCursor);
	}
	
	public function updateTuioCursor(tuioCursor:TuioCursor):Void 
	{
		createTouch(TouchPhase.MOVED, tuioCursor);
	}
	
	public function removeTuioCursor(tuioCursor:TuioCursor):Void 
	{
		createTouch(TouchPhase.ENDED, tuioCursor);
	}
	
	public function newFrame(id:UInt):Void 
	{
		//removeTouchesThatAreVeryCloseToEachOther();
		
		for (j in touches) {
			var touch:Touch = j;
			if (touch.phase == TouchPhase.BEGAN) {
				onBegin.dispatch(touch);
			}
			else if (touch.phase == TouchPhase.MOVED) {
				//trace("moved " + touch.globalX + " " + touch.globalY);
				onMove.dispatch(touch);
			}
			else if (touch.phase == TouchPhase.ENDED) {
				onEnd.dispatch(touch);
				clearIdMap(touch.id);
			}
		}
		
		touches = new Map<String, Touch>();
	}
	
	private function removeTouchesThatAreVeryCloseToEachOther():Void 
	{
		for (item in touches) 
		{
			var dif:Float = 0;
			var closeTouches:Vector<Touch> = new Vector<Touch>();
			for (item2 in touches) 
			{
				if (item == item2) continue;
				
				var subDifX:Int = Std.int( Math.abs(item.globalX - item2.globalX) );
				var subDifY:Int = Std.int( Math.abs(item.globalY - item2.globalY) );
				var subDif:Float = Math.sqrt(Math.pow(subDifX, 2) + Math.pow(subDifY, 2));
				
				if (subDif < 100) {
					dif += subDif;
					closeTouches.push(item2);
				}
			}
			if ((closeTouches.length+1) >= 4){
				if (dif < 50 * (closeTouches.length+1)) {
					closeTouches.push(item);
					for (i in 0 ... closeTouches.length ) 
					{
						removeTouch(closeTouches[i]);
					}
				}
			}
		}
	}
	
	private function removeTouch(touch:Touch):Void 
	{
		for (k in touches.keys()) {
			var value:Touch = touches.get(k);
			if (value.phase == TouchPhase.BEGAN) {
				touches.remove(k);
			}
			// somewhat dangerous because this could fire on end touch events
			if (value == touch){
				value.phase = TouchPhase.ENDED;
			}
		}
	}
	
	private function createTouch(phase:String, tuioCursor:TuioCursor):Void 
	{
		var awayFromMarker:Bool = false;//sessionService.markerListener.filterTouches(tuioCursor);
		/*if (!awayFromMarker || invalidSession(tuioCursor.sessionID)) {
			addFilterSessionID(tuioCursor.sessionID);
			phase = TouchPhase.ENDED;
		}
		*/
		
		var sessionID:Int = tuioCursor.sessionID;
		
		var touchID:TouchMap = touchMapBySessionID(sessionID);
		
		if (touches.get(phase + "-" + touchID.touchID) == null) {
			var t:Touch = new Touch(touchID.touchID);
			t.phase = phase;
			touches.set(phase + "-" + touchID.touchID, t);
		}
		
		var touch:Touch = touches.get(phase + "-" + touchID.touchID);
		if (touch != null) {
			touch.globalX = tuioCursor.x * width;
			touch.globalY = tuioCursor.y * height;
		}
	}
	
	private function addFilterSessionID(sessionID:UInt):Void 
	{
		filteredTouchSessionIDs.set(sessionID, true);
	}
	
	private function removeFilterSessionID(sessionID:UInt):Void 
	{
		filteredTouchSessionIDs.remove(sessionID);
	}
	
	public function invalidSession(sessionID:UInt):Bool 
	{
		if (filteredTouchSessionIDs.get(sessionID) != null) return true;
		return false;
	}
	
	private function touchMapBySessionID(sessionID:UInt):TouchMap 
	{
		for (i in 0 ... touchMaps.length) 
		{
			if (touchMaps[i].sessionID == sessionID) {
				return touchMaps[i];
			}
		}
		var touchMap:TouchMap = new TouchMap(sessionID);
		touchMaps.push(touchMap);
		return touchMap;
	}
	
	private function touchMapByTouchID(touchID:Int):TouchMap 
	{
		for (i in 0 ... touchMaps.length ) 
		{
			if (touchMaps[i].touchID == touchID) {
				return touchMaps[i];
			}
		}
		return null;
	}
	
	private function clearIdMap(id:Int):Void 
	{
		var l:Int = touchMaps.length;
		for (i in 0 ...  l) 
		{
			if (i < touchMaps.length && touchMaps[i].touchID == id) {
				touchMaps[i].remove();
				touchMaps.splice(i, 1);
			}
		}
	}
}

class TouchMap
{
	private static var availableIDs:Vector<Bool> = new Vector<Bool>(1000);
	private var _touchIndex:Int;
	public var touchIndex(get, set):Int;
	private var _touchID:Int;
	public var touchID(get, null):Int;
	public var sessionID:UInt;
	public var isCloseToMarker:Bool = false;

	public function new(sessionID:UInt)
	{
		if (Math.isNaN(sessionID)) return;
		
		this.sessionID = sessionID;
		for (i in 0 ...availableIDs.length ) 
		{
			if (!availableIDs[i]) {
				availableIDs[i] = true;
				touchIndex = i;
				break;
			}
		}
	}

	public function remove():Void 
	{
		availableIDs[touchIndex] = false;
	}

	public function clone():TouchMap 
	{
		var touchMap:TouchMap = new TouchMap( this.sessionID );
		//touchMap.sessionID =;
		touchMap.touchIndex = this.touchIndex;
		return touchMap;
	}

	public function get_touchID():Int 
	{
		return _touchID;
	}

	function get_touchIndex():Int 
	{
		return _touchIndex;
	}

	function set_touchIndex(value:Int):Int 
	{
		_touchIndex = value;
		_touchID = 100 + touchIndex;
		return _touchIndex;	
	}
}
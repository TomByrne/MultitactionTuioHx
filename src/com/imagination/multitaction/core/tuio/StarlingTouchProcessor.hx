package com.imagination.multitaction.core.tuio;

import imagsyd.imagination.utils.time.EnterFrame;
import imagsyd.imagination.utils.GeomTools;
import imagsyd.imagination.utils.PreemptPosition;
import flash.geom.Point;
import flash.utils.Dictionary;
import org.tuio.core.ITuioRawInputListener;
import org.tuio.core.TuioBlob;
import org.tuio.core.TuioCursor;
import org.tuio.core.TuioObject;
import starling.core.Starling;
import starling.events.TouchPhase;

/**
 * ...
 * @author Thomas Byrne
 */
class StarlingTouchProcessor implements ITuioRawInputListener 
{
	static private  inline var TOUCH_ID_OFFSET:Int = 100;
	static private  inline var KEEP_ALIVE:Int = 3; // frames
	static private  inline var REVIVE_DIST:Float = 50; // px
	static private var DUMMY_POINT:Point = new Point();
	
	private var starling:Starling;
	private var filteredTouchIds:Dictionary;
	private var filterTouchFunc:Function;
	private var sessionMap:Dictionary;
	private var idMap:Dictionary;
	private var touchTrackers:Vector<TouchTracker>;
	private var frame:Int = 0;
	
	public function new(starling:Starling, filterTouchFunc:Function=null) 
	{
		this.starling = starling;
		filteredTouchIds = new Dictionary();
		this.filterTouchFunc = filterTouchFunc;
		sessionMap = new Dictionary();
		idMap = new Dictionary();
		touchTrackers = new Vector<TouchTracker>();
		EnterFrame.add(onEnterFrame);
	}
	
	private function onEnterFrame(msDelta:Int):Void 
	{
		frame++;
		
		var i:Int = 0;
		while ( i < touchTrackers.length ) {
			var tracker:TouchTracker = touchTrackers[i];
			
			if(tracker.removing){
				var sinceSeen:Int = frame - tracker.lastSeen;
				if (sinceSeen >= KEEP_ALIVE) {
					touchTrackers.splice(i, 1);
					tracker.added = false;
					tracker.removing = false;
					delete idMap[tracker.index];
					starling.touchProcessor.enqueue( tracker.index, TouchPhase.ENDED, tracker.lastX , tracker.lastY);
					trace("REMOVE: "+frame, tracker.index);
					continue;
				}
			}
			if (tracker.updated) {
				tracker.updated = false;
				starling.touchProcessor.enqueue( tracker.index, TouchPhase.MOVED, tracker.lastX , tracker.lastY);
				trace("updateTuioCursor: "+frame, tracker.index, tracker.lastX , tracker.lastY);
			}else {
				tracker.deltaX = 0;
				tracker.deltaY = 0;
				trace("zero: "+frame, tracker.index, tracker.deltaX, tracker.deltaY);
			}
			i++;
		}
	}
	
	/* IntERFACE org.tuio.core.ITuioRawInputListener */
	
	public function addTuioObject(tuioObject:TuioObject):Void 
	{
	}
	
	public function updateTuioObject(tuioObject:TuioObject):Void 
	{
	}
	
	public function removeTuioObject(tuioObject:TuioObject):Void 
	{
		
	}
	
	public function addTuioCursor(tuioCursor:TuioCursor):Void 
	{
		if (filterTouchFunc != null && !filterTouchFunc(tuioCursor) ) {
			filteredTouchIds[tuioCursor.sessionID] = true;
			return;
		}
		var newX:Float = tuioCursor.x * starling.stage.stageWidth;
		var newY:Float = tuioCursor.y * starling.stage.stageHeight;
		var tracker:TouchTracker = reviveTracker(newX, newY);
		if (!tracker) {
			tracker = getAvailableTracker();
			tracker.deltaX = 0;
			tracker.deltaY = 0;
		}else {
			tracker.deltaX = tracker.lastX - newX;
			tracker.deltaX = tracker.lastY - newY;
		}
		sessionMap[tuioCursor.sessionID] = tracker;
		idMap[tracker.index] = tracker;
		tracker.added = true;
		tracker.lastX = newX;
		tracker.lastY = newY;
		tracker.lastSeen = frame;
		trace("addTuioCursor: "+frame, tuioCursor.sessionID, tracker.index);
		starling.touchProcessor.enqueue( tracker.index, TouchPhase.BEGAN, tracker.lastX , tracker.lastY);
	}
	
	private function reviveTracker(x:Float, y:Float):TouchTracker 
	{
		for (i in 0 ... touchTrackers.length ) {
			var tracker:TouchTracker = touchTrackers[i];
			if (!tracker.removing) continue;
			
			var sinceSeen:Int = frame - tracker.lastSeen;
			PreemptPosition.getPos(tracker.lastX, tracker.lastY, tracker.deltaX, tracker.deltaY, DUMMY_POINT, sinceSeen);
			var dist:Float = GeomTools.dist(DUMMY_POINT.x, DUMMY_POINT.y, tracker.lastX, tracker.lastY);
			trace("sinceSeen: "+tracker.index, dist, sinceSeen, DUMMY_POINT.x, DUMMY_POINT.y+" <> "+x, y);
			if (dist < REVIVE_DIST) {
				trace("revive");
				tracker.removing = false;
				return tracker;
			}
		}
		return null;
	}
	
	private function getAvailableTracker():TouchTracker 
	{
		for (i in 0 ... touchTrackers.length ) {
			var tracker:TouchTracker = touchTrackers[i];
			if (!tracker.added) return tracker;
		}
		tracker = new TouchTracker(touchTrackers.length);
		touchTrackers.push(tracker);
		return tracker;
	}
	
	public function updateTuioCursor(tuioCursor:TuioCursor):Void 
	{
		if (filteredTouchIds[tuioCursor.sessionID] ) return;
		var tracker:TouchTracker = sessionMap[tuioCursor.sessionID];
		var newX:Float = tuioCursor.x * starling.stage.stageWidth;
		var newY:Float = tuioCursor.y * starling.stage.stageHeight;
		if (tracker.lastSeen == frame) {
			var difX:Float = tracker.lastX - newX;
			var difY:Float = tracker.lastY - newY;
			tracker.deltaX += difX;
			tracker.deltaY += difY;
		}else{	
			tracker.deltaX = tracker.lastX - newX;
			tracker.deltaY = tracker.lastY - newY;
			tracker.lastSeen = frame;
		}
		tracker.lastX = newX;
		tracker.lastY = newY;
		tracker.updated = true;
		trace("up: "+frame, tuioCursor.sessionID, tracker.index, newX, newY);
		//trace("updateTuioCursor: "+frame, tuioCursor.sessionID, tracker.deltaX, tracker.deltaY);
		//starling.touchProcessor.enqueue( tracker.index, TouchPhase.MOVED, tracker.lastX , tracker.lastY);
	}
	
	public function removeTuioCursor(tuioCursor:TuioCursor):Void 
	{
		if (filteredTouchIds[tuioCursor.sessionID] ) {
			delete filteredTouchIds[tuioCursor.sessionID];
			return;
		}
		var tracker:TouchTracker = sessionMap[tuioCursor.sessionID];
		delete sessionMap[tuioCursor.sessionID];
		tracker.removing = true;
		tracker.deltaX = 0;
		tracker.deltaY = 0;
		tracker.lastX = tuioCursor.x * starling.stage.stageWidth;
		tracker.lastY = tuioCursor.y * starling.stage.stageHeight;
		tracker.lastSeen = frame;
		tracker.updated = true;
		trace("rem: "+frame, tuioCursor.sessionID, tracker.index, tracker.lastX, tracker.lastY);
		//starling.touchProcessor.enqueue( tracker.index, TouchPhase.ENDED, tracker.lastX , tracker.lastY);
	}
	
	public function addTuioBlob(tuioBlob:TuioBlob):Void 
	{
		
	}
	
	public function updateTuioBlob(tuioBlob:TuioBlob):Void 
	{
		
	}
	
	public function removeTuioBlob(tuioBlob:TuioBlob):Void 
	{
		
	}
	
	public function newFrame(id:UInt):Void 
	{
		
	}
	public function getTouchPos(id:Int, fill:Point):Void {
		var touchTracker:TouchTracker = idMap[id];
		if (!touchTracker) {
			fill.x = 0;
			fill.y = 0;
			return;
		}
		var sinceSeen:Int = frame - touchTracker.lastSeen;
		PreemptPosition.getPos(touchTracker.lastX, touchTracker.lastY, touchTracker.deltaX, touchTracker.deltaY, fill, sinceSeen+1, false);
	}
	
	/*public function getTouchVelocityX(id:Int):Float 
	{
		var touchTracker:TouchTracker = idMap[id];
		return -touchTracker.deltaX * 5;
	}
	
	public function getTouchVelocityY(id:Int):Float 
	{
		var touchTracker:TouchTracker = idMap[id];
		return -touchTracker.deltaY * 5;
	}*/
	
}

}

class TuioTracker {

public static var STATE_BEGAN:String = "began";
public static var STATE_UPDATED:String = "updated";
public static var STATE_ENDED:String = "ended";
public static var STATE_DISABLED:String = "disabled";

public var state:String = STATE_BEGAN;

public var x:Float;
public var y:Float;


public function TuioTracker() {
	
}
}

class TouchTracker {

public var lastSeen:Int;
public var lastX:Float;
public var lastY:Float;
public var deltaX:Float;
public var deltaY:Float;
public var added:Bool;
public var index:Int;
public var removing:Bool;
public var updated:Bool;


public function TouchTracker(index:Int) {
	this.index = index;
}
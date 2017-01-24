package com.imagination.multitaction.core.tuio;

//import imagsyd.imagination.utils.lang.closure;
import com.imagination.delay.EnterFrame;
import com.imagination.util.graphics.GeomTools;
import haxe.Timer;
import imagsyd.imagination.model.session.SessionMarker;
import imagsyd.imagination.view.SessionDimensions;
import flash.geom.Point;
import flash.utils.Dictionary;
//import flash.utils.getTimer;
import openfl.Vector;
import org.tuio.ITuioListener;
import org.tuio.TuioBlob;
import org.tuio.TuioCursor;
import org.tuio.TuioObject;
import starling.display.Stage;

/**
 * ...
 * @author Thomas Byrne
 */
class MarkerProcessor implements ITuioListener 
{
	private static  inline var INVALID_ID:Float = 4291824926;
	
	private static  inline var REMOVE_DELAY:Int = 4000;
	private static  inline var REVIVE_DIST:Int = 1000; // px per second
	private static  inline var MIN_REVIVE_DIST:Int = 150; // px
	private static  inline var MAX_REVIVE_DIST:Int = 300; // px
	private static  inline var MERGE_DIST:Int = 200; // px 
	private static  inline var UPDATE_MERGE_DIST:Int = 50; // px 
	
	private var onMarkerAdd:SessionMarker -> Void;
	private var onMarkerRemove:SessionMarker -> Bool -> Void;
	private var allowMarkerSpawn:TuioObject ->Bool;
	
	private var _markers:Vector<SessionMarker>;
	private var _markerLookup:Map<UInt, SessionMarker>;
	private var _removingSessions:Vector<RemovingSession>;
	private var stage:Stage;
	private var _ignoreSessions:Map<UInt, Bool>;
	private var frame:Int = 0;
	
	public function new(stage:Stage, onMarkerAdd:SessionMarker -> Void, onMarkerRemove:SessionMarker -> Bool -> Void, allowMarkerSpawn:TuioObject ->Bool=null) 
	{
		this.onMarkerAdd = onMarkerAdd;
		this.onMarkerRemove = onMarkerRemove;
		this.allowMarkerSpawn = allowMarkerSpawn;
		
		this.stage = stage;
		
		_markers = new Vector<SessionMarker>();
		_markerLookup = new Map<UInt, SessionMarker>();
		_ignoreSessions = new Map<UInt, Bool>();
		_removingSessions = new Vector<RemovingSession>();
		
		EnterFrame.add(onEnterFrame);
	}
	
	private function onEnterFrame(msDelta:Int):Void 
	{
		frame++;
		var j:Int = 0;
		while ( j < _markers.length) {
			var marker:SessionMarker = _markers[j];
			
			var t:Int = Std.int( Timer.stamp() * 1000 );
			var closestMarker:SessionMarker = null;
			var closestDist:Float;
			var othMarker:SessionMarker;
			for ( i in 0 ... _markers.length ) {
				othMarker = _markers[i];
				if (othMarker == marker) continue;
				if (othMarker.lastSeen==marker.lastSeen) continue;
				
				var difX:Float = (marker.x - othMarker.x) * stage.stageWidth;
				var difY:Float = (marker.y - othMarker.y) * stage.stageHeight;
				var dist:Float = Math.sqrt(difX * difX + difY * difY);
				
				if (closestMarker == null || dist < closestDist ) {
					closestMarker = othMarker;
					closestDist = dist;
				}
			}
			
			var maxDist:Float = UPDATE_MERGE_DIST;
			
			if (closestMarker != null && closestDist <= maxDist) {
				//trace("MERGE: "+marker.codes+" + "+closestMarker.codes, marker.lastSeen, closestMarker.lastSeen, frame);
				for ( sessionId in marker.sessionIDs) {
					_markerLookup.set(sessionId, othMarker);
					othMarker.addSessionId(sessionId);
				}
				for (code in marker.codes) {
					othMarker.addMarkerId(code);
				}
				if (marker.removing) {
					undoRemoving(marker);
					
				}else if(othMarker.removing){
					othMarker.setRemoving(false);
					undoRemoving(othMarker);
					var removing:RemovingSession = findRemoving(othMarker);
				}
				_markers.splice(j, 1);
				onMarkerRemove(marker, false);
				continue;
				
			}else if (marker.isPosChanged) {
				marker.isPosChanged = false;
				marker.posChanged.dispatch(marker);
			}
			++j;
		}
	}
	
	private function undoRemoving(marker:SessionMarker, removing:RemovingSession=null):Void 
	{
		if (removing != null) removing = findRemoving(marker);
		removing.marker = null;
		var index:Int = _removingSessions.indexOf(removing);
		_removingSessions.splice(index, 1);
		//trace("CLEAR TIMEOUT: "+removing.timeoutId, index);
		removing.timeoutId.stop();
	}
	
	public function addManualMarker(marker:SessionMarker):Void 
	{
		if (_markers.indexOf(marker) != -1) return;
		_markers.push(marker);
		onMarkerAdd(marker);
	}
	public function removeManualMarker(marker:SessionMarker):Void 
	{
		var index:Int = _markers.indexOf(marker);
		if (index == -1) return;
		_markers.splice(index, 1);
		onMarkerRemove(marker, true);
	}
	
	public function addTuioObject(tuioObject:TuioObject):Void 
	{
		// ignore
	}
	
	public function _addTuioObject(tuioObject:TuioObject):Void 
	{
		_ignoreSessions.remove(tuioObject.sessionID);
		//if (tuioObject.classID == INVALID_ID || tuioObject.classID==0) return;
		
		//trace("\n>>> ADD: "+ _markers.length, tuioObject.sessionID, tuioObject.classID, tuioObject.x, tuioObject.y );
		if (reviveSession(tuioObject)) return;
		if (mergeSession(tuioObject)) return;
		
		//if (tuioObject.classID == INVALID_ID || tuioObject.classID == 0) return;
		if (allowMarkerSpawn != null && !allowMarkerSpawn(tuioObject)) {
			_ignoreSessions.set(tuioObject.sessionID, true);
			return;
		}
		
		trace("addTuioObject: " + tuioObject.sessionID, tuioObject.classID, Timer.stamp() * 1000);
		
		var marker:SessionMarker = new SessionMarker();
		marker.lastSeen = frame;
		_markers.push(marker);
		_markerLookup.set(tuioObject.sessionID, marker);
		marker.updatePos(tuioObject.x, tuioObject.y, tuioObject.a);
		marker.addSessionId(tuioObject.sessionID);
		if (tuioObject.classID != INVALID_ID && tuioObject.classID != 0) {
			marker.addMarkerId(tuioObject.classID);
		}
		onMarkerAdd(marker);
		//trace("<<< ADD: "+_markers.length );
	}
	
	private function reviveSession(tuioObject:TuioObject):Bool 
	{
		var t:Int = Std.int( Timer.stamp() * 1000 );
		var closest:RemovingSession;
		var closestDist:Float;
		var closestInd:Int;
		for ( i in 0 ... _removingSessions.length ) {
			var removing:RemovingSession = _removingSessions[i];
			var timeDif:Float = (t - removing.removeTime) / 1000; // Time since removal began;
			
			var maxDist:Float = REVIVE_DIST * timeDif; // max distance from removing marker that new marker can be
			if (maxDist < MIN_REVIVE_DIST) maxDist = MIN_REVIVE_DIST;
			else if (maxDist > MAX_REVIVE_DIST) maxDist = MAX_REVIVE_DIST;
			
			var difX:Float = (tuioObject.x - removing.marker.x) * stage.stageWidth;
			var difY:Float = (tuioObject.y - removing.marker.y) * stage.stageHeight;
			var dist:Float = Math.sqrt(difX * difX + difY * difY);
			
			//if (removing.marker.getMarkerId() == tuioObject.classID) maxDist += 80;
		
			trace("reviveSession: " + dist, maxDist, tuioObject.classID, (dist < maxDist),  removing.marker.hasMarkerId(tuioObject.classID), removing.marker.codes);
			trace("\t\t" + removing.marker.x*stage.stageWidth, removing.marker.y*stage.stageHeight);
			if (dist < maxDist || removing.marker.hasMarkerId(tuioObject.classID)) {
				if (!closest || dist < closestDist) {
					closest = removing;
					closestDist = dist;
					closestInd = i;
				}
			}
		}
		if (!closest) return false;
		
		doMergeSessions(closest.marker, tuioObject, closest);
		return true;
	}
	
	private function doMergeSessions(marker:SessionMarker, tuioObject:TuioObject, removing:RemovingSession=null):Void 
	{
		/*for each(var sessionId:UInt in marker.sessionIDs) {
			delete _markerLookup[sessionId];
			marker.removeSessionId(sessionId);
		}*/
		_markerLookup.set(tuioObject.sessionID, marker);
		
		marker.lastSeen = frame;
		marker.updatePos(tuioObject.x, tuioObject.y, tuioObject.a);
		marker.addSessionId(tuioObject.sessionID);
		if (tuioObject.classID != INVALID_ID && tuioObject.classID != 0) {
			marker.addMarkerId(tuioObject.classID);
		}
		if (marker.removing) {
			marker.setRemoving(false);
			undoRemoving(marker, removing);
		}
	}
	
	private function mergeSession(tuioObject:TuioObject):Bool 
	{
		var t:Int = Std.int( Timer.stamp() * 1000 );
		var closestMarker:SessionMarker;
		var closestDist:Float;
		for ( i in 0 ...  _markers.length ) {
			var marker:SessionMarker = _markers[i];
			if (marker.lastSeen == frame) continue;
			
			var difX:Float = (tuioObject.x - marker.x) * stage.stageWidth;
			var difY:Float = (tuioObject.y - marker.y) * stage.stageHeight;
			var dist:Float = Math.sqrt(difX * difX + difY * difY);
			
			if (closestMarker != null || dist<closestDist) {
				closestMarker = marker;
				closestDist = dist;
			}
		}
		if (!closestMarker) return false;
		
		var maxDist:Float = MERGE_DIST;
		if (tuioObject.classID == INVALID_ID || tuioObject.classID == 0) maxDist += 120;
	
		trace("mergeSession: " + closestDist, closestDist <= MERGE_DIST, closestMarker.hasMarkerId(tuioObject.classID), closestMarker.codes);
		trace("\t\t" + closestMarker.x*stage.stageWidth, closestMarker.y*stage.stageHeight);
		if (closestDist <= maxDist || closestMarker.hasMarkerId(tuioObject.classID)) {
			doMergeSessions(closestMarker, tuioObject);
			return true;
		}
		return false;
	}
	
	public function updateTuioObject(tuioObject:TuioObject):Void 
	{
		if (_ignoreSessions.exists( tuioObject.sessionID )) return;
		
		var marker:SessionMarker = _markerLookup.get(tuioObject.sessionID);
		if (marker) {
			marker.lastSeen = frame;
			marker.updatePos(tuioObject.x, tuioObject.y, tuioObject.a);
			if (tuioObject.classID != INVALID_ID && tuioObject.classID != 0) {
				marker.addMarkerId(tuioObject.classID);
			}
		}else {
			//if (tuioObject.classID == INVALID_ID || tuioObject.classID == 0) return;
			
			//trace("WARNING: NO SESSION FOUND: " + tuioObject.sessionID, tuioObject.classID);
			_addTuioObject(tuioObject);
		}
	}
	
	public function removeTuioObject(tuioObject:TuioObject):Void 
	{
		if (_ignoreSessions.exists(tuioObject.sessionID)) return;
		
		//trace("\n>>> REMOVE: "+tuioObject.sessionID, tuioObject.classID);
		
		var marker:SessionMarker = _markerLookup.get(tuioObject.sessionID);
		if (!marker) return;
		
		_markerLookup.remove(tuioObject.sessionID);
		
		marker.removeSessionId(tuioObject.sessionID);
		if (marker.sessionIDs.length) return;
		
		var removing:RemovingSession;
		if (marker.removing) {
			removing = findRemoving(marker);
			//trace("CLEAR TIMEOUT 2: "+removing.timeoutId);
			removing.timeoutId.stop();
		}else {
			marker.setRemoving(true);
			removing = new RemovingSession(marker, Timer.stamp() * 1000);
			_removingSessions.push(removing);
		}
		
		trace("FIX !");
//		removing.timeoutId = Timer.delay(closure(finaliseRemove, false, [removing]), REMOVE_DELAY);
		trace("removeTuioObject: " + tuioObject.sessionID, marker.codes, Timer.stamp() * 1000, _removingSessions.length, removing.timeoutId);
		//trace("<<< REMOVE: "+_markers.length, removing.timeoutId );
	}
	
	private function findRemoving(marker:SessionMarker):RemovingSession 
	{
		for( removing in _removingSessions) {
			if (removing.marker == marker) return removing;
		}
		return null;
	}
	
	private function finaliseRemove(removing:RemovingSession):Void 
	{
		var index:Int = _removingSessions.indexOf(removing);
		trace("finaliseRemove: " + removing.marker.getMarkerId(), index, Timer.stamp() * 1000);
		_removingSessions.splice(index, 1);
		onMarkerRemove(removing.marker, true);
		for(sessionId in removing.marker.sessionIDs) {
			_markerLookup.remove(sessionId);
		}
		//removing.marker.setRemoving(false);
		
		index = _markers.indexOf(removing.marker);
		_markers.splice(index, 1);
	}
	
	public function addTuioCursor(tuioCursor:TuioCursor):Void 
	{
		
	}
	
	public function updateTuioCursor(tuioCursor:TuioCursor):Void 
	{
		
	}
	
	public function removeTuioCursor(tuioCursor:TuioCursor):Void 
	{
		
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
	private static var BUFFER:Float = 20;
	private static var DUMMY_POINT:Point = new Point();
	public function filterTouches(tuioCursor:TuioCursor):Bool 
	{
		var closestMarker:SessionMarker;
		var closestDist:Float;
		
		var returnVal:Bool = true;
		
		var posX:Float = tuioCursor.x * stage.stageWidth;
		var posY:Float = tuioCursor.y * stage.stageHeight;
		
		for(marker in _markers) {
			var markerX:Float = marker.x * stage.stageWidth;
			var markerY:Float = marker.y * stage.stageHeight;
			GeomTools.rotatePoint( -marker.rot, posX, posY, DUMMY_POINT, markerX, markerY);
			markerX += SessionDimensions.CARD_OFFSET_X;
			markerY += SessionDimensions.CARD_OFFSET_Y;
			if ( !(posX < markerX - BUFFER ||
				   posX > markerX + SessionDimensions.CARD_WIDTH + BUFFER ||
				   posY < markerY - BUFFER ||
				   posY > markerY + SessionDimensions.CARD_HEIGHT + BUFFER)) {
				
				returnVal = false;
			}else {
				//trace("THRU: "+posX+" x "+posY, markerX+" x "+markerY, GeomTools.dist(posX,posY, markerX,markerY));
			}
			var dist:Float = GeomTools.dist(markerX, markerY, posX, posY);
			if (isNaN(closestDist) || closestDist > dist) {
				closestDist = dist;
				closestMarker = marker;
			}
		}
		//if(closestMarker)trace("CURSOR: "+posX, posY, closestDist, closestMarker.removing);
		//else trace("CURSOR: "+tuioCursor.x, tuioCursor.y);
		if (closestMarker && closestMarker.removing && !closestMarker.isPosChanged && closestDist > 10 && closestDist < 50) {
			//trace("CURSOR: " + posX, posY, closestDist, closestMarker.removing);
			marker.updatePos(tuioCursor.x, tuioCursor.y, NaN, false);
		}
		return returnVal;
	}
	
	public function markerWithinRadius(position:Point, radius:Float):Bool
	{
		for(marker in _markers) {
			var difX:Float = (marker.x * stage.stageWidth) - position.x;
			var difY:Float = (marker.y * stage.stageHeight) - position.y;
			var dif:Float = Math.sqrt(Math.pow(difX, 2) + Math.pow(difY, 2));
			if (dif < radius) return true;
		}
		return false;
	}
}

class RemovingSession {
//import imagsyd.imagination.model.session.SessionMarker;
public var removeTime:Int;
public var marker:SessionMarker;
public var timeoutId:Timer;

	public function RemovingSession(marker:SessionMarker=null, removeTime:Int=-1) {
		this.marker = marker;
		this.removeTime = removeTime;
	}
}
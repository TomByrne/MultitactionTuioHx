package imagsyd.imagination.model.session;

import flash.utils.Dictionary;
import haxe.Timer;
import openfl.Vector;
import org.osflash.signals.Signal;
/**
 * ...
 * @author Thomas Byrne
 */
class SessionMarker 
{
	private static  inline var IN_MOTION_RESET_TIME:Int = 200; // in ms
	
	
	public var isPosChanged:Bool = true;
	public var posChanged:Signal = new Signal();
	public var removingChanged:Signal = new Signal();
	public var markerIdChanged:Signal = new Signal();
	
	private var idStore:Dictionary = new Dictionary();
	private var idRecords:Int = 0;
	
	public var sessionIDs:Vector<UInt>;
	public var codes:Vector<UInt>;
	public var lastSeen:Int;
	
	
	public var x:Float = 0;
	public var y:Float = 0;
	public var rot:Float = 0;
	public var removing:Bool = false;
	private var _inMotion:Bool = false;
	public var inMotionChange:Signal = new Signal();
	
	public var session:Session;
	
	private var _inMotionId:Timer = null;
	private var _lastId:UInt;
	private var _bestId:Float;
	
	public var isDebug:Bool;
	
	public function new(isDebug:Bool=false) 
	{
		this.isDebug = isDebug;
		sessionIDs = new Vector<UInt>();
		codes = new Vector<UInt>();
	}
	
	public function getMarkerId():Float {
		return _bestId;
	}
	
	public function updatePos(x:Float, y:Float, rot:Float=Math.NaN, invalidate:Bool=true):Void {
		var bigChange:Bool = !(checkSimilar(this.x, x, 30) && checkSimilar(this.y, y, 30) /*&& checkSimilar(this.rot, rot, 50)*/);
		//trace("\tupdatePos: "+x, y, bigChange, inMotion);
		if (!inMotion && !bigChange) return;
		
		
		this.x = x;
		this.y = y;
		if(!isNaN(rot))this.rot = rot;
		if (bigChange) {
			//if(!inMotion)trace("---inMotion: true");
			inMotion = true;
			
		}
		if(invalidate)isPosChanged = true;
		posChanged.dispatch(this);
	}
	
	public function setRemoving(value:Bool):Void 
	{
		if (removing == value) return;
		removing = value;
		removingChanged.dispatch(this);
	}
	
	public function removeSessionId(sessionId:UInt):Void 
	{
		var index:Int = sessionIDs.indexOf(sessionId);
		if (index != -1) sessionIDs.splice(index, 1);
	}
	
	public function addSessionId(sessionId:UInt):Void 
	{
		var index:Int = sessionIDs.indexOf(sessionId);
		if (index == -1) sessionIDs.push(sessionId);
	}
	
	public function addMarkerId(id:UInt):Void {
		//if (!idResolved) {
		if (id == 0) {
			id = id;
			return;
		}
		if (_lastId != id) {
			trace("\tADD ID: "+id);
			_lastId = id;
			if (idStore[id] == null) {
				idStore[id] = 1;
				codes.push(id);
			}else {
				idStore[id]++;
			}
			idRecords++;
			
			
			var bestCount:Int = -1;
			var bestId:Int;
			for (i in idStore) {
				var count:Int = idStore[i];
				if (bestCount == -1 || bestCount < count) {
					bestCount = count;
					bestId = i;
				}
			}
			if (_bestId != bestId) {
				_bestId = bestId;
				markerIdChanged.dispatch(this);
			}
		}
	}
	
	public function hasMarkerId(id:UInt):Bool 
	{
		return idStore[id];
	}
	
	private function checkSimilar(n1:Float, n2:Float, precision:Float):Bool {
		n1 = Math.round(n1 * precision);
		n2 = Math.round(n2 * precision);
		return n1 == n2;
	}
	
	public function get_inMotion():Bool 
	{
		return _inMotion;
	}
	
	public function set_inMotion(value:Bool):Bool 
	{
		if (value) {
			if (_inMotionId != null) _inMotionId.stop();
			_inMotionId = haxe.Timer.delay(resetInMotion, IN_MOTION_RESET_TIME);
		}
		
		if (_inMotion == value) return;
		_inMotion = value;
		inMotionChange.dispatch();
		return value;
	}
	
	private function resetInMotion():Void 
	{
		//trace("---inMotion: false");
		_inMotionId = null;
		inMotion = false;
	}
}
package com.imagination.multitaction.core.tuio;
import flash.desktop.NativeApplication;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;
import org.tuio.ITuioListener;
import org.tuio.TuioBlob;
import org.tuio.TuioCursor;
import org.tuio.TuioObject;
/**
 * ...
 * @author Thomas Byrne
 */
class InactivityKiller implements ITuioListener
{
	private var lastTimeout:Int = -1;
	private var inactivitySeconds:Float;
	
	public function new(inactivitySeconds:Float=Math.NaN) 
	{
		this.inactivitySeconds = inactivitySeconds;
	}
	
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
		if (lastTimeout != -1) {
			clearTimeout(lastTimeout);
		}
		if (!Math.isNaN(inactivitySeconds) && inactivitySeconds > 0) {
			lastTimeout = setTimeout(NativeApplication.nativeApplication.exit, inactivitySeconds * 1000);
		}
	}
	
}
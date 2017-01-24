package com.imagination.multitaction.core.services.tuio.listeners;
import com.imagination.core.managers.touch.TouchManager;
import org.tuio.ITuioListener;
import org.tuio.TuioBlob;
import org.tuio.TuioCursor;
import org.tuio.TuioObject;

/**
 * ...
 * @author Michal Moczynski
 */
class BasicListener implements ITuioListener 
{

	public function new() 
	{
		
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
	
	public function addTuioBlob(tuioBlob:TuioBlob):Void { }
	public function updateTuioBlob(tuioBlob:TuioBlob):Void {}
	public function removeTuioBlob(tuioBlob:TuioBlob):Void { }
	
	public function addTuioCursor(tuioCursor:TuioCursor):Void 
	{		
//		createTouch(TouchPhase.BEGAN, tuioCursor);
	}
	
	public function updateTuioCursor(tuioCursor:TuioCursor):Void 
	{
//		createTouch(TouchPhase.MOVED, tuioCursor);
	}
	
	public function removeTuioCursor(tuioCursor:TuioCursor):Void 
	{
//		createTouch(TouchPhase.ENDED, tuioCursor);
	}
	
	public function newFrame(id:UInt):Void 
	{
	}
	
}
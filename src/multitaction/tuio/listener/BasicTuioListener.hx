package multitaction.tuio.listener;
import org.tuio.ITuioListener;
import org.tuio.TuioBlob;
import org.tuio.TuioCursor;
import org.tuio.TuioObject;

/**
 * ...
 * @author Michal Moczynski
 */
class BasicTuioListener implements ITuioListener 
{

	public function new() 
	{
		
	}
	
	public function addTuioObject(tuioObject:TuioObject):Void {}	
	public function updateTuioObject(tuioObject:TuioObject):Void {}		
	public function removeTuioObject(tuioObject:TuioObject):Void {}	
	
	public function addTuioBlob(tuioBlob:TuioBlob):Void {}
	public function updateTuioBlob(tuioBlob:TuioBlob):Void {}
	public function removeTuioBlob(tuioBlob:TuioBlob):Void {}	
	
	public function addTuioCursor(tuioCursor:TuioCursor):Void {}	
	public function updateTuioCursor(tuioCursor:TuioCursor):Void {}	
	public function removeTuioCursor(tuioCursor:TuioCursor):Void {}
	
	public function newFrame(id:UInt):Void 
	{
	}
	
}
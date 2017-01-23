package imagsyd.imagination.services.tuioRecorder;
import com.imagination.util.data.JSON;
import com.imagination.util.fs.File;
import com.imagination.util.fs.Files;
import com.imagination.util.fs.FileTools;
import haxe.Json;
import imagsyd.imagination.model.tuio.TuioRecordedModel;
import openfl.ui.Keyboard;
import robotlegs.bender.extensions.imag.api.services.keyboard.IKeyboardMap;
import robotlegs.bender.extensions.imag.impl.services.keyboard.KeyboardMap;
import org.tuio.ITuioListener;
import org.tuio.TuioBlob;
import org.tuio.TuioCursor;
import org.tuio.TuioObject;
/**
 * ...
 * @author Michal Moczynski
 */
@:rtti
@:keepSub
class TuioRecorderService implements ITuioListener
{
	var recording:Bool;
	@inject public var keyboardMap:IKeyboardMap;
	@inject public var tuioRecordedModel:TuioRecordedModel;

	public function new() 
	{
		
	}
	
	public function initalize():Void
	{
		keyboardMap.map(startRecording, Keyboard.R);		
		keyboardMap.map(stopRecording, Keyboard.S);		
	}
	
	function stopRecording():Void
	{
		this.recording = false;
		
		var directory:File = File.applicationStorageDirectory;
		var path:String = directory.resolvePath( "tuio.txt" ).nativePath;
		
		FileTools.saveContent(path, JSON.stringify(tuioRecordedModel, null, "\t"));
	}
	
	function startRecording():Void
	{
		this.recording = true;
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
	public function updateTuioBlob(tuioBlob:TuioBlob):Void {  /*trace(tuioBlob.x + " " + tuioBlob.y + " " + tuioBlob.sessionID);*/ }
	public function removeTuioBlob(tuioBlob:TuioBlob):Void { }
	
	public function addTuioCursor(tuioCursor:TuioCursor):Void 
	{
		if (recording)
		{
			tuioRecordedModel.recordedAddedObjects.push(tuioCursor);
		}
	}
	
	public function updateTuioCursor(tuioCursor:TuioCursor):Void 
	{
		if(recording)
			tuioRecordedModel.recordedChangedObjects.push(tuioCursor);
	}
	
	public function removeTuioCursor(tuioCursor:TuioCursor):Void 
	{
		if (recording)
			tuioRecordedModel.recordedRemovedObjects.push(tuioCursor);
	}	
	
	public function newFrame(id:UInt):Void 
	{
	}	
}
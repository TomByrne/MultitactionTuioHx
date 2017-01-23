package imagsyd.imagination.services.tuioPlayback;
import com.imagination.util.data.JSON;
import com.imagination.util.fs.FileTools;
import flash.filesystem.File;
import format.swf.utils.NumberUtils;
import haxe.Timer;
import imagsyd.imagination.model.config.ConfigModel;
import imagsyd.imagination.model.tuio.TuioRecordedModel;
import imagsyd.imagination.services.tuio.listeners.BasicListener;
import imagsyd.imagination.services.tuio.listeners.TouchInputListener;
import imagsyd.imagination.services.tuio.TuioService;
import imagsyd.imagination.services.tuioRecorder.TuioRecorderService;
import openfl.events.Event;
import openfl.ui.Keyboard;
import robotlegs.bender.extensions.imag.api.services.keyboard.IKeyboardMap;
import starling.core.Starling;
import org.tuio.TuioCursor;

/**
 * ...
 * @author Michal Moczynski
 */
@:rtti
@:keepSub
class TuioPlaybackService
{
	var playbackFrame:UInt;
	@inject public var tuioRecordedModel:TuioRecordedModel;
	@inject public var configModel:ConfigModel;
	@inject public var keyboardMap:IKeyboardMap;
	@inject public var touchInputListener:TouchInputListener;

	public function new() 
	{
		
	}
	
	public function initalize():Void
	{
		keyboardMap.map(playback, Keyboard.P);		
	}
	
	public function playback():Void
	{
		var directory:File = File.applicationStorageDirectory;
		if ( directory.resolvePath( "tuioTouch.txt" ).exists )
		{
			var path:String = directory.resolvePath( "tuioTouch.txt" ).nativePath;
			
			var jsonString:String = FileTools.getContent(path);
			var obj:Dynamic = JSON.parse(jsonString);			
			for (i in 0 ... obj.recordedAddedObjects.length) 
			{
				var o:Dynamic = obj.recordedAddedObjects[i];
				tuioRecordedModel.recordedAddedObjects.push( new TuioCursor( o.type, o.sessionID, o.x, o.y, o.z, o.X, o.Y, o.Z, o.m, o.frameID));// , o.source));
			}
			for (i in 0 ... obj.recordedChangedObjects.length) 
			{
				var o:Dynamic = obj.recordedChangedObjects[i];
				tuioRecordedModel.recordedChangedObjects.push( new TuioCursor( o.type, o.sessionID, o.x, o.y, o.z, o.X, o.Y, o.Z, o.m, o.frameID));//, o.source));
			}
			for (i in 0 ... obj.recordedRemovedObjects.length) 
			{
				var o:Dynamic = obj.recordedRemovedObjects[i];
				tuioRecordedModel.recordedRemovedObjects.push( new TuioCursor( o.type, o.sessionID, o.x, o.y, o.z, o.X, o.Y, o.Z, o.m, o.frameID));//, o.source));
			}
			
			startPlayback();
		}
		
	}
	
	function startPlayback():Void
	{
		playbackFrame = Std.int( Math.POSITIVE_INFINITY );
		if (tuioRecordedModel.recordedAddedObjects.length > 0)
			playbackFrame = tuioRecordedModel.recordedAddedObjects[0].frameID;
		if (tuioRecordedModel.recordedChangedObjects.length > 0 && tuioRecordedModel.recordedChangedObjects[0].frameID < playbackFrame)
			playbackFrame = tuioRecordedModel.recordedChangedObjects[0].frameID;
		if (tuioRecordedModel.recordedRemovedObjects.length > 0 && tuioRecordedModel.recordedRemovedObjects[0].frameID < playbackFrame)
			playbackFrame = tuioRecordedModel.recordedRemovedObjects[0].frameID;
			
		Starling.current.nativeStage.addEventListener( Event.ENTER_FRAME, handleFrame);
	}
	
	private function handleFrame(e:Event):Void 
	{
		if (tuioRecordedModel.recordedAddedObjects.length > 0 && tuioRecordedModel.recordedAddedObjects[0].frameID <= playbackFrame)
		{
			touchInputListener.addTuioCursor( tuioRecordedModel.recordedAddedObjects[0] );
			tuioRecordedModel.recordedAddedObjects.shift();
		}
		if (tuioRecordedModel.recordedChangedObjects.length > 0 && tuioRecordedModel.recordedChangedObjects[0].frameID <= playbackFrame)
		{
			touchInputListener.updateTuioCursor( tuioRecordedModel.recordedChangedObjects[0] );
			tuioRecordedModel.recordedChangedObjects.shift();
		}
		if (tuioRecordedModel.recordedRemovedObjects.length > 0 && tuioRecordedModel.recordedRemovedObjects[0].frameID <= playbackFrame)
		{
			touchInputListener.removeTuioCursor( tuioRecordedModel.recordedRemovedObjects[0] );
			tuioRecordedModel.recordedAddedObjects.shift();
		}
		touchInputListener.newFrame( playbackFrame );
		playbackFrame++;
	}
	
}
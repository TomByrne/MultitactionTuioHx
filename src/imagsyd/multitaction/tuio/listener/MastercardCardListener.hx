package imagsyd.multitaction.tuio.listener;
import imagsyd.multitaction.tuio.touch.processors.StarlingTuioTouchProcessor;
import imagsyd.multitaction.tuio.listener.BasicProcessableTuioListener;
import imagsyd.multitaction.model.MarkerObjectsModel;
import imagsyd.multitaction.model.TuioMarkersStackableProcessesModel;
import imagsyd.multitaction.model.TuioTouchesSettingsModel;
import openfl.events.TouchEvent;
import openfl.geom.Point;
import org.tuio.ITuioListener;
import org.tuio.TuioBlob;
import org.tuio.TuioCursor;
import org.tuio.TuioObject;
import starling.core.Starling;
import starling.events.TouchPhase;

/**
 * @author Michal Moczynski
 */
@:rtti
@:keepSub
class MastercardCardListener extends BasicProcessableTuioListener
{
	@inject public var tuioStackableProcessesModel:TuioMarkersStackableProcessesModel;
	@inject public var tuioObjectsModelSingleton:MarkerObjectsModel;
	@inject public var tuioTouchSettingsModel:TuioTouchesSettingsModel;
	@inject public var starlingTuioTouchProcessor:StarlingTuioTouchProcessor;
	
	static public var MAX:Int = 1000;
	static public var counter:Int = 0;
	
	public function new() 
	{
		super();
	}

	public function initialize()
	{
		markerObjectsModel = tuioObjectsModelSingleton;
		processes = tuioStackableProcessesModel.tuioProcessors;
	}
	
	override public function newFrame(id:Int):Void 
	{
		super.newFrame(id);
	}
	
//tuio objects (markers)	
	override public function addTuioObject(tuioObject:TuioObject):Void 
	{
		super.addTuioObject(tuioObject);
		
		counter++;
		Logger.log(this, counter);
//		if (tuioObject.classID > 0 && tuioObject.classID < MAX)
		{
			Logger.log(this, "add tuioObject.sessionID: " + tuioObject.sessionID);
			if (tuioObjects.exists( tuioObject.sessionID))
				updateTuioObject( tuioObject )
			else
			{
				tuioObjects.set( tuioObject.sessionID, tuioObject);
			}
		}
	}	
	
	override public function updateTuioObject(tuioObject:TuioObject):Void 
	{
		super.updateTuioObject(tuioObject);
		
//		if (tuioObject.classID > 0 && tuioObject.classID < MAX)
		{
			if (tuioObjects.exists( tuioObject.sessionID) == false)
				addTuioObject( tuioObject )
			else
			{
				var to:TuioObject = tuioObjects.get( tuioObject.sessionID);
				to = tuioObject;
			}
		}
	}

	override public function removeTuioObject(tuioObject:TuioObject):Void 
	{
		super.removeTuioObject(tuioObject);
		
		counter--;
		Logger.log(this, counter);
		//if (tuioObject.classID > 0 && tuioObject.classID < MAX)
		{
			Logger.log(this, "remove tuioObject.sessionID: " + tuioObject.sessionID);
			if (tuioObjects.exists( tuioObject.sessionID) == false)
				return;
			else
			{
				tuioObjects.remove(tuioObject.sessionID);
				markerObjectsModel.tuioToMarkerMap.remove("t" + tuioObject.sessionID);
			}
		}
	}
	
//tuio touches	
	override public function addTuioCursor(tuioCursor:TuioCursor):Void 
	{
		if (tuioTouchSettingsModel.useTuioTouches.value)
		{
			starlingTuioTouchProcessor.injectTouch( tuioCursor.sessionID, TouchPhase.BEGAN, tuioCursor.x * Starling.current.nativeStage.stageWidth, tuioCursor.y * Starling.current.nativeStage.stageHeight);
		}
	}
	
	override public function updateTuioCursor(tuioCursor:TuioCursor):Void 
	{
		if (tuioTouchSettingsModel.useTuioTouches.value)
		{
			starlingTuioTouchProcessor.injectTouch( tuioCursor.sessionID, TouchPhase.MOVED, tuioCursor.x * Starling.current.nativeStage.stageWidth, tuioCursor.y * Starling.current.nativeStage.stageHeight);
		}
	}
	
	override public function removeTuioCursor(tuioCursor:TuioCursor):Void 
	{
		if (tuioTouchSettingsModel.useTuioTouches.value)
		{
			starlingTuioTouchProcessor.injectTouch( tuioCursor.sessionID, TouchPhase.ENDED, tuioCursor.x * Starling.current.nativeStage.stageWidth, tuioCursor.y * Starling.current.nativeStage.stageHeight);
		}
	}

}
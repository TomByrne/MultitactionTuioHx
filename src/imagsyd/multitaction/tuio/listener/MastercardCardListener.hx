package imagsyd.multitaction.tuio.listener;
import imagsyd.multitaction.tuio.touch.processors.StarlingTuioTouchProcessor;
import imagsyd.multitaction.tuio.listener.BasicProcessableTuioListener;
import imagsyd.multitaction.model.TuioObjectsModel;
import imagsyd.multitaction.model.TuioMarkersStackableProcessesModel;
import imagsyd.multitaction.model.TuioTouchesSettingsModel;
import openfl.events.TouchEvent;
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
	@inject public var tuioObjectsModelSingleton:TuioObjectsModel;
	@inject public var tuioTouchSettingsModel:TuioTouchesSettingsModel;
	@inject public var starlingTuioTouchProcessor:StarlingTuioTouchProcessor;
	
	static public var MAX:Int = 1000;

	public function new() 
	{
		super();
	}

	public function initialize()
	{
		tuioObjectsModel = tuioObjectsModelSingleton;
		processes = tuioStackableProcessesModel.tuioProcessors;
	}
	
//tuio objects (markers)	
	override public function addTuioObject(tuioObject:TuioObject):Void 
	{
		super.addTuioObject(tuioObject);
		
//		if (tuioObject.classID > 0 && tuioObject.classID < MAX)
		{
			Logger.log(this, "add tuioObject.classID: " + tuioObject.sessionID);
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
		
		//if (tuioObject.classID > 0 && tuioObject.classID < MAX)
		{
			if (tuioObjects.exists( tuioObject.sessionID) == false)
				return;
			else
			{
				tuioObjects.remove(tuioObject.sessionID);
				var arrayPosId:Int = tuioObjectsModel.tuioObjectsMap.get(tuioObject.sessionID);
				tuioObjectsModel.tuioObjects.splice(arrayPosId, 1);
				tuioObjectsModel.tuioObjectsMap.remove(tuioObject.sessionID);
				
				updatesMapFrom(arrayPosId);
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
	
//tuio frame	
	function updatesMapFrom(pos:Int) 
	{
		for (i in pos ... tuioObjectsModel.tuioObjects.length) 
		{
			tuioObjectsModel.tuioObjectsMap.remove(tuioObjectsModel.tuioObjects[i].sessionId);
			tuioObjectsModel.tuioObjectsMap.set(tuioObjectsModel.tuioObjects[i].sessionId, i);
		}
	}
}
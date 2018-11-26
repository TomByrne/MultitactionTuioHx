package imagsyd.multitaction.tuio.listener;
import imagsyd.multitaction.model.touch.TouchObjectsModel;
import imagsyd.multitaction.model.touch.TuioTouchesStackableProcessesModel;
import imagsyd.multitaction.tuio.processors.touch.base.StarlingTuioTouchProcessor;
import imagsyd.multitaction.tuio.listener.BasicProcessableTuioListener;
import imagsyd.multitaction.model.marker.MarkerObjectsModel;
import imagsyd.multitaction.model.marker.TuioMarkersStackableProcessesModel;
import imagsyd.multitaction.model.touch.TuioTouchesSettingsModel;
import org.tuio.TuioCursor;
import org.tuio.TuioObject;

/**
 * @author Michal Moczynski
 */
@:rtti
@:keepSub
class MastercardCardListener extends BasicProcessableTuioListener
{
	@inject public var markersStackableProcessesModel:TuioMarkersStackableProcessesModel;
	@inject public var touchStackableProcessesModel:TuioTouchesStackableProcessesModel;
	@inject public var markerObjectsModelSingleton:MarkerObjectsModel;
	@inject public var touchObjectsModelSingleton:TouchObjectsModel;
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
		markerObjectsModel = markerObjectsModelSingleton;
		touchObjectsModel = touchObjectsModelSingleton;
		markerProcesses = markersStackableProcessesModel.tuioMarkerProcessors;
		touchProcesses = touchStackableProcessesModel.tuioTouchProcessors;
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
//		Logger.log(this, counter);
//		Logger.log(this, "add tuioObject.sessionID: " + tuioObject.sessionID);
		if (tuioObjects.exists( tuioObject.sessionID))
			updateTuioObject( tuioObject )
		else
		{
			tuioObjects.set( tuioObject.sessionID, tuioObject);
		}
	}	
	
	override public function updateTuioObject(tuioObject:TuioObject):Void 
	{
		super.updateTuioObject(tuioObject);
		
		if (tuioObjects.exists( tuioObject.sessionID) == false)
			addTuioObject( tuioObject )
		else
		{
			var to:TuioObject = tuioObjects.get( tuioObject.sessionID);
//			this.log(" to.r " + to.r + " to.a " + to.a + " to.b " + to.b + " to.c " + to.c);
			to = tuioObject;
		}
	}

	override public function removeTuioObject(tuioObject:TuioObject):Void 
	{
		super.removeTuioObject(tuioObject);
		
		counter--;
//		Logger.log(this, counter);
//		Logger.log(this, "remove tuioObject.sessionID: " + tuioObject.sessionID);
		if (tuioObjects.exists( tuioObject.sessionID) == false)
			return;
		else
		{
			tuioObjects.remove(tuioObject.sessionID);
			markerObjectsModel.tuioToMarkerMap.remove("t" + tuioObject.sessionID);
		}
	}
	
//tuio touches	
	override public function addTuioCursor(tuioCursor:TuioCursor):Void 
	{
		super.addTuioCursor(tuioCursor);
		
		if (tuioTouchSettingsModel.useTuioTouches.value)
		{
			if (tuioCursors.exists( tuioCursor.sessionID))
				updateTuioCursor( tuioCursor )
			else
			{
				touchObjectsModel.cursorsAdded.set( tuioCursor.sessionID, tuioCursor );
				tuioCursors.set( tuioCursor.sessionID, tuioCursor);
			}
//			starlingTuioTouchProcessor.injectTouch( tuioCursor.sessionID, TouchPhase.BEGAN, tuioCursor.x * Starling.current.nativeStage.stageWidth, tuioCursor.y * Starling.current.nativeStage.stageHeight);
		}
	}
	
	override public function updateTuioCursor(tuioCursor:TuioCursor):Void 
	{
		super.updateTuioCursor(tuioCursor);
		
		if (tuioTouchSettingsModel.useTuioTouches.value)
		{
			if (tuioCursors.exists( tuioCursor.sessionID ))
			{
				var tc:TuioCursor = tuioCursors.get( tuioCursor.sessionID );
				tc = tuioCursor;
				touchObjectsModel.cursorsUpdated.set( tc.sessionID, tc );
			}
//			starlingTuioTouchProcessor.injectTouch( tuioCursor.sessionID, TouchPhase.MOVED, tuioCursor.x * Starling.current.nativeStage.stageWidth, tuioCursor.y * Starling.current.nativeStage.stageHeight);
		}
	}
	
	override public function removeTuioCursor(tuioCursor:TuioCursor):Void 
	{
		super.removeTuioCursor(tuioCursor);
		
		if (tuioTouchSettingsModel.useTuioTouches.value)
		{
		
			if (tuioCursors.exists( tuioCursor.sessionID) == false)
				return;
			else
			{
				tuioCursors.remove(tuioCursor.sessionID);
				touchObjectsModel.cursorsRemoved.set( tuioCursor.sessionID, tuioCursor );
			}
			
//			starlingTuioTouchProcessor.injectTouch( tuioCursor.sessionID, TouchPhase.ENDED, tuioCursor.x * Starling.current.nativeStage.stageWidth, tuioCursor.y * Starling.current.nativeStage.stageHeight);
		}
	}

}
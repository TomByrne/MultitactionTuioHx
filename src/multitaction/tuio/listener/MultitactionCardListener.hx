package multitaction.tuio.listener;

import multitaction.model.touch.TouchObjectsModel;
import multitaction.model.touch.TuioTouchesStackableProcessesModel;
import multitaction.tuio.listener.BasicProcessableTuioListener;
import multitaction.model.marker.MarkerObjectsModel;
import multitaction.model.marker.TuioMarkersStackableProcessesModel;
import multitaction.model.touch.TuioTouchesSettingsModel;
import org.tuio.TuioCursor;
import org.tuio.TuioObject;
import imagsyd.base.ISettings;

/**
 * @author Michal Moczynski
 */
@:rtti
@:keepSub
class MultitactionCardListener extends BasicProcessableTuioListener
{
	@inject public var settings:ISettings;	
	@inject public var markersStackableProcessesModel:TuioMarkersStackableProcessesModel;
	@inject public var touchStackableProcessesModel:TuioTouchesStackableProcessesModel;
	@inject public var markerObjectsModelSingleton:MarkerObjectsModel;
	@inject public var touchObjectsModelSingleton:TouchObjectsModel;
	@inject public var tuioTouchSettingsModel:TuioTouchesSettingsModel;
	
	public var flippedOrientation:Bool;
	static public var MAX:Int = 1000;
	static public var counter:Int = 0;
	
	public function new() 
	{
		super();
	}

	public function initialize(flippedOrientation:Bool)
	{
		markerObjectsModel = markerObjectsModelSingleton;
		touchObjectsModel = touchObjectsModelSingleton;
		markerProcesses = markersStackableProcessesModel.tuioMarkerProcessors;
		touchProcesses = touchStackableProcessesModel.tuioTouchProcessors;
		this.flippedOrientation = flippedOrientation;

		settings.watch(['tuioRotationOffset'], onSettingsChanged);
		onSettingsChanged();
	}
	
	override public function newFrame(id:Int):Void 
	{
		super.newFrame(id);
	}
	
	function onSettingsChanged()
	{
		markerObjectsModel.angleOffset = settings.float('tuioRotationOffset', -1.57);
	}

//tuio objects (markers)	
	override public function addTuioObject(tuioObject:TuioObject):Void 
	{
		if(flippedOrientation)
			tuioObject.flip();

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
		if(flippedOrientation)
			tuioObject.flip();

		super.updateTuioObject(tuioObject);
		
		if (tuioObjects.exists( tuioObject.sessionID) == false)
			addTuioObject( tuioObject )
		else
		{
			var to:TuioObject = tuioObjects.get( tuioObject.sessionID );
			tuioObjects.set(to.sessionID, tuioObject);
			//to = tuioObject;
		}
	}

	override public function removeTuioObject(tuioObject:TuioObject):Void 
	{
		if(flippedOrientation)
			tuioObject.flip();

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
		if(flippedOrientation)
			tuioCursor.flip();

		super.addTuioCursor(tuioCursor);
		
		if (tuioTouchSettingsModel.useTuioTouches.value)
		{
			if (tuioCursors.exists( tuioCursor.sessionID))
				updateTuioCursor( tuioCursor )
			else
			{
				/*
				this.log("tuioCursor " + tuioCursor.sessionID + " " + tuioCursor.frameID );
				
				var q:Quad = new Quad(5, 5, 0xff0000);
				q.x = tuioCursor.x * 1920;
				q.y = tuioCursor.y * 1080;
				Starling.current.stage.addChild(q);
				*/
				touchObjectsModel.cursorsAdded.set( tuioCursor.sessionID, tuioCursor );
				tuioCursors.set( tuioCursor.sessionID, tuioCursor);
			}
		}
	}
	
	override public function updateTuioCursor(tuioCursor:TuioCursor):Void 
	{
		if(flippedOrientation)
			tuioCursor.flip();

		super.updateTuioCursor(tuioCursor);
		
		if (tuioTouchSettingsModel.useTuioTouches.value)
		{
			if (tuioCursors.exists( tuioCursor.sessionID ))
			{
				var tc:TuioCursor = tuioCursors.get( tuioCursor.sessionID );
				tc = tuioCursor;
				touchObjectsModel.cursorsUpdated.set( tc.sessionID, tc );
			}
		}
	}
	
	override public function removeTuioCursor(tuioCursor:TuioCursor):Void 
	{
		if(flippedOrientation)
			tuioCursor.flip();

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
		}
	}

}
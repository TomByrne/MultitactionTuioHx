package multitaction.logic.listener;

import org.swiftsuspenders.utils.DescribedType;
import multitaction.model.touch.TouchObjectsModel;
import multitaction.model.touch.TouchProcessorsModel;
import multitaction.logic.listener.BasicProcessableTuioListener;
import multitaction.model.marker.MarkerObjectsModel;
import multitaction.model.marker.MarkerProcessorsModel;
import multitaction.logic.tuio.TuioConfigLogic;
import org.tuio.TuioCursor;
import org.tuio.TuioObject;
import imagsyd.base.ISettings;

/**
 * @author Michal Moczynski
 */
class MultitactionCardListener extends BasicProcessableTuioListener implements DescribedType
{
	@inject public var settings:ISettings;	
	@inject public var markerProcessorsModel:MarkerProcessorsModel;
	@inject public var touchProcessorsModel:TouchProcessorsModel;
	@inject public var markerObjectsModel:MarkerObjectsModel;
	@inject public var touchObjectsModel:TouchObjectsModel;
	@inject public var tuioConfigLogic:TuioConfigLogic;
	
	public var flippedOrientation:Bool;
	static public var MAX:Int = 1000;
	static public var counter:Int = 0;
	
	public function new() 
	{
		super();
	}

	public function setup()
	{
		markerModel = markerObjectsModel;
		touchModel = touchObjectsModel;

		markerProcesses = markerProcessorsModel.tuioMarkerProcessors;
		touchProcesses = touchProcessorsModel.tuioTouchProcessors;

		settings.watch(['tuioRotationOffset', 'tuioFlippedOrientation'], onSettingsChanged);
		onSettingsChanged();

        tuioConfigLogic.addListener(this);
	}
	
	override public function newFrame(id:Int):Void 
	{
		super.newFrame(id);
	}
	
	function onSettingsChanged()
	{
		flippedOrientation = settings.bool('tuioFlippedOrientation', false);
		markerObjectsModel.angleOffset = settings.float('tuioRotationOffset', -1.57);
	}

//tuio objects (markers)	
	override public function addTuioObject(tuioObject:TuioObject):Void 
	{
		if(flippedOrientation)
			tuioObject.flip();

		super.addTuioObject(tuioObject);
		
		counter++;
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
		}
	}

	override public function removeTuioObject(tuioObject:TuioObject):Void 
	{
		if(flippedOrientation)
			tuioObject.flip();

		super.removeTuioObject(tuioObject);
		
		counter--;
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
		
        if (tuioCursors.exists( tuioCursor.sessionID))
            updateTuioCursor( tuioCursor )
        else
        {
            touchObjectsModel.cursorsAdded.set( tuioCursor.sessionID, tuioCursor );
            tuioCursors.set( tuioCursor.sessionID, tuioCursor);
        }
	}
	
	override public function updateTuioCursor(tuioCursor:TuioCursor):Void 
	{
		if(flippedOrientation)
			tuioCursor.flip();

		super.updateTuioCursor(tuioCursor);
		
        if (tuioCursors.exists( tuioCursor.sessionID ))
        {
            var tc:TuioCursor = tuioCursors.get( tuioCursor.sessionID );
            tc = tuioCursor;
            touchObjectsModel.cursorsUpdated.set( tc.sessionID, tc );
        }
	}
	
	override public function removeTuioCursor(tuioCursor:TuioCursor):Void 
	{
		if(flippedOrientation)
			tuioCursor.flip();

		super.removeTuioCursor(tuioCursor);
		
        if (tuioCursors.exists( tuioCursor.sessionID) == false)
            return;
        else
        {
            tuioCursors.remove(tuioCursor.sessionID);
            touchObjectsModel.cursorsRemoved.set( tuioCursor.sessionID, tuioCursor );
        }
	}

}
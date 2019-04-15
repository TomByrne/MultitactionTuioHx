package multitaction.logic.listener;

import multitaction.model.touch.ITouchObjectsModel;
import org.swiftsuspenders.utils.DescribedType;
import multitaction.model.touch.TouchObjectsModel;
import multitaction.model.touch.TouchProcessorsModel;
import multitaction.logic.listener.BasicProcessableTuioListener;
import multitaction.model.marker.IMarkerObjectsModel;
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
	@inject public var markerObjectsModel:IMarkerObjectsModel;
	@inject public var touchObjectsModel:TouchObjectsModel;
	@inject public var tuioConfigLogic:TuioConfigLogic;
	
	static public var MAX:Int = 1000;
	static public var counter:Int = 0;
	
	public function new() 
	{
		super();
	}

	@:keep public function setup()
	{
		markerModel = markerObjectsModel;
		touchModel = touchObjectsModel;

		markerProcesses = markerProcessorsModel.tuioMarkerProcessors;
		touchProcesses = touchProcessorsModel.tuioTouchProcessors;

        tuioConfigLogic.addListener(this);
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
		
		if (!tuioObjects.exists( tuioObject.sessionID))
			addTuioObject( tuioObject )
		else
		{
			var to:TuioObject = tuioObjects.get( tuioObject.sessionID );
			tuioObjects.set(to.sessionID, tuioObject);
		}
	}

	override public function removeTuioObject(tuioObject:TuioObject):Void 
	{
		super.removeTuioObject(tuioObject);
		
		counter--;
		if (!tuioObjects.exists( tuioObject.sessionID))
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
		
        if (touchObjectsModel.touches.exists( tuioCursor.sessionID))
            updateTuioCursor( tuioCursor )
        else
        {
            var touch:TouchObject = updateTouch(tuioCursor, TouchState.START);
            touchObjectsModel.touches.set(touch.id, touch);
            touchObjectsModel.touchList.push(touch);
        }
	}
	
	override public function updateTuioCursor(tuioCursor:TuioCursor):Void 
	{
		super.updateTuioCursor(tuioCursor);
		
        if (touchObjectsModel.touches.exists( tuioCursor.sessionID ))
        {
            var touch:TouchObject = touchObjectsModel.touches.get( tuioCursor.sessionID );
            updateTouch(tuioCursor, TouchState.MOVE, touch);
        }
	}
	
	override public function removeTuioCursor(tuioCursor:TuioCursor):Void 
	{
		super.removeTuioCursor(tuioCursor);
		
        if (touchObjectsModel.touches.exists( tuioCursor.sessionID)){
            var touch:TouchObject = touchObjectsModel.touches.get( tuioCursor.sessionID );
            updateTouch(tuioCursor, TouchState.END, touch);
        }
	}


    function updateTouch(cursor:TuioCursor, state:TouchState, ?update:TouchObject) : TouchObject
    {
        if(update != null){

            update.id = cursor.sessionID;
            update.state = state;
            update.x = cursor.x;
            update.y = cursor.y;
            update.rangeX = 1;
            update.rangeY = 1;
            update.cursor = cursor;
            return update;

        }else{
            return {
                id: cursor.sessionID,
                state: state,
                x: cursor.x,
                y: cursor.y,
                rangeX: 1,
                rangeY: 1,
                cursor: cursor,
            }
        }
    }
}
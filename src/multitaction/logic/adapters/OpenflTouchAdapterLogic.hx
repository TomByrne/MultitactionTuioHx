package multitaction.logic.adapters;

import lime.ui.Touch;
import openfl.events.TouchEvent;
import openfl.Lib;
import openfl.display.Stage;
import org.swiftsuspenders.utils.DescribedType;
import multitaction.model.touch.ITouchObjectsModel;
import org.tuio.TuioCursor;

@:access(openfl.display.Stage)
class OpenflTouchAdapterLogic implements DescribedType
{
    @inject public var touchObjectsModel:ITouchObjectsModel;

    var touch:Touch;
    var touchArray:Array<Int> = [];
    var mouseTouch:Null<Int> = null;

    public function setup()
    {
        touch = new Touch(0, 0, 0, 0, 0, 0.5, 10);

        touchObjectsModel.onProcessed.add(onTouchesProcessed);
    }

    function onTouchesProcessed()
    {
        var stage:Stage = Lib.current.stage;
		for (tc in touchObjectsModel.cursorsAdded) 
		{
            if(touchArray.length == 0){
                mouseTouch = tc.sessionID;
                stage.onMouseDown(stage.window, tc.x, tc.y, 0);
            }
            Touch.onStart.dispatch(updateTouch(tc, touch));
            touchArray.push(tc.sessionID);
            
		}

		for (tc in touchObjectsModel.cursorsUpdated) 
		{
            if(mouseTouch == tc.sessionID){
                stage.onMouseMove(stage.window, tc.x, tc.y);
            }
            Touch.onMove.dispatch(updateTouch(tc, touch));
		}

		for (tc in touchObjectsModel.cursorsRemoved) 
		{
            if(mouseTouch == tc.sessionID){
                stage.onMouseUp(stage.window, tc.x, tc.y, 0);
                mouseTouch = null;
            }
            Touch.onEnd.dispatch(updateTouch(tc, touch));
            touchArray.remove(tc.sessionID);
		}
    }

    function updateTouch(cursor:TuioCursor, touch:Touch) : Touch
    {
        var stage:Stage = Lib.current.stage;
        touch.x = cursor.x;
        touch.y = cursor.y;
        touch.id = cursor.sessionID;

        return touch;
    }
}
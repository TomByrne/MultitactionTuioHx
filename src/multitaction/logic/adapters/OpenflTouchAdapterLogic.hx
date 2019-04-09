package multitaction.logic.adapters;

import lime.ui.Touch;
import openfl.Lib;
import openfl.display.Stage;
import org.swiftsuspenders.utils.DescribedType;
import multitaction.model.touch.ITouchObjectsModel;

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
        for (touchObj in touchObjectsModel.touchList) 
		{
            switch(touchObj.state)
            {
                case TouchState.START:
                    if(touchArray.length == 0){
                        mouseTouch = touchObj.id;
                        stage.onMouseDown(stage.window, touchObj.x, touchObj.y, 0);
                    }
                    Touch.onStart.dispatch(updateTouch(touchObj, touch));
                    touchArray.push(touchObj.id);

                case TouchState.MOVE:
                    if(mouseTouch == touchObj.id){
                        stage.onMouseMove(stage.window, touchObj.x, touchObj.y);
                    }
                    Touch.onMove.dispatch(updateTouch(touchObj, touch));

                case TouchState.END:
                    if(mouseTouch == touchObj.id){
                        stage.onMouseUp(stage.window, touchObj.x, touchObj.y, 0);
                        mouseTouch = null;
                    }
                    Touch.onEnd.dispatch(updateTouch(touchObj, touch));
                    touchArray.remove(touchObj.id);
            }
            
		}
    }

    function updateTouch(touchObj:TouchObject, touch:Touch) : Touch
    {
        var stage:Stage = Lib.current.stage;
        touch.x = touchObj.x;
        touch.y = touchObj.y;
        touch.id = touchObj.id;

        return touch;
    }
}
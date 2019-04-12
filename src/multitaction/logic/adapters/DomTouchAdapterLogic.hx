package multitaction.logic.adapters;

import js.Browser;
import js.html.Touch;
import js.html.TouchInit;
import js.html.TouchEvent;
import js.html.MouseEvent;
import js.html.EventTarget;
import js.html.Element;
import org.swiftsuspenders.utils.DescribedType;
import multitaction.model.touch.ITouchObjectsModel;

class DomTouchAdapterLogic implements DescribedType
{
    @inject public var touchObjectsModel:ITouchObjectsModel;

    var mouseTouchId:Null<Int>;

    public var mimicMouse:Bool = true; // Careful: Lime doesn't like this

    public function setup()
    {
        touchObjectsModel.onProcessed.add(onTouchesProcessed);
    }

    function onTouchesProcessed()
    {
        var mouseTouch:Touch = null;
        var mouseTouchType:String = null;
        var targets:Array<EventTarget> = [];
        var allTouches:Array<Touch> = [];

        var beginTouches:Array<Touch> = null;
        var moveTouches:Array<Touch> = null;
        var endTouches:Array<Touch> = null;
		for (touchObj in touchObjectsModel.touchList) 
		{
            var touch = convertTouch(touchObj);

            var touches:Array<Touch> = null;
            var mouseType:String;
            switch(touchObj.state)
            {
                case START:
                    if(beginTouches == null) beginTouches = [];
                    touches = beginTouches;
                    mouseType = 'mousedown';

                    if(mimicMouse && mouseTouchId == null) mouseTouchId = touchObj.id;
                    
                case MOVE:
                    if(moveTouches == null) moveTouches = [];
                    touches = moveTouches;
                    mouseType = 'mousemove';
                    
                case END:
                    if(endTouches == null) endTouches = [];
                    touches = endTouches;
                    mouseType = 'mouseup';
            }

            if(touchObj.id == mouseTouchId){
                mouseTouchType = mouseType;
                mouseTouch = touch;
            }//else{
                allTouches.push(touch);
                touches.push(touch);
                if(targets.indexOf(touch.target) == -1) targets.push(touch.target);
           // }
        }

        for(target in targets){
            if(beginTouches != null) sendTouches('touchstart', beginTouches, allTouches, target);
            if(moveTouches != null) sendTouches('touchmove', moveTouches, allTouches, target);
            if(endTouches != null) sendTouches('touchend', endTouches, allTouches, target);
        }

        if(mouseTouch != null)
        {
            sendMouse(mouseTouchType, mouseTouch.screenX, mouseTouch.screenY, mouseTouch.target);
            if(mouseTouchType == 'mouseup') mouseTouchId = null;
        }
    }

    function sendTouches(type:String, typeTouches:Array<Touch>, allTouches:Array<Touch>, target:EventTarget)
    {
        var touchEvent = new TouchEvent(type, {
            cancelable: true,
            bubbles: true,
            touches: allTouches,
            targetTouches: typeTouches,
            changedTouches: typeTouches,
        });
        target.dispatchEvent(touchEvent);
    }

    function sendMouse(type:String, x:Int, y:Int, target:EventTarget)
    {
        var touchEvent = new MouseEvent(type, {
            cancelable: true,
            bubbles: true,
            clientX: x,
            clientY: y,
            screenX: x,
            screenY: y,
        });
        target.dispatchEvent(touchEvent);
    }

    function convertTouch(cursor:TouchObject) : Touch
    {
        var x = Math.round(cursor.x);
        var y = Math.round(cursor.y);
        var element = Browser.document.elementFromPoint(x, y);
        if(element == null) element = Browser.document.body;

        var touchInit:TouchInit = {
            identifier: cursor.id,
            clientX: x,
            clientY: y,
            screenX: x,
            screenY: y,
            pageX: x,
            pageY: y,
            radiusX: 2.5,
            radiusY: 2.5,
            target: element,
            rotationAngle: 10,
            force: 0.5,
        };

        return new Touch(touchInit);
    }
}
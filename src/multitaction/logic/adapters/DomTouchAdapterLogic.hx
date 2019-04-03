package multitaction.logic.adapters;

import js.Browser;
import js.html.Touch;
import js.html.TouchEvent;
import js.html.MouseEvent;
import js.html.EventTarget;
import js.html.Element;
import org.swiftsuspenders.utils.DescribedType;
import multitaction.model.touch.ITouchObjectsModel;
import org.tuio.TuioCursor;

@:access(openfl.display.Stage)
class DomTouchAdapterLogic implements DescribedType
{
    @inject public var touchObjectsModel:ITouchObjectsModel;

    var mouseTouchId:Null<Int>;

    public var mimicMouse:Bool = false; // Careful: Lime doesn't like this

    public function setup()
    {
        touchObjectsModel.onProcessed.add(onTouchesProcessed);
    }

    function onTouchesProcessed()
    {
        var mouseTouch:Touch = null;
        var mouseTouchType:String = null;
        var targets:Array<EventTarget> = [];
        var touches:Array<Touch> = [];
        var beginTouches:Array<Touch> = null;
        for (tc in touchObjectsModel.cursorsAdded) 
		{
            var touch = convertTouch(tc);

            if(mimicMouse && mouseTouchId == null) mouseTouchId = tc.sessionID;
            if(tc.sessionID == mouseTouchId){
                mouseTouchType = 'mousedown';
                mouseTouch = touch;
            }else{
                touches.push(touch);
                if(beginTouches == null) beginTouches = [touch];
                else beginTouches.push(touch);
                if(targets.indexOf(touch.target) == -1) targets.push(touch.target);
            }
        }

        var moveTouches:Array<Touch> = null;
		for (tc in touchObjectsModel.cursorsUpdated) 
		{
            var touch = convertTouch(tc);

            if(tc.sessionID == mouseTouchId){
                mouseTouchType = 'mousemove';
                mouseTouch = touch;
            }else{
                touches.push(touch);
                if(moveTouches == null) moveTouches = [touch];
                else moveTouches.push(touch);
                if(targets.indexOf(touch.target) == -1) targets.push(touch.target);
            }
        }

        var endTouches:Array<Touch> = null;
		for (tc in touchObjectsModel.cursorsRemoved) 
		{
            var touch = convertTouch(tc);

            if(tc.sessionID == mouseTouchId){
                mouseTouchType = 'mouseup';
                mouseTouch = touch;
            }else{
                touches.push(touch);
                if(endTouches == null) endTouches = [touch];
                else endTouches.push(touch);
                if(targets.indexOf(touch.target) == -1) targets.push(touch.target);
            }
        }

        for(target in targets){
            if(beginTouches != null) sendTouches('touchstart', beginTouches, touches, target);
            if(moveTouches != null) sendTouches('touchmove', moveTouches, touches, target);
            if(endTouches != null) sendTouches('touchend', endTouches, touches, target);
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

    function convertTouch(cursor:TuioCursor) : Touch
    {
        var window = Browser.window;
        var x = Math.round(cursor.x * window.innerWidth);
        var y = Math.round(cursor.y * window.innerHeight);
        var element = Browser.document.elementFromPoint(x, y);
        return new Touch({
            identifier: cursor.sessionID,
            target: element,
            clientX: x,
            clientY: y,
            screenX: x,
            screenY: y,
            pageX: x,
            pageY: y,
            radiusX: 2.5,
            radiusY: 2.5,
            rotationAngle: 10,
            force: 0.5,
        });
    }
}
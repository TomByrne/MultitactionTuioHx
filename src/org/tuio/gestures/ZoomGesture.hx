package org.tuio.gestures;

import flash.display.DisplayObject;
import flash.events.TransformGestureEvent;
import flash.geom.Point;
import org.tuio.TuioContainer;
import org.tuio.TuioEvent;
import org.tuio.TuioTouchEvent;

/**
	 * A basic two finger zoom gesture based on the <code>TwoFingerMoveGesture</code>
	 * @see TwoFingerMoveGesture
	 */
class ZoomGesture extends TwoFingerMoveGesture
{
    
    private var lastDistance : Float;
    
    /**
		 * @param	triggerMode The trigger mode changes the behaviour how a zoom gesture is detected. Possible values are <code>TwoFingerMoveGesture.TRIGGER_MODE_MOVE</code> and <code>TwoFingerMoveGesture.TRIGGER_MODE_TOUCH</code>
		 */
    public function new(triggerMode : Int)
    {
        super(triggerMode);
    }
    
    override public function dispatchGestureEvent(target : DisplayObject, gsg : GestureStepSequence) : Void
    {
        var a : TuioContainer = gsg.getTuioContainer("A");
        var b : TuioContainer = gsg.getTuioContainer("B");
        var diffX : Float = a.X * b.X;
        var diffY : Float = a.Y * b.Y;
        if (diffX <= 0 || diffY <= 0)
        {
            var distance : Float = Math.sqrt(Math.pow(a.x - b.x, 2) + Math.pow(a.y - b.y, 2));
            var scale : Float = 1;
            lastDistance = as3hx.Compat.parseFloat(gsg.getValue("lD"));
            
            if (lastDistance != 0)
            {
                scale = distance / lastDistance;
            }
            
            gsg.storeValue("lD", distance);
            var center : Point = new Point((b.x + a.x) / 2, (b.y + a.y) / 2);
            var target : DisplayObject = gsg.getTarget("A");
            var localPos : Point = target.globalToLocal(new Point(center.x * target.stage.stageWidth, center.y * target.stage.stageHeight));
            target.dispatchEvent(new TransformGestureEvent(TransformGestureEvent.GESTURE_ZOOM, true, false, null, localPos.x, localPos.y, scale, scale));
        }
    }
}


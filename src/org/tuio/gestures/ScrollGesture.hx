package org.tuio.gestures;

import flash.display.DisplayObject;
import org.tuio.TuioEvent;
import org.tuio.TuioTouchEvent;

/**
	 * A basic two finger scroll gesture based on the <code>TwoFingerMoveGesture</code>
	 * @see TwoFingerMoveGesture
	 */
class ScrollGesture extends TwoFingerMoveGesture
{
    
    /**
		 * @param	triggerMode The trigger mode changes the behaviour how a scroll gesture is detected. Possible values are <code>TwoFingerMoveGesture.TRIGGER_MODE_MOVE</code> and <code>TwoFingerMoveGesture.TRIGGER_MODE_TOUCH</code>
		 */
    public function new(triggerMode : Int)
    {
        super(triggerMode);
    }
    
    override public function dispatchGestureEvent(target : DisplayObject, gsg : GestureStepSequence) : Void
    {
        var diffX : Float = gsg.getTuioContainer("A").X - gsg.getTuioContainer("B").X;
        var diffY : Float = gsg.getTuioContainer("A").Y - gsg.getTuioContainer("B").Y;
        if (diffX < 0.01 || diffY < 0.01)
        {
            trace("scroll " + Math.round(haxe.Timer.stamp() * 1000));
        }
    }
}


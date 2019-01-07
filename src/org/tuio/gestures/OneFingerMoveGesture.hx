package org.tuio.gestures;

import flash.display.DisplayObject;
import org.tuio.TuioContainer;
import org.tuio.TuioTouchEvent;

/**
	 * This is an example implementation of a one finger move gesture. 
	 * It is recommended to modify this event to fit the wanted behaviour.
	 */
class OneFingerMoveGesture extends Gesture
{
    
    public function new()
    {
        super();
        this.addStep(new GestureStep(TuioTouchEvent.TOUCH_DOWN, {
                    tuioContainerAlias : "A",
                    targetAlias : "A"
                }));
        this.addStep(new GestureStep(TuioTouchEvent.TOUCH_MOVE, {
                    die : true,
                    tuioContainerAlias : "!B",
                    targetAlias : "A"
                }));
        this.addStep(new GestureStep(TuioTouchEvent.TOUCH_UP, {
                    die : true,
                    tuioContainerAlias : "A"
                }));
        this.addStep(new GestureStep(TuioTouchEvent.TOUCH_MOVE, {
                    tuioContainerAlias : "A",
                    goto : 2
                }));
    }
    
    override public function dispatchGestureEvent(target : DisplayObject, gsg : GestureStepSequence) : Void
    {
        trace("one finger move" + Math.round(haxe.Timer.stamp() * 1000));
    }
}


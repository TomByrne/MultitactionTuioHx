package org.tuio.gestures;

import flash.display.DisplayObject;
import org.tuio.TuioContainer;
import org.tuio.TuioTouchEvent;

/**
	 * This is an example implementation of a two finger press tap gesture. 
	 * It is recommended to modify this event to fit the wanted behaviour.
	 */
class PressTapGesture extends Gesture
{
    
    public function new()
    {
        super();
        this.addStep(new GestureStep(TuioTouchEvent.TOUCH_DOWN, {
                    tuioContainerAlias : "A"
                }));
        this.addStep(new GestureStep(TuioTouchEvent.TOUCH_MOVE, {
                    tuioContainerAlias : "A",
                    die : true
                }));
        this.addStep(new GestureStep(TuioTouchEvent.TOUCH_UP, {
                    tuioContainerAlias : "A",
                    die : true
                }));
        this.addStep(new GestureStep(TuioTouchEvent.TAP, {
                    minDelay : 500,
                    goto : 2
                }));
    }
    
    override public function dispatchGestureEvent(target : DisplayObject, gsg : GestureStepSequence) : Void
    {
        trace("press tap " + Math.round(haxe.Timer.stamp() * 1000));
    }
}


package org.tuio.gestures;

import flash.display.DisplayObject;
import org.tuio.TuioContainer;
import org.tuio.TuioTouchEvent;

/**
	 * This is an example implementation of a one finger down on finger move gesture. 
	 * It is recommended to modify this event to fit the wanted behaviour.
	 */
class OneDownOneMoveGesture extends Gesture
{
    
    public function new()
    {
        super();
        this.addStep(new GestureStep(TuioTouchEvent.TOUCH_DOWN, {
                    tuioContainerAlias : "A",
                    targetAlias : "A"
                }));
        this.addStep(new GestureStep(TuioTouchEvent.TOUCH_UP, {
                    tuioContainerAlias : "A",
                    die : true
                }));
        this.addStep(new GestureStep(TuioTouchEvent.TOUCH_DOWN, {
                    tuioContainerAlias : "B"
                }));
        this.addStep(new GestureStep(TuioTouchEvent.TOUCH_MOVE, {
                    tuioContainerAlias : "A",
                    die : true
                }));
        this.addStep(new GestureStep(TuioTouchEvent.TOUCH_UP, {
                    tuioContainerAlias : "A",
                    die : true
                }));
        this.addStep(new GestureStep(TuioTouchEvent.TOUCH_UP, {
                    tuioContainerAlias : "B",
                    die : true
                }));
        this.addStep(new GestureStep(TuioTouchEvent.TOUCH_MOVE, {
                    tuioContainerAlias : "B",
                    goto : 4
                }));
    }
    
    override public function dispatchGestureEvent(target : DisplayObject, gsg : GestureStepSequence) : Void
    {
        trace("one down one move " + Math.round(haxe.Timer.stamp() * 1000));
    }
}


package org.tuio.gestures;

import flash.display.DisplayObject;
import org.tuio.TuioContainer;
import org.tuio.TuioEvent;
import org.tuio.TuioTouchEvent;

/**
	 * This is an example implementation of a three finger move gesture. 
	 * It is recommended to modify this event to fit the wanted behaviour.
	 */
class ThreeFingerMoveGesture extends Gesture
{
    
    public function new()
    {
        super();
        this.addStep(new GestureStep(TuioTouchEvent.TOUCH_MOVE, {
                    tuioContainerAlias : "A",
                    frameIDAlias : "!A"
                }));
        this.addStep(new GestureStep(TuioTouchEvent.TOUCH_MOVE, {
                    tuioContainerAlias : "B",
                    frameIDAlias : "A"
                }));
        this.addStep(new GestureStep(TuioTouchEvent.TOUCH_MOVE, {
                    tuioContainerAlias : "C",
                    frameIDAlias : "A"
                }));
        this.addStep(new GestureStep(TuioTouchEvent.TOUCH_MOVE, {
                    die : true,
                    targetAlias : "A"
                }));
        this.addStep(new GestureStep(TuioEvent.NEW_FRAME, {
                    goto : 1
                }));
    }
    
    override public function dispatchGestureEvent(target : DisplayObject, gsg : GestureStepSequence) : Void
    {
        trace("three finger move" + Math.round(haxe.Timer.stamp() * 1000));
    }
}


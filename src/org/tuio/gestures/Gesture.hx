package org.tuio.gestures;

import flash.display.DisplayObject;
import flash.events.EventDispatcher;

/**
	 * This class is thought as a base class for creating custom gestures for the <code>GestureManager</code>.
	 * To create a custom gesture you have to extend this class and overwrite <code>dispatchGestureEvent</code> function.
	 * 
	 * <p>Gestures are described by a sequence of steps. If all steps are saturated the <code>dispatchGestureEvent</code> is called.
	 * For more information on gesture steps have a look at the <code>GestureStep</code> asdoc.</p>
	 * 
	 * <p>To track the progress in the <code>GestureStepSequences</code> you can add an event listener for <code>GestureStepEvent</code> to your extension of <code>Gesture</code></p>
	 * 
	 * @see GestureStepSequence
	 * @see GestureStep
	 * 
	 * @author Immanuel Bauer
	 * 
	 */
class Gesture extends EventDispatcher
{
    public var firstStep(get, never) : GestureStep;
    public var steps(get, never) : GestureStepSequence;

    
    public static inline var SATURATED : Int = 1;
    public static inline var ALIVE : Int = 2;
    public static inline var PROGRESS : Int = 3;
    public static inline var DEAD : Int = 4;
    
    private var _steps : GestureStepSequence;
    private var init : Bool;
    
    public function new()
    {
        super();
        this._steps = new GestureStepSequence();
        this._steps.gesture = this;
    }
    
    /**
		 * Add a <code>GestureStep</code> at the end of the gesture step sequence.
		 * 
		 * @param	s The <code>GestureStep</code> to be added.
		 */
    private function addStep(s : GestureStep) : Void
    {
        this._steps.addStep(s);
    }
    
    /**
		 * Returns the first <code>GestureStep</code> of the gesture's step sequence. 
		 * 
		 * @return The first gesture step of the gesture step sequence.
		 */
    private function get_firstStep() : GestureStep
    {
        return this._steps.firstStep;
    }
    
    /**
		 * Returns a copy of the gesture's step sequence.
		 * 
		 * @return A copy of the gesture's step sequence.
		 */
    private function get_steps() : GestureStepSequence
    {
        return this._steps.copy();
    }
    
    /**
		 * Is called if the last step of the gesture's step sequence is saturated.
		 * 
		 * @param	target The target <code>InteractiveObject</code>
		 * @param	gss The <code>GestureStepSequence</code> object storing the aliases and values that have been stored according to the <code>GestureStep</code>'s definitions. 
		 */
    public function dispatchGestureEvent(target : DisplayObject, gss : GestureStepSequence) : Void
    {
        trace("dispatching");
    }
}


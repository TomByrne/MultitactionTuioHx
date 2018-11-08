package org.tuio.gestures;

import flash.events.Event;

/**
	 * This event is used for dispatching statechanges of <code>GestureSteps</code> back to their gestures. 
	 */
class GestureStepEvent extends Event
{
    public var step(get, never) : Int;
    public var group(get, never) : GestureStepSequence;

    
    public static inline var SATURATED : String = "saturated";
    public static inline var DEAD : String = "dead";
    
    private var _step : Int;
    private var _group : GestureStepSequence;
    
    private function new(type : String, step : Int, group : GestureStepSequence)
    {
        super(type, false, false);
        this._step = step;
        this._group = group;
    }
    
    /**
		 * At which step in the containing <code>GestureStepSequence</code> the statechange happened
		 */
    private function get_step() : Int
    {
        return this._step;
    }
    
    /**
		 * The <code>GestureStepSequence</code> in which the statechange happened
		 */
    private function get_group() : GestureStepSequence
    {
        return this._group;
    }
}


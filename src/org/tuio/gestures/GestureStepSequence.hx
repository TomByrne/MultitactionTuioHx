package org.tuio.gestures;

import flash.display.DisplayObject;
import org.tuio.TuioContainer;

/**
	 * This class is the heart of the <code>GestureManager</code>'s gesture system and handles the state of the multiple instances of a gesture.
	 * <p>The <code>GestureStepSequence</code> stores a sequence of <code>GestureStep</code>s that determine the events needed
	 * until a certain <code>GestureEvent</code> may be dispatched.</p>
	 * 
	 * <p>This class also provides the means to share targets, <code>TuioContainer</code>s, Tuio frameIDs and custom values between
	 * the steps and with the final dispatching of the <code>GestureEvent</code>.</p>
	 * 
	 */
class GestureStepSequence
{
    public var firstStep(get, never) : GestureStep;
    public var gesture(get, set) : Gesture;
    public var active(get, never) : Bool;

    
    private var steps : Array<Dynamic>;
    private var stepPosition : Int;
    private var targetAliasMap : Dynamic;
    private var tuioContainerAliasMap : Dynamic;
    private var frameIDAliasMap : Dynamic;
    private var values : Dynamic;
    private var _gesture : Gesture;
    private var _active : Bool;
    
    private static var recycleBin : Array<GestureStepSequence> = new Array<GestureStepSequence>();
    
    public function new()
    {
        init();
    }
    
    /**
		 * Helper function for the constructor and getInstance.
		 */
    private function init() : Void
    {
        this.steps = new Array<Dynamic>();
        this.targetAliasMap = { };
        this.tuioContainerAliasMap = { };
        this.frameIDAliasMap = { };
        this.values = { };
        this.stepPosition = 0;
        this._active = true;
    }
    
    /**
		 * @return An instance of <code>GestureStepSequence</code> leveraging object recycling.
		 */
    public function getInstance() : GestureStepSequence
    {
        if (recycleBin.length > 0)
        {
            return recycleBin.pop().recycle();
        }
        else
        {
            return new GestureStepSequence();
        }
    }
    
    /**
		 * Recycles the GestureStepSequence object by deleting the original content.
		 */
    private function recycle() : GestureStepSequence
    {
        init();
        return this;
    }
    
    /**
		 * Flags the <code>GestureStepSequence</code> and all contained <code>Gesture Steps</code> for future recycling
		 */
    @:allow(org.tuio.gestures)
    private function discard() : Void
    {
        recycleBin.push(this);
        var al : Int = steps.length;
        for (c in 0...al)
        {
            (try cast(steps[c], GestureStep) catch(e:Dynamic) null).discard();
        }
    }
    
    /**
		 * @return A copy of the first <code>GestureStep</code> in the sequence.
		 */
    private function get_firstStep() : GestureStep
    {
        var step : GestureStep;
        for (i in 0...steps.length)
        {
            step = try cast(this.steps[i], GestureStep) catch(e:Dynamic) null;
            if (!step.dies)
            {
                return step.copy();
            }
        }
        return null;
    }
    
    /**
		 * The <code>Gesture</code> the <code>GestureStepSequence</code> belongs to.
		 */
    private function get_gesture() : Gesture
    {
        return this._gesture;
    }
    
    private function set_gesture(g : Gesture) : Gesture
    {
        this._gesture = g;
        return g;
    }
    
    /**
		 * Add a step at the end of the sequence
		 * 
		 * @param	s The step to be added.
		 */
    @:allow(org.tuio.gestures)
    private function addStep(s : GestureStep) : Void
    {
        s.group = this;
        this.steps.push(s);
    }
    
    /**
		 * Returns the target that was stored under the given alias. If no target was stored yet under the given alias <code>null</code> is returned.
		 * 
		 * @param	alias The alias name of the target.
		 * @return The target stored under the given alias.
		 */
    @:allow(org.tuio.gestures)
    private function getTarget(alias : String) : DisplayObject
    {
        if (alias.charAt(0) == "!")
        {
            return null;
        }
        return try cast(this.targetAliasMap[alias], DisplayObject) catch(e:Dynamic) null;
    }
    
    /**
		 * Store a target under a given alias name. If the alias is already in use the old target will be overwritten.
		 * 
		 * @param	alias The alias name.
		 * @param	target The target to be saved.
		 */
    @:allow(org.tuio.gestures)
    private function addTarget(alias : String, target : DisplayObject) : Void
    {
        if (alias.charAt(0) == "!")
        {
            alias = alias.substr(1);
        }
        this.targetAliasMap[alias] = target;
    }
    
    /**
		 * Returns the <code>TuioContainer</code> that was stored under the given alias. If no <code>TuioContainer</code> was stored yet under the given alias <code>null</code> is returned.
		 * 
		 * @param	alias The alias name of the <code>TuioContainer</code>.
		 * @return The <code>TuioContainer</code> stored under the given alias.
		 */
    @:allow(org.tuio.gestures)
    private function getTuioContainer(alias : String) : TuioContainer
    {
        if (alias.charAt(0) == "!")
        {
            return null;
        }
        return try cast(this.tuioContainerAliasMap[alias], TuioContainer) catch(e:Dynamic) null;
    }
    
    /**
		 * Store a <code>TuioContainer</code> under a given alias name. If the alias is already in use the old <code>TuioContainer</code> will be overwritten.
		 * 
		 * @param	alias The alias name.
		 * @param	target The <code>TuioContainer</code> to be saved.
		 */
    @:allow(org.tuio.gestures)
    private function addTuioContainer(alias : String, tuioContainer : TuioContainer) : Void
    {
        if (alias.charAt(0) == "!")
        {
            alias = alias.substr(1);
        }
        this.tuioContainerAliasMap[alias] = tuioContainer;
    }
    
    /**
		 * Returns the frameID that was stored under the given alias. If no framID was stored yet under the given alias 0 is returned.
		 * 
		 * @param	alias The alias name of the frameID.
		 * @return The frameID stored under the given alias.
		 */
    @:allow(org.tuio.gestures)
    private function getFrameID(alias : String) : Int
    {
        if (alias.charAt(0) == "!")
        {
            return 0;
        }
        else
        {
            return as3hx.Compat.parseInt(this.frameIDAliasMap[alias]);
        }
    }
    
    /**
		 * Store a frameID under a given alias name. If the alias is already in use the old frameID will be overwritten.
		 * 
		 * @param	alias The alias name.
		 * @param	target The frameID to be saved.
		 */
    @:allow(org.tuio.gestures)
    private function addFrameID(alias : String, frameID : Int) : Void
    {
        if (alias.charAt(0) == "!")
        {
            alias = alias.substr(1);
        }
        this.frameIDAliasMap[alias] = frameID;
    }
    
    /**
		 * Returns the alias of a given target. If the target wasn't stored yet with <code>addTarget(...)</code>, <code>null</code> is returned.
		 * 
		 * @param	target The target you want the alias of. 
		 * @return The given target's alias.
		 */
    @:allow(org.tuio.gestures)
    private function getTargetAlias(target : DisplayObject) : String
    {
        return getKey(targetAliasMap, target);
    }
    
    /**
		 * Returns the alias of a given <code>TuioContainer</code>. If the <code>TuioContainer</code> wasn't stored yet with <code>addTuioContainer(...)</code>, <code>null</code> is returned.
		 * 
		 * @param	target The <code>TuioContainer</code> you want the alias of. 
		 * @return The given target's alias.
		 */
    @:allow(org.tuio.gestures)
    private function getTuioContainerAlias(tuioContainer : TuioContainer) : String
    {
        return getKey(tuioContainerAliasMap, tuioContainer);
    }
    
    /**
		 * Returns the alias of a given frameID. If the frameID wasn't stored yet with <code>addFrameID(...)</code>, <code>null</code> is returned.
		 * 
		 * @param	target The frameID you want the alias of. 
		 * @return The given target's alias.
		 */
    @:allow(org.tuio.gestures)
    private function getFrameIDAlias(frameID : Int) : String
    {
        return getKey(frameIDAliasMap, frameID);
    }
    
    /**
		 * This function allows you to store a custom value. This may be used to share certain values between iterations of the same <code>GestureStepSequence</code>.
		 * If the key is already in use the old value will be overwritten.
		 * 
		 * @param	key The key under which the value will be stored.
		 * @param	value The value to be stored.
		 */
    @:allow(org.tuio.gestures)
    private function storeValue(key : String, value : Dynamic) : Void
    {
        this.values[key] = value;
    }
    
    /**
		 * This function returns a custom value tha was previously stored under the given key.
		 * If no value was stored under the given key <code>null</code> is returned.
		 * 
		 * @param	key The key of the value to be retrieved.
		 * @return The stored value.
		 */
    @:allow(org.tuio.gestures)
    private function getValue(key : String) : Dynamic
    {
        return this.values[key];
    }
    
    /**
		 * Returns the key of a given value in a given associative array.
		 * 
		 * @param	a The associative array.
		 * @param	value The value of which you want the key.
		 * @return The key the value is stored under.
		 */
    private function getKey(a : Dynamic, value : Dynamic) : String
    {
        for (k in Reflect.fields(a))
        {
            if (Reflect.field(a, k) == value)
            {
                return k;
            }
        }
        return null;
    }
    
    /**
		 * Progresses the <code>GestureStepSequence</code> for one or multiple steps until a non optional one.
		 * Optional <code>GestureStep</code>s are currently only the ones that have <code>die</code> set <code>true</code>.
		 * 
		 * @param	event The events name that shall be checked against.
		 * @param	target The target <code>DisplayObject</code> of the event.
		 * @param	tuioContainer The <code>TuioContainer</code> that triggered the event.
		 * @return A value stating whether the <code>GestureStepSequence</code> progressed, is alive, is fully saturated or died. Those values are constants of <code>Gesture</code>
		 */
    public function step(event : String, target : DisplayObject, tuioContainer : TuioContainer) : Int
    {
        var step : GestureStep = try cast(this.steps[stepPosition], GestureStep) catch(e:Dynamic) null;
        var result : Int = step.step(event, target, tuioContainer);
        var dieOffset : Int = 0;
        var goto : Int;
        
        while (true)
        {
            if (result == Gesture.SATURATED && !step.dies)
            {
                stepPosition++;
                this.gesture.dispatchEvent(new GestureStepEvent(GestureStepEvent.SATURATED, stepPosition, this));
                if (stepPosition < steps.length)
                {
                    goto = step.goto;
                    if (goto > 0 && goto <= steps.length)
                    {
                        stepPosition = as3hx.Compat.parseInt(goto - 1);
                    }
                    prepareNext();
                    return Gesture.PROGRESS;
                }
                else
                {
                    goto = step.goto;
                    if (goto > 0 && goto <= steps.length)
                    {
                        stepPosition = as3hx.Compat.parseInt(goto - 1);
                        prepareNext();
                    }
                    else
                    {
                        this._active = false;
                    }
                    return Gesture.SATURATED;
                }
            }
            else if (result == Gesture.ALIVE || (result == Gesture.DEAD && (step.dies || step.optional)))
            {
                if (step.dies || step.optional)
                {
                    stepPosition++;
                    dieOffset++;
                    step = try cast(this.steps[stepPosition], GestureStep) catch(e:Dynamic) null;
                    result = step.step(event, target, tuioContainer);
                }
                else
                {
                    stepPosition -= dieOffset;
                    return Gesture.ALIVE;
                }
            }
            else
            {
                this.gesture.dispatchEvent(new GestureStepEvent(GestureStepEvent.DEAD, stepPosition + 1, this));
                this._active = false;
                return Gesture.DEAD;
            }
        }
        
        return Gesture.ALIVE;
    }
    
    /**
		 * Prepares the next step.
		 * Starts the timeout counter.
		 */
    private function prepareNext() : Void
    {
        var o : Int = 0;
        var nextStep : GestureStep = this.steps[stepPosition];
        var stepLength : Int = as3hx.Compat.parseInt(this.steps.length - 1);
        nextStep.prepare();
        while (nextStep.dies && (stepPosition + o) < stepLength)
        {
            o++;
            nextStep = this.steps[stepPosition + o];
            nextStep.prepare();
        }
    }
    
    /**
		 * @return A copy of the basic <code>GestureStepSequence</code> but not its current state and stored values.
		 */
    public function copy() : GestureStepSequence
    {
        var out : GestureStepSequence = getInstance();
        out.gesture = this.gesture;
        var al : Int = steps.length;
        for (c in 0...al)
        {
            out.addStep((try cast(steps[c], GestureStep) catch(e:Dynamic) null).copy());
        }
        return out;
    }
    
    /**
		 * <code>true</code> if still alive/active, otherwise <code>false</code>.
		 */
    private function get_active() : Bool
    {
        return this._active;
    }
}


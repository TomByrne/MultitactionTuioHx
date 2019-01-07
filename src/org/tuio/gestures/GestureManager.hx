package org.tuio.gestures;

import flash.errors.Error;
import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.display.Stage;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.geom.Point;
import org.tuio.*;
import org.tuio.debug.ITuioDebugBlob;
import org.tuio.debug.ITuioDebugCursor;
import org.tuio.debug.ITuioDebugObject;
import org.tuio.debug.ITuioDebugTextSprite;

/**
	 * The GestureManager listens to the TuioManager and triggers
	 * gesture events into Flash's event flow according to the called callback functions
	 * and registered Gestures.
	 * 
	 * @author Immanuel Bauer
	 */
class GestureManager extends EventDispatcher
{
    
    /**Sets the method how to discover the TuioTouchEvent's target object. The default is TOUCH_TARGET_DISCOVERY_MOUSE_ENABLED.*/
    public var touchTargetDiscoveryMode : Int = TOUCH_TARGET_DISCOVERY_MOUSE_ENABLED;
    
    //the possible touch target discovery modes.
    /**The events will be triggered on the top object under the tracked point. Fastest method. Works for DisplayObject and subclasses.*/
    public static inline var TOUCH_TARGET_DISCOVERY_NONE : Float = 0;
    /**The InteractiveObject's mouseEnabled parameter is used to determine whether a TuioTouchEvent is triggered on an InteractiveObject under the tracked point. Works only for InteractiveObject and subclasses.*/
    public static inline var TOUCH_TARGET_DISCOVERY_MOUSE_ENABLED : Float = 1;
    /**An ignore list is used to determin whether a TuioTouchEvent is triggered on an InteractiveObject under the tracked point. Works for DisplayObject and subclasses.*/
    public static inline var TOUCH_TARGET_DISCOVERY_IGNORELIST : Float = 2;
    
    private var _tuioManager : TuioManager;
    
    private var ignoreList : Array<Dynamic>;
    
    @:allow(org.tuio.gestures)
    private var gestures : Array<Dynamic>;
    private var activeGestures : Array<Dynamic>;
    
    private static var inst : GestureManager;
    private static var allowInst : Bool = false;
    
    @:allow(org.tuio.gestures)
    private var stage : Stage;
    
    /**
		 * The <code>GestureManager</code> must not be instanciated directly. Use <code>GestureManager.init(...)</code> or <code>GestureManager.getInstance()</code> instead.
		 * Creates a new GestureManager instance.
		 * 
		 * @param	stage The Stage object of the Flashmovie.
		 * @param	tuioClient A TuioClient instance that receives Tuio tracking data from a tracker.
		 */
    public function new()
    {
        super();
        if (allowInst)
        {
            this._tuioManager = TuioManager.getInstance();
            this._tuioManager.addEventListener(TuioEvent.ADD, handleTuioEvent);
            this._tuioManager.addEventListener(TuioEvent.ADD_CURSOR, handleTuioEvent);
            this._tuioManager.addEventListener(TuioEvent.ADD_OBJECT, handleTuioEvent);
            this._tuioManager.addEventListener(TuioEvent.ADD_BLOB, handleTuioEvent);
            this._tuioManager.addEventListener(TuioEvent.UPDATE, handleTuioEvent);
            this._tuioManager.addEventListener(TuioEvent.UPDATE_CURSOR, handleTuioEvent);
            this._tuioManager.addEventListener(TuioEvent.UPDATE_OBJECT, handleTuioEvent);
            this._tuioManager.addEventListener(TuioEvent.UPDATE_BLOB, handleTuioEvent);
            this._tuioManager.addEventListener(TuioEvent.REMOVE, handleTuioEvent);
            this._tuioManager.addEventListener(TuioEvent.REMOVE_CURSOR, handleTuioEvent);
            this._tuioManager.addEventListener(TuioEvent.REMOVE_OBJECT, handleTuioEvent);
            this._tuioManager.addEventListener(TuioEvent.REMOVE_BLOB, handleTuioEvent);
            this._tuioManager.addEventListener(TuioEvent.NEW_FRAME, handleTuioEvent);
            this._tuioManager.addEventListener(TuioTouchEvent.TAP, handleTouchEvent);
            this._tuioManager.addEventListener(TuioTouchEvent.DOUBLE_TAP, handleTouchEvent);
            this._tuioManager.addEventListener(TuioTouchEvent.HOLD, handleTouchEvent);
            this._tuioManager.addEventListener(TuioTouchEvent.ROLL_OVER, handleTouchEvent);
            this._tuioManager.addEventListener(TuioTouchEvent.ROLL_OUT, handleTouchEvent);
            this._tuioManager.addEventListener(TuioTouchEvent.TOUCH_DOWN, handleTouchEvent);
            this._tuioManager.addEventListener(TuioTouchEvent.TOUCH_UP, handleTouchEvent);
            this._tuioManager.addEventListener(TuioTouchEvent.TOUCH_MOVE, handleTouchEvent);
            this._tuioManager.addEventListener(TuioTouchEvent.TOUCH_OUT, handleTouchEvent);
            this._tuioManager.addEventListener(TuioTouchEvent.TOUCH_OVER, handleTouchEvent);
            this.ignoreList = new Array<Dynamic>();
            this.gestures = new Array<Dynamic>();
            this.activeGestures = new Array<Dynamic>();
        }
        else
        {
            throw new Error("Error: Instantiation failed: Use GestureManager.getInstance() instead of new.");
        }
    }
    
    /**
		 * Intializes the <code>GesturManager</code> with the given TuioClient. 
		 * If you have already initialized a <code>TuioManager</code> the given <code>stage</code> and <code>tuioClient</code> will be discarded and the ones specified for the <code>TuioManager</code> will be used instead.
		 * This behaviour is a result of the <code>GestureManager</code> using the <code>TuioManager</code>'s events  
		 * 
		 * @param	stage
		 * @param	tuioClient
		 * @return
		 */
    public static function init(stage : Stage) : GestureManager
    {
        if (inst == null)
        {
            if (TuioManager.getInstance())
            {
                allowInst = true;
                inst = new GestureManager();
                inst.stage = stage;
                allowInst = false;
            }
        }
        
        return inst;
    }
    
    /**
		 * Returns the instance of the <code>GestureManager</code>. 
		 * Make sure you have called <code>GestureManager.init(...)</code> before calling this function.
		 * Otherwise an Error will be thrown.
		 * 
		 * @return The <code>GestureManager</code> insance.
		 */
    public static function getInstance() : GestureManager
    {
        if (inst == null)
        {
            throw new Error("Please initialize with method GestureManager.init(...) first!");
        }
        return inst;
    }
    
    /**
		 * Use this function to add a predefined or custom gesture that shall be checked for.
		 * 
		 * @param	gesture A custom or predefined gesture.
		 */
    public static function addGesture(gesture : Gesture) : Void
    {
        if (inst == null)
        {
            throw new Error("Please initialize with method GestureManager.init(...) first!");
        }
        else
        {
            inst.gestures.push(gesture);
        }
    }
    
    /**
		 * Checks if the firstStep of any added <code>Gesture</code> matches the given event.
		 * 
		 * @param	event The event name that that shall be checked against.
		 * @param	target The events target <code>DisplayObject</code>
		 * @param	tuioContainer The tuioContainer that caused the event.
		 */
    private function initGestures(event : String, target : DisplayObject, tuioContainer : TuioContainer) : Void
    {
        var gsg : GestureStepSequence;
        for (g in gestures)
        {
            if (g.firstStep.event == event)
            {
                gsg = g.steps;
                gsg.step(event, target, tuioContainer);
                this.activeGestures.push(gsg);
            }
        }
    }
    
    /**
		 * Progresses all active <code>GestureStepSequences</code> and discards them if a <code>GestureStep</code> fails/dies.
		 * 
		 * @param	event The event name that that shall be checked against.
		 * @param	target The events target <code>DisplayObject</code>
		 * @param	tuioContainer The tuioContainer that caused the event.
		 * @return <code>true</code> if an active <code>GestureStepSequence</code> progressed.
		 */
    private function progressGestures(event : String, target : DisplayObject, tuioContainer : TuioContainer) : Bool
    {
        var temp : Array<Dynamic> = new Array<Dynamic>();
        var l : Int = this.activeGestures.length;
        var used : Bool = false;
        
        for (c in 0...l)
        {
            var m : GestureStepSequence = this.activeGestures.pop();
            var r : Int = m.step(event, target, tuioContainer);
            if (r == Gesture.PROGRESS)
            {
                temp.push(m);
                used = true;
            }
            else if (r == Gesture.ALIVE)
            {
                temp.push(m);
            }
            else if (r == Gesture.SATURATED)
            {
                used = true;
                m.gesture.dispatchGestureEvent(target, m);
                if (m.active)
                {
                    temp.push(m);
                }
                else
                {
                    m.discard();
                }
            }
            else
            {
                m.discard();
            }
            m = null;
        }
        this.activeGestures = temp;
        return used;
    }
    
    /**
		 * Handles an Tuio <code>TuioTouchEvent</code>
		 * 
		 * @param	touchEvent The <code>TuioTouchEvent</code> to be handled
		 */
    private function handleTouchEvent(touchEvent : TuioTouchEvent) : Void
    {
        if (!progressGestures(touchEvent.type, try cast(touchEvent.relatedObject, DisplayObject) catch(e:Dynamic) null, touchEvent.tuioContainer))
        {
            initGestures(touchEvent.type, try cast(touchEvent.relatedObject, DisplayObject) catch(e:Dynamic) null, touchEvent.tuioContainer);
        }
    }
    
    /**
		 * Handles an <code>TuioEvent</code>
		 * 
		 * @param	touchEvent The <code>TuioEvent</code> to be handled
		 */
    private function handleTuioEvent(tuioEvent : TuioEvent) : Void
    {
        var tuioContainer : TuioContainer = tuioEvent.tuioContainer;
        var stagePos : Point = new Point(0, 0);
        var target : DisplayObject = stage;
        if (tuioContainer != null)
        {
            stagePos = new Point(stage.stageWidth * tuioContainer.x, stage.stageHeight * tuioContainer.y);
            target = getTopDisplayObjectUnderPoint(stagePos);
        }
        
        if (!progressGestures(tuioEvent.type, target, tuioContainer))
        {
            initGestures(tuioEvent.type, target, tuioContainer);
        }
    }
    
    private function getTopDisplayObjectUnderPoint(point : Point) : DisplayObject
    {
        var targets : Array<Dynamic> = stage.getObjectsUnderPoint(point);
        var item : DisplayObject = ((targets.length > 0)) ? targets[targets.length - 1] : stage;
        
        if (this.touchTargetDiscoveryMode == TOUCH_TARGET_DISCOVERY_MOUSE_ENABLED)
        {
            while (targets.length > 0)
            {
                item = try cast(targets.pop(), DisplayObject) catch(e:Dynamic) null;
                //ignore debug cursor/object/blob and send object under debug cursor/object/blob
                if ((Std.is(item, ITuioDebugCursor) || Std.is(item, ITuioDebugBlob) || Std.is(item, ITuioDebugObject) || Std.is(item, ITuioDebugTextSprite)) && targets.length > 0)
                {
                    continue;
                }
                if (item.parent != null && !(Std.is(item, InteractiveObject)))
                {
                    item = item.parent;
                }
                if (Std.is(item, InteractiveObject))
                {
                    if ((try cast(item, InteractiveObject) catch(e:Dynamic) null).mouseEnabled)
                    {
                        return item;
                    }
                }
            }
            item = stage;
        }
        else if (this.touchTargetDiscoveryMode == TOUCH_TARGET_DISCOVERY_IGNORELIST)
        {
            while (targets.length > 0)
            {
                item = targets.pop();
                //ignore debug cursor/object/blob and send object under debug cursor/object/blob
                if ((Std.is(item, ITuioDebugCursor) || Std.is(item, ITuioDebugBlob) || Std.is(item, ITuioDebugObject) || Std.is(item, ITuioDebugTextSprite)) && targets.length > 0)
                {
                    continue;
                }
                if (!bubbleListCheck(item))
                {
                    return item;
                }
            }
            item = stage;
        }
        
        return item;
    }
    
    /**
		 * Checks if a DisplayObject or its parents are in the ignoreList.
		 * 
		 * @param	obj The DisplayObject that has to be checked.
		 * @return Is true if the DisplayObject or one of its parents is in the ignoreList.
		 */
    private function bubbleListCheck(obj : DisplayObject) : Bool
    {
        if (Lambda.indexOf(ignoreList, obj) < 0)
        {
            if (obj.parent != null)
            {
                return bubbleListCheck(obj.parent);
            }
            else
            {
                return false;
            }
        }
        else
        {
            return true;
        }
    }
    
    /**
		 * Adds the given DisplayObject to an internal list of DisplayObjects that won't receive TuioTouchEvents.
		 * If a DisplayobjectContainer is added to the list its children can still receive TuioTouchEvents.
		 * The touchTargetDiscoveryMode is automatically set to TOUCH_TARGET_DISCOVERY_IGNORELIST.
		 * 
		 * @param	item The DisplayObject that should be ignored by TuioTouchEvents.
		 */
    public function addToIgnoreList(item : DisplayObject) : Void
    {
        this.touchTargetDiscoveryMode = TOUCH_TARGET_DISCOVERY_IGNORELIST;
        if (Lambda.indexOf(ignoreList, item) < 0)
        {
            ignoreList.push(item);
        }
    }
    
    /**
		 * Removes the given DisplayObject from the internal list of DisplayObjects that won't receive TuioTouchEvents.
		 * 
		 * @param	item The DisplayObject that should be ignored by TuioTouchEvents.
		 */
    public function removeFromIgnoreList(item : DisplayObject) : Void
    {
        var tmpList : Array<Dynamic> = new Array<Dynamic>();
        var listItem : Dynamic;
        while (ignoreList.length > 0)
        {
            listItem = ignoreList.pop();
            if (listItem != item)
            {
                tmpList.push(listItem);
            }
        }
        ignoreList = tmpList.copy();
    }
}


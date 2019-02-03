/**
 * Legacy TouchEvent class.
 */package org.tuio.legacy;

import flash.display.DisplayObject;
import flash.events.Event;

/**
	 * Legacy TouchEvent class from Touchlib TUIO AS3. Use only for the port of existing code to TUIO AS3.
	 *  
	 * For the current Tuio event implementation see:
	 * @see org.tuio.TuioManager
	 * @see org.tuio.TuioTouchEvent
	 * @see TuioLegacyListener
	 * @see TouchEvent
	 * 
	 */
class TouchEvent extends Event
{
	public var tuioType : String;
	public var sID : Int;
	public var ID : Int;
	public var angle : Float;
	public var stageX : Float;
	public var stageY : Float;
	public var localX : Float;
	public var localY : Float;
	public var oldX : Float;
	public var oldY : Float;
	public var buttonDown : Bool;
	public var relatedObject : DisplayObject;
	public static inline var MOUSE_DOWN : String = "flash.events.TouchEvent.MOUSE_DOWN";
	public static inline var MOUSE_MOVE : String = "flash.events.TouchEvent.MOUSE_MOVE";
	public static inline var MOUSE_UP : String = "flash.events.TouchEvent.MOUSE_UP";
	public static inline var MOUSE_OVER : String = "flash.events.TouchEvent.MOUSE_OVER";
	public static inline var MOUSE_OUT : String = "flash.events.TouchEvent.MOUSE_OUT";
	public static inline var CLICK : String = "flash.events.TouchEvent.CLICK";
	public static inline var DOUBLE_CLICK : String = "flash.events.TouchEvent.DOUBLE_CLICK";
	// Dynamic HOLD times [addEventListner(TouchEvent.HOLD, function, setHoldTime)] 
	public static inline var LONG_PRESS : String = "flash.events.TouchEvent.HOLD";
	public static inline var HOLD : String = "flash.events.TouchEvent.HOLD";

	public function new(type : String, bubbles : Bool = false, cancelable : Bool = false, stageX : Float = 0, stageY : Float = 0, localX : Float = 0, localY : Float = 0, oldX : Float = 0, oldY : Float = 0, relatedObject : DisplayObject = null, ctrlKey : Bool = false, altKey : Bool = false, shiftKey : Bool = false, buttonDown : Bool = false, delta : Int = 0, tuioType : String = "2Dcur", ID : Int = -1, sID : Int = -1, angle : Float = 0.0)
    {
        this.tuioType = tuioType;this.sID = sID;this.ID = ID;this.angle = angle;this.stageX = stageX;this.stageY = stageY;this.localX = localX;this.localY = localY;this.oldX = oldX;this.oldY = oldY;this.buttonDown = buttonDown;this.relatedObject = relatedObject;super(type, bubbles, cancelable);
    }
}
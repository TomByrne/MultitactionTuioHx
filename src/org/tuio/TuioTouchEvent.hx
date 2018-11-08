package org.tuio;

import flash.display.*;
import flash.events.Event;
import flash.geom.Point;

/**
	 * The <code>TuioTouchEvent</code> is the event dispatched by the <code>TuioManager</code> and behaves uch like the MouseEvent or the native TouchEvent. 
	 * 
	 * @author Immanuel Bauer
	 */
class TuioTouchEvent extends Event
{
    public var tuioContainer(get, never) : TuioContainer;
    public var localX(get, never) : Float;
    public var localY(get, never) : Float;
    public var stageX(get, never) : Float;
    public var stageY(get, never) : Float;
    public var relatedObject(get, never) : DisplayObject;

    
    /**Triggered on a touch.*/
    public static inline var TOUCH_DOWN : String = "org.tuio.TuioTouchEvent.TOUCH_DOWN";
    /**Triggered if a touch is released.*/
    public static inline var TOUCH_UP : String = "org.tuio.TuioTouchEvent.TOUCH_UP";
    /**Triggered if a touch is moved.*/
    public static inline var TOUCH_MOVE : String = "org.tuio.TuioTouchEvent.TOUCH_MOVE";
    /**Triggered if a touch is moved out of a DisplayObject.*/
    public static inline var TOUCH_OUT : String = "org.tuio.TuioTouchEvent.TOUCH_OUT";
    /**Triggered if a touch is moved over a DisplayObject.*/
    public static inline var TOUCH_OVER : String = "org.tuio.TuioTouchEvent.TOUCH_OVER";
    /**Triggered if a touch is moved out of a DisplayObject.*/
    public static inline var ROLL_OUT : String = "org.tuio.TuioTouchEvent.ROLL_OUT";
    /**Triggered if a touch is moved over a DisplayObject.*/
    public static inline var ROLL_OVER : String = "org.tuio.TuioTouchEvent.ROLL_OVER";
    
    /**Triggered if a TOUCH_DOWN and TOUCH_UP occurred over the same DisplayObject.*/
    public static inline var TAP : String = "org.tuio.TuioTouchEvent.TAP";
    /**Triggered if two subsequent TAPs occurred over the same DisplayObject.*/
    public static inline var DOUBLE_TAP : String = "org.tuio.TuioTouchEvent.DOUBLE_TAP";
    
    /**Triggered if a touch is held for a certain time over the same DisplayObject without movement.*/
    public static inline var HOLD : String = "org.tuio.TuioTouchEvent.HOLD";
    
    private var _tuioContainer : TuioContainer;
    
    private var _localX : Float = Math.NaN;
    private var _localY : Float = Math.NaN;
    private var _stageX : Float = Math.NaN;
    private var _stageY : Float = Math.NaN;
    private var _relatedObject : DisplayObject;
    
    public function new(type : String, bubbles : Bool = true, cancelable : Bool = false, localX : Float = Math.NaN, localY : Float = Math.NaN, stageX : Float = Math.NaN, stageY : Float = Math.NaN, relatedObject : DisplayObject = null, tuioContainer : TuioContainer = null)
    {
        super(type, bubbles, cancelable);
        this._tuioContainer = tuioContainer;
        
        this._relatedObject = relatedObject;
        
        this._stageX = stageX;
        this._stageY = stageY;
        
        this._localX = localX;
        this._localY = localY;
    }
    
    /**
		 * The <code>TuioContainer</code> related to this <code>TuioTouchEvent</code> containing the raw TUIO information.
		 * @see TuioContainer
		 * @see TuioCursor
		 */
    private function get_tuioContainer() : TuioContainer
    {
        return this._tuioContainer;
    }
    
    /**
		 * The touch's position on the x-axis relative to the touchTarget's origin.
		 */
    private function get_localX() : Float
    {
        return this._localX;
    }
    
    /**
		 * The touch's position on the y-axis relative to the touchTarget's origin.
		 */
    private function get_localY() : Float
    {
        return this._localY;
    }
    
    /**
		 * The touch's position on the x-axis relative to the stage's origin.
		 */
    private function get_stageX() : Float
    {
        return this._stageX;
    }
    
    /**
		 * The touch's position on the y-axis relative to the stage's origin.
		 */
    private function get_stageY() : Float
    {
        return this._stageY;
    }
    
    /**
		 * The related <code>DisplayObject</code>
		 */
    private function get_relatedObject() : DisplayObject
    {
        return this._relatedObject;
    }
}


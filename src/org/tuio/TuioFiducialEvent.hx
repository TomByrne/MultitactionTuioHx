package org.tuio;

import flash.display.DisplayObject;
import flash.events.Event;
import mx.controls.Button;

/**
	 * <code>TuipFiducialEvent</code> is a high-level implementation of <code>TuioEvent</code> that
	 * offers only information that is connected to TuioObjects. It is the fiducial analogon to
	 * <code>TuioTouchEvent</code>. 
	 * 
	 * @author Johannes Luderschmidt
	 * 
	 */
class TuioFiducialEvent extends Event
{
    public var fiducialId(get, set) : Float;
    public var x(get, set) : Float;
    public var y(get, set) : Float;
    public var rotation(get, set) : Float;
    public var localX(get, set) : Float;
    public var localY(get, set) : Float;
    public var tuioObject(get, set) : TuioObject;

    public static inline var MOVE : String = "FIDUCIAL_MOVE";
    public static inline var ROTATE : String = "FIDUCIAL_ROTATE";
    public static inline var ADD : String = "FIDUCIAL_ADD";
    public static inline var OVER : String = "FIDUCIAL_OVER";
    public static inline var OUT : String = "FIDUCIAL_OUT";
    public static inline var REMOVED : String = "FIDUCIAL_REMOVED";
    public static inline var NOTIFY_REMOVED : String = "FIDUCIAL_NOTIFY_REMOVED";
    public static inline var NOTIFY_RETURNED : String = "FIDUCIAL_NOTIFY_RETURNED";
    
    private var _fiducialId : Float;
    private var _x : Float;
    private var _y : Float;
    private var _localX : Float;
    private var _localY : Float;
    
    private var _rotation : Float;
    private var _tuioObject : TuioObject;
    
    public function new(type : String, localX : Float, localY : Float, stageX : Float, stageY : Float, relatedObject : DisplayObject, tuioObject : TuioObject)
    {
        super(type, true, false);
        this.fiducialId = tuioObject.classID;
        this.localX = localX;
        this.localY = localY;
        this.x = stageX;
        this.y = stageY;
        this.rotation = tuioObject.m;
        this.tuioObject = tuioObject;
    }
    
    /**
		 * id of the fiducial pattern (NOT session id).
		 *  
		 * @return id of the fiducial pattern.
		 * 
		 */
    private function get_fiducialId() : Float
    {
        return _fiducialId;
    }
    private function set_fiducialId(fiducialId : Float) : Float
    {
        _fiducialId = fiducialId;
        return fiducialId;
    }
    
    
    /**
		 * Indicates the stage x coordinate of the Fiducial.
		 *  
		 * @return stage x coordinate
		 * 
		 */
    private function get_x() : Float
    {
        return _x;
    }
    private function set_x(x : Float) : Float
    {
        _x = x;
        return x;
    }
    
    /**
		 * Indicates the stage y coordinate of the Fiducial.
		 *  
		 * @return stage y coordinate
		 * 
		 */
    private function get_y() : Float
    {
        return _y;
    }
    private function set_y(y : Float) : Float
    {
        _y = y;
        return y;
    }
    
    /**
		 * The fiducial's rotation in degrees. 
		 * 
		 * @return fiducial rotation in degree
		 */
    private function get_rotation() : Float
    {
        return _rotation;
    }
    private function set_rotation(rotation : Float) : Float
    {
        _rotation = rotation;
        return rotation;
    }
    
    /**
		 * Offset of the x position of the fiducial's position in relation to the upper left border of the DisplayObject.
		 * 
		 * @return 
		 * 
		 */
    private function get_localX() : Float
    {
        return _localX;
    }
    private function set_localX(localX : Float) : Float
    {
        _localX = localX;
        return localX;
    }
    
    /**
		 * Offset of the y position of the fiducial's position in relation to the upper left border of the DisplayObject.
		 *  
		 * @return 
		 * 
		 */
    private function get_localY() : Float
    {
        return _localY;
    }
    private function set_localY(localY : Float) : Float
    {
        _localY = localY;
        return localY;
    }
    
    /**
		 * The raw TuioObject that has been received from the Tuio producer. Session id,
		 * movement acceleration, rotation acceleration etc. can only be retrieved from this
		 * TuioObject and not from the event itself.
		 * 
		 * @return raw TuioObject with all fiducial data. 
		 * 
		 */
    private function get_tuioObject() : TuioObject
    {
        return _tuioObject;
    }
    private function set_tuioObject(tuioObject : TuioObject) : TuioObject
    {
        _tuioObject = tuioObject;
        return tuioObject;
    }
}

package org.tuio.legacy;

import flash.events.Event;

/**
	 * <p>Legacy PropEvent from fiducialtuioas3 (http://code.google.com/p/fiducialtuioas3/).</p>
	 * 
	 * For a newer version of a fiducial callback implementation see: 
	 * @see org.tuio.fiducial.TuioFiducialDispatcher
	 * @see org.tuio.fiducial.ITuioFiducialReceiver
	 * 
	 * 
	 * @author Frederic Friess
	 * 
	 */
class PropEvent extends Event
{
    //public var score:int;
    
    
    public static inline var SET_PROP : String = "set_prop";
    public static inline var ALIVE_PROP : String = "alive_prop";
    
    public static inline var ADD_PROP : String = "add_prop";
    //public static const CHANGE_PROP:String = "change_prop";
    public static inline var REMOVE_PROP : String = "remove_prop";
    
    public static inline var MOVE_PROP : String = "move_prop";
    public static inline var ROTATE_PROP : String = "rotate_prop";
    public static inline var VELOCETY_MOVE_PROP : String = "velocety_move_prop";
    public static inline var VELOCETY_ROTATE_PROP : String = "velocety_rotate_prop";
    public static inline var ACCEL_MOVE_PROP : String = "velocety_move_prop";
    public static inline var ACCEL_ROTATE_PROP : String = "velocety_rotate_prop";
    
    public var s_id : Float;
    public var f_id : Float;
    public var xpos : Float;
    public var ypos : Float;
    public var angle : Float;
    public var xspeed : Float;
    public var yspeed : Float;
    public var rspeed : Float;
    public var maccel : Float;
    public var raccel : Float;
    public var speed : Float;
    
    public function new(type : String,
            sID : Float = -1, id : Float = -1, x : Float = 0, y : Float = 0, a : Float = 0,
            X : Float = 0, Y : Float = 0, A : Float = 0, m : Float = 0, r : Float = 0, speed : Float = 0,
            bubbles : Bool = true, cancelable : Bool = true)
    {
        this.s_id = sID;
        this.f_id = id;
        this.xpos = x;
        this.ypos = y;
        this.angle = a;
        this.xspeed = X;
        this.yspeed = Y;
        this.rspeed = A;
        this.maccel = m;
        this.raccel = r;
        this.speed = speed;
        super(type, bubbles, cancelable);
    }
}

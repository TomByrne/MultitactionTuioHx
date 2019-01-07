package org.tuio.legacy;

import flash.display.Sprite;

/**
	 * Legacy PropObject from fiducialtuioas3 (http://code.google.com/p/fiducialtuioas3/).
	 * 
	 * For a newer version of a fiducial callback implementation see: 
	 * @see org.tuio.fiducial.TuioFiducialDispatcher
	 * @see org.tuio.fiducial.ITuioFiducialReceiver
	 * 
	 * @author Frederic Friess
	 * 
	 */
class PropObject extends Sprite
{
    
    public var isActiv : Bool;
    public var s_id : Float;
    public var f_id : Float;
    public var handler : PropHandleble;
    
    public function new(s_id : Float, id : Float)
    {
        super();
        //trace("create fid with id:"+id);
        this.isActiv = false;
        this.s_id = s_id;
        this.f_id = id;
    }
    
    public function set_s_ID(_s_id : Float) : Void
    {
        this.s_id = _s_id;
    }
    
    public function addPropHandler(_handler : PropHandleble) : Void
    // verknüpfung zum Handler
    {
        
        this.handler = _handler;
        this.addEventListener(PropEvent.ADD_PROP, this.handler.onAdd);
        this.addEventListener(PropEvent.REMOVE_PROP, this.handler.onRemove);
        this.addEventListener(PropEvent.MOVE_PROP, this.handler.onMove);
        this.addEventListener(PropEvent.ROTATE_PROP, this.handler.onRotate);
        this.addEventListener(PropEvent.VELOCETY_MOVE_PROP, this.handler.onMoveVelocety);
        this.addEventListener(PropEvent.VELOCETY_ROTATE_PROP, this.handler.onRotateVelocety);
        this.addEventListener(PropEvent.ACCEL_MOVE_PROP, this.handler.onMoveAccel);
        this.addEventListener(PropEvent.ACCEL_ROTATE_PROP, this.handler.onRotateAccel);
    }
    
    public function getPropHandler() : PropHandleble
    {
        return this.handler;
    }
}

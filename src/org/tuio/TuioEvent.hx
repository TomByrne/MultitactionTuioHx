package org.tuio;

import flash.events.Event;

/**
	 * The TuioEvent is an event equivalent of the ITuioListener callback functions.
	 * 
	 * @author Immanuel Bauer
	 */
class TuioEvent extends Event
{
    public var tuioContainer(get, never) : TuioContainer;

    
    /**Triggered if a new object was tracked in the tracking space.*/
    public static inline var ADD : String = "org.tuio.TuioEvent.add";
    /**Triggered if a tracked object was updated.*/
    public static inline var UPDATE : String = "org.tuio.TuioEvent.update";
    /**Triggered if a tracked object was removed from the tracking space.*/
    public static inline var REMOVE : String = "org.tuio.TuioEvent.remove";
    
    /**Triggered if a new object was tracked in the tracking space and was profiled as a TuioObject by the tracker.*/
    public static inline var ADD_OBJECT : String = "org.tuio.TuioEvent.addObject";
    /**Triggered if a new object was tracked in the tracking space and was profiled as a TuioCursor by the tracker.*/
    public static inline var ADD_CURSOR : String = "org.tuio.TuioEvent.addCursor";
    /**Triggered if a new object was tracked in the tracking space and was profiled as a TuioBlob by the tracker.*/
    public static inline var ADD_BLOB : String = "org.tuio.TuioEvent.addBlob";
    
    /**Triggered if a TuioObject was updated.*/
    public static inline var UPDATE_OBJECT : String = "org.tuio.TuioEvent.updateObject";
    /**Triggered if a TuioCursor was updated.*/
    public static inline var UPDATE_CURSOR : String = "org.tuio.TuioEvent.updateCursor";
    /**Triggered if a TuioBlob was updated.*/
    public static inline var UPDATE_BLOB : String = "org.tuio.TuioEvent.updateBlob";
    
    /**Triggered if a TuioObject was removed.*/
    public static inline var REMOVE_OBJECT : String = "org.tuio.TuioEvent.removeObject";
    /**Triggered if a TuioCursor was removed.*/
    public static inline var REMOVE_CURSOR : String = "org.tuio.TuioEvent.removeCursor";
    /**Triggered if a TuioBlob was removed.*/
    public static inline var REMOVE_BLOB : String = "org.tuio.TuioEvent.removeBlob";
    
    /**Triggere if there is a new frameID. The <code>tuioContainer</code> will be <code>null</code> */
    public static inline var NEW_FRAME : String = "org.tuio.TuioEvent.newFrame";
    
    private var _tuioContainer : TuioContainer;
    
    public function new(type : String, tuioContainer : TuioContainer)
    {
        super(type, false, false);
        this._tuioContainer = tuioContainer;
    }
    
    private function get_tuioContainer() : TuioContainer
    {
        return this._tuioContainer;
    }
}


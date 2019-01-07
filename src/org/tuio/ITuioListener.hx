package org.tuio;


/**
	 * This interface defines callback functions that will be called by the <code>TuioClient</code> if the 
	 * implementing class was added as a listener to the according <code>TuioClient</code>.
	 */
interface ITuioListener
{

    
    /**
		 * Called if a new object was tracked.
		 * @param	tuioObject The values of the received /tuio/**Dobj.
		 */
    function addTuioObject(tuioObject : TuioObject) : Void
    ;
    
    /**
		 * Called if a tracked object was updated.
		 * @param	tuioObject The values of the received /tuio/**Dobj.
		 */
    function updateTuioObject(tuioObject : TuioObject) : Void
    ;
    
    /**
		 * Called if a tracked object was removed.
		 * @param	tuioObject The values of the received /tuio/**Dobj.
		 */
    function removeTuioObject(tuioObject : TuioObject) : Void
    ;
    
    
    /**
		 * Called if a new cursor was tracked.
		 * @param	tuioObject The values of the received /tuio/**Dcur.
		 */
    function addTuioCursor(tuioCursor : TuioCursor) : Void
    ;
    
    /**
		 * Called if a tracked cursor was updated.
		 * @param	tuioCursor The values of the received /tuio/**Dcur.
		 */
    function updateTuioCursor(tuioCursor : TuioCursor) : Void
    ;
    
    /**
		 * Called if a tracked cursor was removed.
		 * @param	tuioCursor The values of the received /tuio/**Dcur.
		 */
    function removeTuioCursor(tuioCursor : TuioCursor) : Void
    ;
    
    
    /**
		 * Called if a new blob was tracked.
		 * @param	tuioBlob The values of the received /tuio/**Dblb.
		 */
    function addTuioBlob(tuioBlob : TuioBlob) : Void
    ;
    
    /**
		 * Called if a tracked blob was updated.
		 * @param	tuioBlob The values of the received /tuio/**Dblb.
		 */
    function updateTuioBlob(tuioBlob : TuioBlob) : Void
    ;
    
    /**
		 * Called if a tracked blob was removed.
		 * @param	tuioBlob The values of the received /tuio/**Dblb.
		 */
    function removeTuioBlob(tuioBlob : TuioBlob) : Void
    ;
    
    /**
		 * Called if a new frameID is received.
		 * @param	id The new frameID
		 */
    function newFrame(id : Int) : Void
    ;
}


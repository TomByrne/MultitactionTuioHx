package org.tuio.legacy;


/**
	 * Legacy PropHandleble from fiducialtuioas3 (http://code.google.com/p/fiducialtuioas3/).
	 * 
	 * For a newer version of a fiducial callback implementation see: 
	 * @see org.tuio.fiducial.TuioFiducialDispatcher
	 * @see org.tuio.fiducial.ITuioFiducialReceiver
	 * 
	 * @author Frederic Friess
	 * 
	 */
interface PropHandleble
{

    function onAdd(evt : PropEvent) : Void
    ;
    function onRemove(evt : PropEvent) : Void
    ;
    function onMove(evt : PropEvent) : Void
    ;
    function onRotate(evt : PropEvent) : Void
    ;
    function onMoveVelocety(evt : PropEvent) : Void
    ;
    function onRotateVelocety(evt : PropEvent) : Void
    ;
    function onMoveAccel(evt : PropEvent) : Void
    ;
    function onRotateAccel(evt : PropEvent) : Void
    ;
}

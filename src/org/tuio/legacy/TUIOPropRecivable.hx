package org.tuio.legacy;

import flash.display.Sprite;

/**
	 * Legacy TUIOPropRecivable interface from fiducialtuioas3 (http://code.google.com/p/fiducialtuioas3/).
	 * 
	 * For a newer version of a fiducial callback implementation see <code>org.tuio.fiducial.TuioFiducialDispatcher</code> and 
	 * <code>org.tuio.fiducial.ITuioFiducialReceiver</code>.
	 * 
	 * @author Frederic Friess
	 * 
	 */
interface TUIOPropRecivable
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



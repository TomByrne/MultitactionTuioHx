package org.tuio;

import org.tuio.TuioTouchEvent;

/**
	 * This interface has to be implemented in order to register touch callbacks in the <code>TuioManager</code> via <code>registerTouchReceiver</code>
	 */
interface ITuioTouchReceiver
{

    /**
		 * Is called if the touch was updated
		 * @param event The corresponding <code>TuioTouchEvent</code>
		 */
    function updateTouch(event : TuioTouchEvent) : Void
    ;
    
    /**
		 * Is called if the touch was removed
		 * @param event The corresponding <code>TuioTouchEvent</code>
		 */
    function removeTouch(event : TuioTouchEvent) : Void
    ;
}

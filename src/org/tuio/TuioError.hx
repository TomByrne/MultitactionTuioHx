package org.tuio;

import flash.errors.Error;

/**
	 * A simple naming extension of the <code>Error</code> class to propagate TUIO errors
	 */
class TuioError extends Error
{
    
    public function new(msg : String)
    {
        super(msg);
    }
}


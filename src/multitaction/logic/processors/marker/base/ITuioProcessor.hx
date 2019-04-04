package multitaction.logic.processors.marker.base;
import org.tuio.ITuioListener;
import multitaction.logic.listener.BasicProcessableTuioListener;

/**
 * @author Michal Moczynski
 */

interface ITuioProcessor 
{
	public var displayName:String;
	
    /**
		 * Adds a listener for incoming data to a private list. 
		 * @param	listener A listener for incoming data
		 */
	
    function addListener(listener:BasicProcessableTuioListener) : Void;
	
}
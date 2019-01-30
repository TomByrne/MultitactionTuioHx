package org.tuio.adapters;

import flash.errors.Error;
import org.tuio.ITuioListener;
import org.tuio.TuioBlob;
import org.tuio.TuioCursor;
import org.tuio.TuioObject;

/**
	 * Provides basic functionality for a Tuio adapter. This can either be a real Tuio adapter like <code>TuioClient</code>
	 * or an adapter that simulates Tuio functionality like <code>MouseTuioAdapter</code> or <code>NativeTuioAdapter</code>.
	 * 
	 * @author Johannes Luderschmidt
	 * @author Immanuel Bauer
	 * 
	 * @see org.tuio.TuioClient
	 * @see org.tuio.adapters.MouseTuioAdapter
	 * @see org.tuio.adapters.NativeTuioAdapter
	 * 
	 */
class AbstractTuioAdapter
{
    /** @private */
    private var _tuioCursors : Map<String, Array<TuioContainer>>;
    /** @private */
    private var _tuioObjects : Map<String, Array<TuioContainer>>;
    /** @private */
    private var _tuioBlobs : Map<String, Array<TuioContainer>>;
    
    /** @private */
    private var listeners : Array<ITuioListener>;
    
    public static inline var DEFAULT_SOURCE : String = "_no_source_";
    
    public function new(self : AbstractTuioAdapter)
    {
        if (self != this)
        {
            throw new Error("Do not initialize this abstract class directly. Instantiate from inheriting class instead.");
        }
        this.listeners = new Array<ITuioListener>();
        
        this._tuioCursors = new Map<String, Array<TuioContainer>>();
        this._tuioObjects = new Map<String, Array<TuioContainer>>();
        this._tuioBlobs = new Map<String, Array<TuioContainer>>();
    }
    
    /**
		 * Adds a listener to the callback stack. The callback functions of the listener will be called on incoming TUIOEvents.
		 * 
		 * @param	listener Object of a class that implements the callback functions defined in the ITuioListener interface.
		 */
    public function addListener(listener : ITuioListener) : Void
    {
        if (this.listeners.indexOf(listener) > -1)
        {
            return;
        }
        this.listeners.push(listener);
    }
    
    /**
		 * Removes the given listener from the callback stack.
		 * 
		 * @param	listener
		 */
    public function removeListener(listener : ITuioListener) : Void
    {
        listeners.remove(listener);
    }
    
    /**
		 * Retrieves all active <code>TuioCursors</code> for the given source.
		 * @param The wanted source. If null or ommited all active <code>TuioCursors</code> are returned.
		 * @return A copy of the list of currently active tuioCursors
		 */
    public function getTuioCursors(source : String = null) : Array<TuioContainer>
    {
        var returnArray : Array<TuioContainer>;
        
        if (source == null)
        {
            returnArray = getAllTuioContainersOf(this._tuioCursors);
        }
        else
        {
            returnArray = this._tuioCursors.get(source);
        }
        return returnArray;
    }
    
    /**
		 * Retrieves all active <code>TuioObjects</code> for the given source.
		 * @param The wanted source. If null or ommited all active <code>TuioObjects</code> are returned.
		 * @return A copy of the list of currently active tuioObjects
		 */
    public function getTuioObjects(source : String = null) : Array<TuioContainer>
    {
        var returnArray : Array<TuioContainer>;
        
        if (source == null)
        {
            returnArray = getAllTuioContainersOf(this._tuioObjects);
        }
        else
        {
            returnArray = this._tuioObjects.get(source);
        }
        return returnArray;
    }
    
    /**
		 * Retrieves all active <code>TuioBlobs</code> for the given source.
		 * @param The wanted source. If null or ommited all active <code>TuioBlobs</code> are returned.
		 * @return A copy of the list of currently active tuioBlobs
		 */
    public function getTuioBlobs(source : String = null) : Array<TuioContainer>
    {
        var returnArray : Array<TuioContainer>;
        
        if (source == null)
        {
            returnArray = getAllTuioContainersOf(this._tuioBlobs);
        }
        else
        {
            returnArray = this._tuioBlobs.get(source);
        }
        return returnArray;
    }
    
    
    /**
		 * Takes care for TUIO 1.0 clients that do not use the source message. Creates one big array 
		 * for the TUIO cursors of all TUIO message in tuioDictionary.
		 * 
		 * @param tuioDictionary contains lists of TuioContainers that will be combined in one array.
		 * @return 
		 * 
		 */
    private function getAllTuioContainersOf(tuioDictionary : Map<String, Array<TuioContainer>>) : Array<TuioContainer>
    {
        var allTuioContainers : Array<TuioContainer> = new Array<TuioContainer>();
        
		for( value in tuioDictionary)
        {
            allTuioContainers = allTuioContainers.concat(value);
        }
        
        return allTuioContainers;
    }
    
    /**
		 * Retrieves the <code>TuioCursor</code> fitting the given sessionID and source.
		 * @param	sessionID The sessionID of the designated tuioCursor
		 * @param	source The source message of the TUIO message provider. If null, all TuioCursor source messages will be searched for the 
		 * TuioCursor with the appropriate sessionID. Attention: If there are more than one TuioCursor with sessionID the first appropriate
		 * TuioCursor will be returned. 
		 * 
		 * @return The <code>TuioCursor</code> matching the given sessionID. Returns null if the tuioCursor doesn't exists
		 */
    public function getTuioCursor(sessionID : Float, source : String = null) : TuioCursor
    {
        var out : TuioCursor = null;
        var searchArray : Array<TuioContainer>;
        
        if (source != null)
        {
            searchArray = this._tuioCursors.get(source);
        }
        else
        {
            searchArray = getAllTuioContainersOf(this._tuioCursors);
        }
        
        for (tc in searchArray)
        {
            if (tc.sessionID == sessionID)
            {
                out = cast(tc, TuioCursor);
                break;
            }
        }
        return out;
    }
    
    /**
		 * Retrieves the <code>TuioObject</code> fitting the given sessionID and source.
		 * @param	sessionID The sessionID of the designated tuioObject
		 * @param	source The source message of the TUIO message provider. If null, all TuioObject source messages will be searched for the 
		 * TuioObject with the appropriate sessionID. Attention: If there are more than one TuioObject with sessionID the first appropriate
		 * TuioObject will be returned. 
		 *    
		 * @return The <code>TuioObject</code> matching the given sessionID. Returns null if the tuioObject doesn't exists
		 */
    public function getTuioObject(sessionID : Float, source : String = null) : TuioObject
    {
        var out : TuioObject = null;
        
        var searchArray : Array<TuioContainer>;
        if (source != null)
        {
            searchArray = this._tuioObjects.get(source);
        }
        else
        {
            searchArray = getAllTuioContainersOf(this._tuioObjects);
        }
        
        for (to in searchArray)
        {
            if (to.sessionID == sessionID)
            {
                out = cast(to, TuioObject);
                break;
            }
        }
        return out;
    }
    
    /**
		 * Retrieves the <code>TuioBlob</code> fitting the given sessionID and source.
		 * @param	sessionID The sessionID of the designated tuioBlob
		 * @param	source The source message of the TUIO message provider. If null, all TuioBlob source messages will be searched for the 
		 * TuioBlob with the appropriate sessionID. Attention: If there are more than one TuioBlob with sessionID the first appropriate
		 * TuioBlob will be returned. 
		 * 
		 * @return The <code>TuioBlob</code> matching the given sessionID. Returns null if the tuioBlob doesn't exists
		 */
    public function getTuioBlob(sessionID : Float, source : String = null) : TuioBlob
    {
        var out : TuioBlob = null;
        
        var searchArray : Array<TuioContainer>;
        if (source != null)
        {
            searchArray = this._tuioBlobs.get(source);
        }
        else
        {
            searchArray = getAllTuioContainersOf(this._tuioBlobs);
        }
        
        for (tb in searchArray)
        {
            if (tb.sessionID == sessionID)
            {
                out = cast(tb, TuioBlob);
                break;
            }
        }
        return out;
    }
    
    /**
		 * Helper functions for dispatching TUIOEvents to the ITuioListeners.
		 */
    
    private function dispatchAddCursor(tuioCursor : TuioCursor) : Void
    {
        for (l in this.listeners)
        {
            l.addTuioCursor(tuioCursor);
        }
    }
    
    private function dispatchUpdateCursor(tuioCursor : TuioCursor) : Void
    {
        for (l in this.listeners)
        {
            l.updateTuioCursor(tuioCursor);
        }
    }
    
    private function dispatchRemoveCursor(tuioCursor : TuioCursor) : Void
    {
        for (l in this.listeners)
        {
            l.removeTuioCursor(tuioCursor);
        }
    }
    
    private function dispatchAddObject(tuioObject : TuioObject) : Void
    {
        for (l in this.listeners)
        {
            l.addTuioObject(tuioObject);
        }
    }
    
    private function dispatchUpdateObject(tuioObject : TuioObject) : Void
    {
        for (l in this.listeners)
        {
            l.updateTuioObject(tuioObject);
        }
    }
    
    private function dispatchRemoveObject(tuioObject : TuioObject) : Void
    {
        for (l in this.listeners)
        {
            l.removeTuioObject(tuioObject);
        }
    }
    
    private function dispatchAddBlob(tuioBlob : TuioBlob) : Void
    {
        for (l in this.listeners)
        {
            l.addTuioBlob(tuioBlob);
        }
    }
    
    private function dispatchUpdateBlob(tuioBlob : TuioBlob) : Void
    {
        for (l in this.listeners)
        {
            l.updateTuioBlob(tuioBlob);
        }
    }
    
    private function dispatchRemoveBlob(tuioBlob : TuioBlob) : Void
    {
        for (l in this.listeners)
        {
            l.removeTuioBlob(tuioBlob);
        }
    }
}

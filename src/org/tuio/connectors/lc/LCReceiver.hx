package org.tuio.connectors.lc;

import flash.errors.Error;
import haxe.Constraints.Function;
import flash.utils.ByteArray;
import flash.net.LocalConnection;
import flash.events.StatusEvent;
import flash.events.AsyncErrorEvent;

/**
	 * A Class for establishing a receiving LocalConnection
	 * @author Immanuel Bauer
	 */
class LCReceiver
{
    
    private var debugListener : Function;
    private var localConnection : LocalConnection;
    private var connectionName : String;
    private var addNumber : Bool;
    private var lcClient : Dynamic;
    
    /**
		 * Constructor
		 * 
		 * @param	connectionName The name of the LocalConnection 
		 * @param	addNumber If true a number is added to the name to avoid nameconflicts
		 * @param	lcClient An Object that contains a function that will be called via the LocalConnection
		 */
    public function new(connectionName : String, lcClient : Dynamic, addNumber : Bool = true)
    {
        this.connectionName = connectionName;
        this.addNumber = addNumber;
        this.lcClient = lcClient;
        
        this.localConnection = new LocalConnection();
        this.localConnection.allowDomain("localhost");
        this.localConnection.allowDomain("*");
        this.localConnection.client = this.lcClient;
        
        var lclistener : Dynamic = {};
        lclistener.onAsyncError = function(e : AsyncErrorEvent) : Void
                {
                    debug("error" + Std.string(e));
                };
        
        this.localConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, lclistener.onAsyncError);
    }
    
    /**
		 * Creates a LocalConnection with the name and client Object given in the constructor
		 * 
		 * @return true if connected successfully
		 */
    public function start() : Bool
    {
        this.stop();
        
        var retry : Int = -1;
        var name : String;
        
        while (retry < 7)
        {
            try
            {
                name = this.connectionName + (((addNumber && retry >= 0)) ? Std.string(retry) : "");
                
                this.localConnection.connect(name);
                
                debug("connected as: " + name);
                return true;
            }
            catch (e : Error)
            {
                retry++;
                debug("retry");
            }
        }
        
        return false;
    }
    
    /**
		 * Stops the LocalConnection
		 * 
		 * @return true if the localconnection could be stopped
		 */
    public function stop() : Bool
    {
        try
        {
            if (this.localConnection != null)
            {
                this.localConnection.close();
            }
            return true;
        }
        catch (e : Error)
        {
            return false;
        }
        return false;
    }
    
    private function debug(msg : String) : Void
    {
        trace(msg);
        if (this.debugListener != null)
        {
            this.debugListener.call(Math.NaN, msg);
        }
    }
    
    /**
		 * Sets the debuglistener. A Function that is called when the TUIOReceiver needs to trace
		 * a debug message to avoid unwanted trace output.
		 * The function hast to accept a String that contains the message.
		 * 
		 * @param	l The listener Function(params: String).
		 */
    public function setDebugListener(l : Function) : Void
    {
        this.debugListener = l;
    }
}


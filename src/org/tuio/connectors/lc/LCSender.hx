package org.tuio.connectors.lc;

import flash.errors.Error;
import haxe.Constraints.Function;
import flash.net.LocalConnection;

/**
	 * A class for sending data via LocalConnection
	 */
class LCSender
{
    
    private var debugListener : Function;
    private var localConnection : LocalConnection;
    private var connectionName : String;
    private var methodName : String;
    
    /**
		 * Constructor
		 * 
		 * @param	connectionName The name of the LocalConnection 
		 */
    public function new(connectionName : String, methodName : String)
    {
        this.connectionName = connectionName;
        this.methodName = methodName;
    }
    
    /**
		 * Creates a sending LocalConnection with the name given in the constructor
		 * 
		 * @param	args The args to be sent
		 * 
		 * @return	true if sent successfully
		 */
    public function send(args : Array<Dynamic> = null) : Bool
    {
        var lc : LocalConnection = new LocalConnection();
        args.unshift(this.methodName);
        args.unshift(this.connectionName);
        try
        {
            lc.send.apply(lc, args);
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

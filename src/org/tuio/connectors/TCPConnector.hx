package org.tuio.connectors;

import flash.net.Socket;
import flash.utils.ByteArray;
import org.tuio.osc.*;
import org.tuio.connectors.tcp.OSCSocket;

/**
	 * An implementation of the <code>IOSCConnector</code> using TCP.
	 * Note that the <code>TuioConnector</code> only works with bridges and trackers tht send TUIO in binary form via TCP i.e. <b>not XML</b> 
	 */
class TCPConnector implements IOSCConnector
{
    
    private var host : String;
    private var port : Int;
    
    private var connection : OSCSocket;
    
    private var listeners : Array<Dynamic>;
    
    /**
		 * Creates a new instance of the TCPConnector
		 * @param	host The IP of the tracker or bridge.
		 * @param	port The port on which the tracker or bridge sends the TUIO tracking data.
		 */
    public function new(host : String = "127.0.0.1", port : Int = 3333)
    {
        this.listeners = new Array<Dynamic>();
        
        this.host = host;
        this.port = port;
        
        this.connection = new OSCSocket();
		connection.dataReceivedCallback = receiveOscData;
        //this.connection.addEventListener(OSCEvent.OSC_DATA, receiveOscData);
        
        this.connection.connect(host, port);
    }
    
    /**
		 * @private
		 */
    //public function receiveOscData(e : OSCEvent) : Void
    public function receiveOscData(data : ByteArray) : Void
    {
        var packet : ByteArray = new ByteArray();
        packet.writeBytes(data, 4);
        packet.position = 0;
        if (packet != null)
        {
            if (this.listeners.length > 0)
            
            //call receive listeners and push the received messages{
                
                for (l/* AS3HX WARNING could not determine type for var: l exp: EField(EIdent(this),listeners) type: null */ in this.listeners)
                {
                    if (OSCBundle.isBundle(packet))
                    {
                        l.acceptOSCPacket(new OSCBundle(packet));
                    }
                    else if (OSCMessage.isMessage(packet))
                    {
                        l.acceptOSCPacket(new OSCMessage(packet));
                    }
                    else
                    {
                        this.debug("\nreceived: invalid osc packet.");
                    }
                }
            }
        }
    }
    
    /**
		 * @inheritDoc
		 */
    public function addListener(listener : IOSCConnectorListener) : Void
    {
        if (this.listeners.indexOf(listener) > -1)
        {
            return;
        }
        
        this.listeners.push(listener);
    }
    
    /**
		 * @inheritDoc
		 */
    public function removeListener(listener : IOSCConnectorListener) : Void
    {
        var tmp : Array<Dynamic> = this.listeners.concat();
        var newList : Array<Dynamic> = new Array<Dynamic>();
        
        var item : Dynamic = tmp.pop();
        while (item != null)
        {
            if (item != listener)
            {
                newList.push(item);
            }
        }
        
        this.listeners = newList;
    }
    
    /**
		 * <b>not implemented</b>
		 * @inheritDoc
		 */
    public function sendOSCPacket(oscPacket : OSCPacket) : Void
    {  // Not Implemented  
        
    }
    
    /**
		 * @inheritDoc 
		 */
    public function close() : Void
    {
        if (this.connection.connected)
        {
            this.connection.close();
        }
    }
    
    private function debug(msg : String) : Void
    {
        trace(msg);
    }
}



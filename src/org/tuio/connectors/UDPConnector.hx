package org.tuio.connectors;

import flash.errors.Error;
import flash.utils.ByteArray;
import org.tuio.connectors.udp.OSCDatagramSocket;
import org.tuio.osc.IOSCConnector;
import org.tuio.osc.IOSCConnectorListener;
import org.tuio.osc.OSCBundle;
import org.tuio.osc.OSCEvent;
import org.tuio.osc.OSCMessage;
import org.tuio.osc.OSCPacket;

/**
	 * An implementation of the <code>IOSCConnector</code> using UDP.
	 * This connector only works in Adobe AIR since v2 due to it using the <code>DatagramSocket</code>
	 * 
	 * This connector can be used to send an receive OSC bundles and messages. 
	 * Though you have to create seperate instances of the connector.
	 * 
	 * @author Johannes Luderschmidt
	 * @author Immanuel Bauer
	 * 
	 */
class UDPConnector implements IOSCConnector
{
    private var connection : OSCDatagramSocket;
    private var listeners : Array<IOSCConnectorListener>;
    
    /**
		 * 
		 * @example The following code shows three approaches to initialize UDPConnector. Use only one of them:
		 * <listing version="3.0">
		 * //tracker runs on localhost on default port 3333
		 * var tuio:TuioClient = new TuioClient(new UDPConnector());
		 * //or 
		 * //tracker runs on 192.0.0.5 on default port 3333 
		 * var tuio:TuioClient = new TuioClient(new UDPConnector("192.0.0.5"));
		 * //or
		 * //tracker runs on 192.0.0.5 on port 3334
		 * var tuio:TuioClient = new TuioClient(new UDPConnector("192.0.0.5",3334));
		 * </listing>
		 * 
		 * @param host ip of the tracker resp. tuio message producer.
		 * @param port of the tracker resp. tuio message producer.
		 * @param bind If true the <code>UDPConnector</code> will try to bind the given IP:port and to receive packets. If false the <code>UDPConnector</code> connects to the given IP:port and will wait for calls of <code>UDPConnector.sendOSCPacket()</code>
		 *
		 */
    public function new(host : String = "127.0.0.1", port : Int = 3333, bind : Bool = true)
    {
        this.listeners = [];
        
        this.connection = new OSCDatagramSocket(host, port, bind);
		this.connection.dataReceivedCallback = receiveOscData;
        //this.connection.addEventListener(OSCEvent.OSC_DATA, receiveOscData);
    }
    
    /**
		 * parses an incoming OSC message.
		 * 
		 * @private
		 * 
		 */
    //public function receiveOscData(e : OSCEvent) : Void
    public function receiveOscData(data : ByteArray) : Void
    {
		//trace('receiveOscData: ' + data.length);
        /*var packet : ByteArray = new ByteArray();
        packet.writeBytes(data);
        packet.position = 0;*/
        
        if (data != null)
        {
			//call receive listeners and push the received messages
			//packet has to be copied in order to allow for more than one listener
			for (l in this.listeners)                
			{
				

				//that actually reads from the ByteArray (after one listener has read,
				//packet will be empty)
				//var copyPacket : ByteArray = copyPacket(packet);

				data.position = 0;
				if (OSCBundle.isBundle(data))
				{
					l.acceptOSCPacket(new OSCBundle(data));
					continue;
				}
				
				data.position = 0;
				if (OSCMessage.isMessage(data))
				{
					l.acceptOSCPacket(new OSCMessage(data));
					continue;
				}
				/*else
				{  //this.debug("\nreceived: invalid osc packet.");  
					
				}*/
				//packet = copyPacket;
			}
        }
        
        //packet = null;
    }
    
    /*private function copyPacket(packet : ByteArray) : ByteArray
    {
        var copyPacket : ByteArray = new ByteArray();
        copyPacket.writeBytes(packet);
        copyPacket.position = 0;
        return copyPacket;
    }*/
    
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
        listeners.remove(listener);
    }
    
    /**
		 * @inheritDoc 
		 */
    public function sendOSCPacket(oscPacket : OSCPacket) : Void
    {
		/*
        if (this.connection.connected)
        {
            this.connection.send(oscPacket.getBytes());
        }
        else
        {
            throw new Error("Can't send if not connected.");
        }
		*/
    }
    
    /**
		 * @inheritDoc 
		 */
    public function close() : Void
    {
        this.connection.close();
    }
}

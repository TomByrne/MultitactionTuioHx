package org.tuio.connectors.udp;

/*
#if air
import flash.events.DatagramSocketDataEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
//import flash.utils.ByteArray;
import flash.utils.Endian;
#else
import js.html.WebSocket;
#end
*/
import imagsyd.net.DatagramSocket;
import openfl.utils.ByteArray;
import org.tuio.osc.OSCEvent;

/**
	 * A simple class for receiving and sending OSCPackets via UDP.
	 */


class OSCDatagramSocket
{
    private var Debug : Bool = true;
    private var Buffer : ByteArray = new ByteArray();
    private var PartialRecord : Bool = false;
	public var dataReceivedCallback: ByteArray->Void;	
	private var socket:DatagramSocket;
    
    public function new(host : String = "127.0.0.1", port : Int = 3333, bind : Bool = true)
    {
		socket = new DatagramSocket();
		
        configureListeners();
        if (bind)
        {
            socket.bind(port, host);
        }
        else
        {
            socket.connect(host, port);
        }
		socket.initialized();
    }

    public function close()
    {
        socket.close();
    }
    
    private function configureListeners() : Void
    {
        socket.connectCallback = connectHandler;
        socket.closeCallback = closeHandler;
        socket.ioErrorCallback = ioErrorHandler;
        socket.securityErrorCallback = securityErrorHandler;
        socket.dataCallback = dataReceived;
    }
	
    private function dataReceived(data:ByteArray):Void
    {
		dataReceivedCallback(data);
    }
    
	
    private function closeHandler() : Void
    {
        if (Debug)
        {
            trace("Connection Closed");
        }
    }
    
    private function connectHandler() : Void
    {
        if (Debug)
        {
            trace("Connected");
        }
    }
    
    private function ioErrorHandler(err:String) : Void
    {
        if (Debug)
        {
            trace("ioErrorHandler: " + err);
        }
    }
    
    private function securityErrorHandler(err:String) : Void
    {
        if (Debug)
        {
            trace("securityErrorHandler: " + err);
        }
    }
}
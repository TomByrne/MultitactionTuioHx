package org.tuio.connectors.tcp;

import flash.events.DataEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Socket;
import flash.utils.ByteArray;
import flash.utils.Endian;
import org.tuio.osc.OSCEvent;
import org.tuio.osc.OSCBundle;

/**
	 * A class for receiving OSCBundles from a TCP socket stream.
	 */
class OSCSocket extends Socket
{
    private var Debug : Bool = true;
    private var Buffer : ByteArray = new ByteArray();
    private var PartialRecord : Bool = false;
    private var isBundle : Bool = false;
	public var dataReceivedCallback ByteArray->Void;
    
    public function new()
    {
        super();
        configureListeners();
    }
    
    private function configureListeners() : Void
    {
        addEventListener(Event.CLOSE, closeHandler);
        addEventListener(Event.CONNECT, connectHandler);
        addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
    }
    
    private function socketDataHandler(event : ProgressEvent) : Void
    {
        var data : ByteArray = new ByteArray();
        if (PartialRecord)
        {
            Buffer.readBytes(data, 0, Buffer.length);
            PartialRecord = false;
        }
        
        super.readBytes(data, data.length, super.bytesAvailable);
        
        var Length : Int;
        
        // While we have data to read
        while (data.position < data.length)
        {
            isBundle = OSCBundle.isBundle(data);
            
            if (isBundle)
            
            //check if the bytes are already a OSCBundle{
                
                if (data.bytesAvailable > 20)
                
                //there should be size information{
                    
                    data.position += 16;
                    if (data.readUTFBytes(1) != "#")
                    {
                        data.position -= 1;
                        Length = as3hx.Compat.parseInt(data.readInt() + 20);
                        data.position -= 20;
                    }
                    else
                    {
                        data.position -= 17;
                        Length = 16;
                    }
                }
                else
                {
                    Length = as3hx.Compat.parseInt(data.length + 1);
                }
            }
            else
            {
                Length = as3hx.Compat.parseInt(data.readInt() + 4);
                data.position -= 4;
            }
            
            // If we have enough data to form a full packet.
            if (Length <= (data.length - data.position))
            {
                var packet : ByteArray = new ByteArray();
                if (isBundle)
                {
                    packet.writeInt(Length);
                }
                data.readBytes(packet, packet.position, Length);
                packet.position = 0;
				
                //this.dispatchEvent(new OSCEvent(packet));
				dataReceivedCallback(packet);
            }
            // Read the partial packet
            else
            {
                
                Buffer = new ByteArray();
                data.readBytes(Buffer, 0, data.length - data.position);
                PartialRecord = true;
            }
        }
    }
    
    private function closeHandler(event : Event) : Void
    {
        if (Debug)
        {
            trace("Connection Closed");
        }
    }
    
    private function connectHandler(event : Event) : Void
    {
        if (Debug)
        {
            trace("Connected");
        }
    }
    
    private function ioErrorHandler(event : IOErrorEvent) : Void
    {
        if (Debug)
        {
            trace("ioErrorHandler: " + event);
        }
    }
    
    private function securityErrorHandler(event : SecurityErrorEvent) : Void
    {
        if (Debug)
        {
            trace("securityErrorHandler: " + event);
        }
    }
}

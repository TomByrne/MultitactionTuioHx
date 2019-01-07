package imagsyd.net;

/**
 * @author Michal Moczynski
 */
import haxe.io.Bytes;
import haxe.io.UInt8Array;
import openfl.utils.ByteArray;
 
//if air use class based on build in DatagramSocket socket class
#if air
import flash.events.DatagramSocketDataEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;

class  DatagramSocket extends flash.net.DatagramSocket
{
	public var connectCallback:Void->Void;
	public var closeCallback:Void->Void;
	public var ioErrorCallback:String->Void;
	public var securityErrorCallback:String->Void;
	public var dataCallback:ByteArray->Void;
		
	public function new() 
	{
		super();
		
        addEventListener(Event.CONNECT, connectHandler);
        addEventListener(Event.CLOSE, closeHandler);
        addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        addEventListener(DatagramSocketDataEvent.DATA, dataReceived);				
	}		
	
	public function initialized():Void
	{
		super.receive();
	}
	
	//hooking up air events to callbacks
	function connectHandler(e:Event):Void {
		connectCallback();}	
	function closeHandler(e:Event):Void {
		closeCallback();}
	function ioErrorHandler(e:IOErrorEvent):Void {
		ioErrorCallback(e.toString());}
	function securityErrorHandler(e:SecurityErrorEvent):Void {
		securityErrorCallback(e.toString());}	
	function dataReceived(e:DatagramSocketDataEvent):Void {
		dataCallback(e.data);}	
	
}

//else (html5) use a custom class based on node datagram socket object
#else
import js.node.dgram.Socket;
import js.node.Dgram;

class DatagramSocket 
{
	public var connectCallback:Void->Void;
	public var closeCallback:Void->Void;
	public var ioErrorCallback:String->Void;
	public var securityErrorCallback:String->Void;
	public var dataCallback:ByteArray->Void;

	private var nodeDgramSocket:Socket;
	
	public function new() 
	{
		nodeDgramSocket = Dgram.createSocket("udp4");
		
		nodeDgramSocket.on("error", function (err) {
			this.error("server error:\n" + err.stack);
			nodeDgramSocket.close();
			//ioErrorCallback(err.stack);
		});

		nodeDgramSocket.on("message", function (msg:UInt8Array, rinfo) {
//			var bytes:Bytes = cast(msg, Bytes);			
			var bytes:Bytes = msg.view.buffer;
//			var bytes:Bytes = Bytes.ofString(msg);
			
//			this.log("server got: " + msg + "        " + bytes);			
			dataCallback(bytes);
		});
		
		

		nodeDgramSocket.on("listening", function () {
			var address = nodeDgramSocket.address();
			this.log("server listening " + address.address + ":" + address.port);
			connectCallback();
		});
	}	
	
	public function bind(port:Int, host:String):Void
	{
		nodeDgramSocket.bind( port, host );
	}
	
	public function connect(host:String, port:Int):Void
	{
		this.warn("'connect' function not implemented for datagram socket in html5 target");
	}

	public function initialized():Void
	{
		
	}
	
}

#end
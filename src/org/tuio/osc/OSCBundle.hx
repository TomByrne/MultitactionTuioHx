package org.tuio.osc;

import flash.utils.ByteArray;

/**
 * This class contains the functions to create, process and identify OSCBundles.
 * 
 * @author Immanuel Bauer
 */
class OSCBundle extends OSCPacket
{
	public var subPackets(get, never) : Array<Dynamic>;
	public var subPacketCount(get, never) : Int;
	public var timetag(get, set) : OSCTimetag;
	private var content : Array<Dynamic>;
	private var time : OSCTimetag;
	private var SECONDS_1900_1970(default, never):Float = 2208988800;  
	/**
	 * Creates a OSCBundle from the given ByteArray containing binary coded OSCBundle
	 * 
	 * @param	bytes ByteArray containing OSC data
	 */  
	public function new(bytes : ByteArray = null)
	{
		super(bytes);
		
		//skip the OSC Bundle head
		if (bytes != null)		
		{
			this.bytes.readUTFBytes(8);  //get OSC timetag  
			this.time = this.readTimetag();
			this.content = new Array<Dynamic>();  //parse the contentBytes to get the OSC Bundles subbundles or messages  
			getSubPackets();
		}
		else
		{
			this.bytes = new ByteArray();
			this.content = [];
			this.time = new OSCTimetag( Std.int(SECONDS_1900_1970 + Date.now().getTime()), 0);
		}
	}  
	
	/**
	 * Returns the subpacket of this OSCPacket with the specified index
	 * 
	 * @param	pos The index of the subpacket
	 * @return An OSCPacket if the given index is valid, else null
	 */  
	public function getContent(pos : Int) : OSCPacket
	{
		if (pos < content.length)
		{
			return content[pos];
		}
		else
		{
			return null;
		}
	}  
	
	/**
	 * Returns all subpackets of this OSCBundle
	 * 
	 * @return An Array containing OSCPackets
	 */  
	private function get_subPackets() : Array<Dynamic>
	{
		return this.content;
	}  
	
	/**
	 * Returns the number of subpackets in this OSCBundle
	 * 
	 * @return The number of subpackets
	 */  
	private function get_subPacketCount() : Int
	{
		return this.content.length;
	}  
	
	/**
	 * Parses the contentBytes for additional OSCBundles or OSCMessages within this OSCBundle
	 */  
	private function getSubPackets() : Void
	{
		while (this.bytes.bytesAvailable > 0)
		
		//read / skip length info
		{
			this.bytes.readInt();
			
			if (isBundle(this.bytes))
			{
				this.content.push(new OSCBundle(this.bytes));
			}
			else
			{
				this.content.push(new OSCMessage(this.bytes));
			}
		}
	}  
	
	/**
	 * Adds an <code>OSCPacket</code> in its current state to the <code>OSCBundle</code>
	 * 
	 * @param	packet The <code>OSCPacket</code> to be added.
	 */  
	public function addPacket(packet : OSCPacket) : Void
	{
		this.content.push(packet);var packetBytes : ByteArray = packet.getBytes();this.bytes.writeInt(packetBytes.length);this.bytes.writeBytes(packetBytes, 0, packetBytes.length);
	}  
	
	/**
	 * @return The OSCTimetag of this OSCBundle
	 */  
	private function get_timetag() : OSCTimetag
	{
		return this.time;
	}  
	
	/**
	 * Set the OSCBundles OSCTimetag
	 */  
	private function set_timetag(ott : OSCTimetag) : OSCTimetag
	{
		this.time = ott;
		return ott;
	}  
	
	/**
	 * Returns the bytes of this <code>OSCBundle</code> and its contained <code>OSCPackets</code>
	 * 
	 * @return A <code>ByteArray</code> containing the bytes of this <code>OSCBundle</code>
	 */  
	override public function getBytes() : ByteArray
	{
		var out : ByteArray = new ByteArray();
		writeString("#bundle", out);
		writeTimetag(this.time, out);
		out.writeBytes(this.bytes, 0, this.bytes.length);
		out.position = 0;
		return out;
	}  
	
	/**
	 * Generates a String representation of this OSCBundle and its subpackets for debugging purposes
	 * 
	 * @return traceable String
	 */  
	override public function getPacketInfo() : String
	{
		var out : String = "";
		out += "\nSeconds: " + Std.string(this.timetag.seconds);out += "\nPicoseconds: " + Std.string(this.timetag.picoseconds);out += "\nSubPackets: " + Std.string(this.subPacketCount);for (item in content)
		{
			out += item.getPacketInfo();
		}return out;
	}  
	
	/**
	 * Checks if the given ByteArray is an OSCBundle
	 * 
	 * @param	bytes The ByteArray to be checked.
	 * @return true if the ByteArray contains an OSCBundle
	 */  
	public static function isBundle(bytes : ByteArray) : Bool
	{
		if (bytes != null)
		{
			if (bytes.bytesAvailable >= 8)
			
			//bytes.position = 0;
			{
				var header : String = bytes.readUTFBytes(8);
				bytes.position -= 8;
				if (header == "#bundle")
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}  
	
	/**
	 * This is comfort function for creating an OSCBundle with less code.
	 * 
	 * @param	content An <code>Array</code> containing <code>OSCPackets</code> that should be wrapped by the <code>OSCBundle</code>.
	 * @param	timetag The <code>OSCTimtetag</code> of the <code>OSCBundle</code>. If not supplied the time of instantiation is used.
	 * @return	An <code>OSCBundle</code> containing the given <code>OSCPackets</code>.
	 */  
	public static function createOSCBundle(content : Array<Dynamic>, timetag : OSCTimetag = null) : OSCBundle
	{
		var bundle : OSCBundle = new OSCBundle();if (timetag != null)
		{
			bundle.time = timetag;
		}for (packet in content)
		{
			bundle.addPacket(packet);
		}return bundle;
	}
}
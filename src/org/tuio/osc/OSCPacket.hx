package org.tuio.osc;

import flash.utils.ByteArray;
import flash.errors.EOFError;

/**
	 * This is a basic class for OSCBundles and OSCMessages that basically wraps a ByteArray
	 * and offers some additional functions for reading the binary data for extending classes.
	 * 
	 * @author Immanuel Bauer
	 */class OSCPacket
{@:allow(org.tuio.osc)
    private var bytes : ByteArray;public function new(bytes : ByteArray = null)
    {
        if (bytes != null)
        {
            this.bytes = bytes;
        }
        else
        {
            this.bytes = new ByteArray();
        }
    }
	
	public function getPacketInfo() : String
    {
        return "packet";
    }
	
	public function getBytes() : ByteArray
    {
//		Logger.log(this, "  - getBytes " + bytes);
        return this.bytes;
    }
	
	private function skipNullString() : Void
    {
//		Logger.log(this, "  - skipNullString ");
        var char : String = "";
		while (this.bytes.bytesAvailable > 0)
        {
            char = this.bytes.readUTFBytes(1);
//			Logger.log(this, "  - skipNullString char " + char + " " + char != "");
			if (char != "")
            {
                this.bytes.position -= 1;
				break;
            }
        }
    }
	
	private function readString() : String
    {
        var out : String = ""; 
		var char : String = "";
		while (this.bytes.bytesAvailable > 0)
        {
            char = this.bytes.readUTFBytes(4);
//			Logger.log(this, "  - readString CHAR " + char);
			out += char;
			
			if (char.length < 4)
            {
                break;
            }
        }
		return out;
    }
	
	private function readTimetag() : OSCTimetag
    {
        var seconds : UInt = this.bytes.readUnsignedInt();
		var picoseconds : UInt = this.bytes.readUnsignedInt();
//		Logger.log(this, "  - readTimetag " + seconds + " " + picoseconds);
		return new OSCTimetag(seconds, picoseconds);
    }
	
	private function readBlob() : ByteArray
    {
        var length : Int = this.bytes.readInt();
		var blob : ByteArray = new ByteArray();
		this.bytes.readBytes(blob, 0, length);
		var bits : Int = (length + 1) * 8;
		while ((bits % 32) != 0)
        {
            this.bytes.position += 1;bits += 8;
        }
		return blob;
    }
	
	private function read64BInt() : ByteArray
    {
        var bigInt : ByteArray = new ByteArray();
		this.bytes.readBytes(bigInt, 0, 8);
		return bigInt;
    }
	
	private function writeString(str : String, byteArray : ByteArray = null) : Void
    {
        var nulls : Int = 4 - (str.length % 4);
		if (byteArray == null)
        {
            byteArray = this.bytes;
        }
		
		byteArray.writeUTFBytes(str);  //add zero padding so the length of the string is a multiple of 4  for (c in 0...nulls)
        {
            byteArray.writeByte(0);
        }
    }
	
	private function writeTimetag(ott : OSCTimetag, byteArray : ByteArray = null) : Void
    {
        if (byteArray == null)
        {
            byteArray = this.bytes;
        }
		byteArray.writeUnsignedInt(ott.seconds);
		byteArray.writeUnsignedInt(ott.picoseconds);
    }
	
	private function writeBlob(blob : ByteArray) : Void
    {
        var length : Int = blob.length; blob.position = 0;
		blob.readBytes(this.bytes, this.bytes.position, length);
		var nulls : Int = length % 4;
		for (c in 0...nulls)
        {
            this.bytes.writeByte(0);
        }
    }
	
	private function write64BInt(bigInt : ByteArray) : Void
    {
        bigInt.position = 0;
		bigInt.readBytes(this.bytes, this.bytes.position, 8);
    }
}
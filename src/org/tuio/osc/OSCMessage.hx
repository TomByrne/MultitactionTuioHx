package org.tuio.osc;

import flash.errors.Error;
import flash.errors.EOFError;
import flash.utils.ByteArray;

/**
	 * An OSCMessage
	 * @author Immanuel Bauer
	 */
class OSCMessage extends OSCPacket
{
    public var address(get, set) : String;
    public var arguments(get, never) : Array<Dynamic>;

    
    private var addressPattern : String;
    private var pattern : String;
    private var action : String;
    private var argumentArray : Array<Dynamic>;
    private var openArray : Array<Dynamic>;
    private var innerArray : Array<Dynamic>;
    private var typesArray : Array<Dynamic>;
    
    /**
		 * Creates a OSCMessage from the given ByteArray containing a binarycoded OSCMessage
		 * 
		 * @param	bytes A ByteArray containing an OSCMessage
		 */
    public function new(bytes : ByteArray = null)
    {
        super(bytes);
        
        if (bytes != null)
        
        //read the OSCMessage head
		{
            
            this.addressPattern = this.readString();
            
            //read the parsing pattern for the following OSCMessage bytes
            this.pattern = this.readString();
            
            this.typesArray = new Array<Dynamic>();
            
            this.argumentArray = new Array<Dynamic>();
            
            //read the remaining bytes according to the parsing pattern
            this.openArray = this.argumentArray;
            var l : Int = this.pattern.length;
			Logger.log(this, "pattern " + pattern + " " + this);
			
            try
            {
                for (c in 0...l)
                {
                    switch (this.pattern.charAt(c))
                    {
                        case "s":
							openArray.push(this.readString());
							this.typesArray.push("s");
                        case "f":
							openArray.push(this.bytes.readFloat());
							this.typesArray.push("f");
                        case "i":
							openArray.push(this.bytes.readInt());
							this.typesArray.push("i");
                        case "b":
							openArray.push(this.readBlob());
							this.typesArray.push("b");
                        case "h":
							openArray.push(this.read64BInt());
							this.typesArray.push("h");
                        case "t":
							openArray.push(this.readTimetag());
							this.typesArray.push("t");
                        case "d":
							openArray.push(this.bytes.readDouble());
							this.typesArray.push("d");
                        case "S":
							openArray.push(this.readString());
							this.typesArray.push("S");
                        case "c":
							openArray.push(this.bytes.readMultiByte(4, "US-ASCII"));
							this.typesArray.push("c");
                        case "r":openArray.push(this.bytes.readUnsignedInt());this.typesArray.push("r");
                        case "T":openArray.push(true);this.typesArray.push("T");
                        case "F":openArray.push(false);this.typesArray.push("F");
                        case "N":openArray.push(null);this.typesArray.push("N");
                        case "I":openArray.push(Math.POSITIVE_INFINITY);this.typesArray.push("I");
                        case "[":innerArray = new Array<Dynamic>();openArray = innerArray;this.typesArray.push("[");
                        case "]":this.argumentArray.push(innerArray.copy());openArray = this.argumentArray;this.typesArray.push("]");
                        default:
                    }
                }
            }
            catch (e : EOFError)
            {
                Logger.warn(this, "message corrupted");
                this.argumentArray = new Array<Dynamic>();
                this.argumentArray.push("Corrupted OSCMessage");
                openArray = null;
            }
        }
        else
        {
            this.pattern = ",";
            this.argumentArray = [];
            this.openArray = this.argumentArray;
        }
    }
    
    /**
		 * Adds a single argument value to the OSCMessage
		 * For special oscTypes like booleans or infinity there is no value needed
		 * If you want to add an OSCArray to the <code>OSCMessage</code> use <code>addArgmuents()</code>
		 * 
		 * @param	oscType The OSCType of the argument.
		 * @param	value The value of the argument.
		 */
    public function addArgument(oscType : String, value : Dynamic = null) : Void
    {
        if (oscType.length == 1)
        {
            if ((oscType == "s" || oscType == "S") && Std.is(value, String))
            {
                this.pattern += oscType;
                this.openArray.push(value);
                this.writeString(Std.string(value));
            }
            else if (oscType == "f" && Std.is(value, Float))
            {
                this.pattern += oscType;
                this.openArray.push(value);
                this.bytes.writeFloat(as3hx.Compat.parseFloat(value));
            }
            else if (oscType == "i" && Std.is(value, Int))
            {
                this.pattern += oscType;
                this.openArray.push(value);
                this.bytes.writeInt(as3hx.Compat.parseInt(value));
            }
            else if (oscType == "b" && Std.is(value, ByteArray))
            {
                this.pattern += oscType;
                this.openArray.push(value);
                this.writeBlob(try cast(value, ByteArray) catch(e:Dynamic) null);
            }
            else if (oscType == "h" && Std.is(value, ByteArray))
            {
                this.pattern += oscType;
                this.openArray.push(value);
            }
            else if (oscType == "t" && Std.is(value, OSCTimetag))
            {
                this.pattern += oscType;
                this.openArray.push(value);
                this.writeTimetag(try cast(value, OSCTimetag) catch(e:Dynamic) null);
            }
            else if (oscType == "d" && Std.is(value, Float))
            {
                this.pattern += oscType;
                this.openArray.push(value);
                this.bytes.writeDouble(as3hx.Compat.parseFloat(value));
            }
            else if (oscType == "c" && Std.is(value, String) && (Std.string(value)).length == 1)
            {
                this.pattern += oscType;
                this.openArray.push(value);
                this.bytes.writeMultiByte(Std.string(value), "US-ASCII");
            }
            else if (oscType == "r" && Std.is(value, Int))
            {
                this.pattern += oscType;
                this.openArray.push(value);
				var isInt:Bool = false;
				var valueInt:Int = 0; 
				try{
					valueInt = cast(value, Int);
					isInt = true;
				}
				catch (e:Dynamic){
					
				};
				if(isInt)
					this.bytes.writeUnsignedInt(valueInt);
            }
            else if (oscType == "T")
            {
                this.pattern += oscType;
                this.openArray.push(true);
            }
            else if (oscType == "F")
            {
                this.pattern += oscType;
                this.openArray.push(false);
            }
            else if (oscType == "N")
            {
                this.pattern += oscType;
                this.openArray.push(null);
            }
            else if (oscType == "I")
            {
                this.pattern += oscType;
                this.openArray.push(Math.POSITIVE_INFINITY);
            }
            else
            {
                throw new Error("Invalid or unknown OSCType or invalid value for given OSCType: " + oscType);
            }
        }
        else
        {
            throw new Error("The oscType has to be one character.");
        }
    }
    
    /**
		 * Add multiple argument values to the OSCMessage at once.
		 * 
		 * @param	oscTypes The OSCTypes of the arguments
		 * @param	values The values of the arguments
		 */
    public function addArguments(oscTypes : String, values : Array<Dynamic>) : Void
    {
        var l : Int = oscTypes.length;
        var oscType : String = "";
        var vc : Int = 0;
        
        for (c in 0...l)
        {
            oscType = oscTypes.charAt(c);
            if (oscType.charCodeAt(0) < 97)
            
            //isn't a small letter
			{
                
                if (oscType == "[")
                {
                    innerArray = new Array<Dynamic>();
                    openArray = innerArray;
                }
                else if (oscType == "]")
                {
                    this.argumentArray.push(innerArray.copy());
                    openArray = this.argumentArray;
                }
                else if (oscType == "S")
                {
                    addArgument(oscType, values[vc]);
                    vc++;
                }
                else
                {
                    addArgument(oscType);
                }
            }
            else
            {
                addArgument(oscType, values[vc]);
                vc++;
            }
        }
    }
    
    /**
		 * @return The address pattern of the OSCMessage
		 */
    private function get_address() : String
    {
        return addressPattern;
    }
    
    /**
		 * Sets the address of the Message
		 */
    private function set_address(address : String) : String
    {
        this.addressPattern = address;
        return address;
    }
    
    /**
		 * @return The arguments/content of the OSCMessage
		 */
    private function get_arguments() : Array<Dynamic>
    {
        return argumentArray;
    }
    
    /* Returns the bytes of this <code>OSCMessage</code>
		 * 
		 * @return A <code>ByteArray</code> containing the bytes of this <code>OSCMessage</code>
		 */
    override public function getBytes() : ByteArray
    {
        var out : ByteArray = new ByteArray();
        this.writeString(this.address, out);
        this.writeString(this.pattern, out);
        out.writeBytes(this.bytes, 0, this.bytes.length);
        out.position = 0;
        return out;
    }
    
    /**
		 * Generates a String representation of this OSCMessage for debugging purposes
		 * 
		 * @return A traceable String.
		 */
    override public function getPacketInfo() : String
    {
        var out : String = "";
        out += "\nMessagehead: " + this.addressPattern + " | " + this.pattern + " | ->  (" + this.argumentArray.length + ") \n" + this.argumentsToString();
        return out;
    }
    
    /**
		 * Generates a String representation of this OSCMessage's content for debugging purposes
		 * 
		 * @return A traceable String.
		 */
    public function argumentsToString() : String
    {
        var out : String = "arguments: ";
        if (this.argumentArray.length > 0)
        {
            out += Std.string(this.argumentArray[0]);
            for (c in 1...this.argumentArray.length)
            {
                out += " | " + Std.string(this.argumentArray[c]);
            }
        }
        return out;
    }
    
    /**
		 * Checks if the given ByteArray is an OSCMessage
		 * 
		 * @param	bytes The ByteArray to be checked.
		 * @return true if the ByteArray contains an OSCMessage
		 */
    public static function isMessage(bytes : ByteArray) : Bool
    {
        if (bytes != null)
        
        //bytes.position = 0;
		{
            
            var header : String = bytes.readUTFBytes(1);
            bytes.position -= 1;
            if (header == "/")
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
    
    /**
		 * This is comfort function for creating an OSCMessage with less code.
		 * 
		 * @param	address The OSCAddress of the <code>OSCMessage</code>.
		 * @param	valueOSCTypes A <code>String</code> of OSCTypes describing the types of the <code>Objects</code> within the <code>values</code> <code>Array</code>. There has to be a type for every value in the <code>values</code> <code>Array</code>.
		 * @param	values An <code>Array</code> containing the values that should be part of the <code>OSCMessage</code>.
		 * @return	An <code>OSCMessage</code> containing the given values.
		 */
    public static function createOSCMessage(address : String, valueOSCTypes : String, values : Array<Dynamic>) : OSCMessage
    {
        var msg : OSCMessage = new OSCMessage();
        msg.addressPattern = address;
        msg.addArguments(valueOSCTypes, values);
        return msg;
    }
    
    
    /**
		 *  
		 * @return string representation of an OSCMessage. 
		 * 
		 */
    public function toString() : String
    {
        var toString : String = "";
        toString = toString + ("<name:");
        toString = toString + ("" + this.address);
        toString = toString + (",");
        
        //types
        toString = toString + (" [types: ");
        for (i in 0...this.typesArray.length)
        {
            toString = toString + ("" + this.typesArray[i]);
            if (i < this.typesArray.length - 1)
            {
                toString = toString + (", ");
            }
        }
        toString = toString + ("],");
        
        //arguments
        toString = toString + (" [arguments: ");
        for (i in 0...this.openArray.length)
        {
            toString = toString + ("" + this.openArray[i]);
            if (i < this.openArray.length - 1)
            {
                toString = toString + (", ");
            }
        }
        toString = toString + ("]");
        
        toString = toString + (">");
        
        return toString;
    }
}


package org.tuio.osc;


/**
	 * The main class for receiving and sending OSC data.
	 */
class OSCManager implements IOSCConnectorListener
{
    public var connectorIn(get, set) : IOSCConnector;
    public var connectorOut(get, set) : IOSCConnector;
    public var currentPacket(get, never) : OSCPacket;

    
    private var _connectorIn : IOSCConnector;
    private var _connectorOut : IOSCConnector;
    
    private var _currentPacket : OSCPacket;
    
    private var msgListener : Array<Dynamic>;
    private var oscMethods : Map<String, IOSCListener>;
    private var oscAddressSpace : OSCAddressSpace;
    
    private var running : Bool;
    
    /**
		 * If <code>true</code> pattern matching is enabled for OSC addresse lookups. The default is <code>false</code>.
		 */
    public var usePatternMatching : Bool = false;
    
    /**
		 * Creates a new instance of the OSCManager.
		 * @param	connectorIn The IOSConnector which should be used for receiving OSC data.
		 * @param	connectorOut The IOSCConnector which should be used to send OSC data
		 * @param	autoStart If true the OSCManager will immediately begin to process incoming OSCPackets. Default is true.
		 */
    public function new(connectorIn : IOSCConnector = null, connectorOut : IOSCConnector = null, autoStart : Bool = true)
    {
        this.msgListener = new Array<Dynamic>();
        this.oscMethods = new Map<String, IOSCListener>();
        
        this._connectorIn = connectorIn;
        if (this._connectorIn != null)
        {
            this._connectorIn.addListener(this);
        }
        this._connectorOut = connectorOut;
        
        this.running = autoStart;
    }
    
    /**
		 * If called the OSCManager will start to process incoming OSCPackets.
		 */
    public function start() : Void
    {
        this.running = true;
    }
    
    /**
		 * If called the OSCManager will stop to process incoming OSCPackets.
		 */
    public function stop() : Void
    {
        this.running = false;
    }
    
    /**
		 * The IOSConnector which is used for receiving OSC data.
		 */
    private function set_connectorIn(conn : IOSCConnector) : IOSCConnector
    {
        if (this._connectorIn != null)
        {
            this._connectorIn.removeListener(this);
        }
        this._connectorIn = conn;
        this._connectorIn.addListener(this);
        return conn;
    }
    
    private function get_connectorIn() : IOSCConnector
    {
        return this._connectorIn;
    }
    
    /**
		 * The IOSConnector which is used for sending OSC data.
		 */
    private function set_connectorOut(conn : IOSCConnector) : IOSCConnector
    {
        this._connectorOut = conn;
        return conn;
    }
    
    private function get_connectorOut() : IOSCConnector
    {
        return this._connectorOut;
    }
    
    /**
		 * Sends the given OSCPacket via the outgoing IOSCConnector.
		 * @param	oscPacket
		 */
    public function sendOSCPacket(oscPacket : OSCPacket) : Void
    {
        if (this._connectorOut != null )
        {
            this._connectorOut.sendOSCPacket(oscPacket);
        }
    }
    
    /**
		 * The OSCPacket which was last received.
		 */
    private function get_currentPacket() : OSCPacket
    {
        return this._currentPacket;
    }
    
    /**
		 * @inheritDoc
		 */
    public function acceptOSCPacket(oscPacket : OSCPacket) : Void
    {
        if (running)
        {
            this._currentPacket = oscPacket;
            this.distributeOSCPacket(this._currentPacket);
            oscPacket = null;
        }
    }
    
    /**
		 * Distributes the OSCPacket to all lissteners by checking if the OSCPacket is an
		 * OSCBundle or an OSCMessage and recursively calling itself until the contained
		 * OSCMessages are distibuted.
		 * @param	packet The OSCPacket which has to be distributed
		 */
    private function distributeOSCPacket(packet : OSCPacket) : Void
    {
        if (Std.is(packet, OSCMessage))
        {
            this.distributeOSCMessage(try cast(packet, OSCMessage) catch(e:Dynamic) null);
        }
        else if (Std.is(packet, OSCBundle))
        {
			var osc:OSCBundle = cast(packet, OSCBundle);
			
            var cont : Array<Dynamic> = (try cast(packet, OSCBundle) catch (e:Dynamic) null).subPackets;
			if (cont != null)
			{
				for (p in cont)
				{
					this.distributeOSCPacket(p);
				}
			}
        }
    }
    
    /**
		 * Distributes the given OSCMessage to the addressd IOSCListeners.
		 * @param	msg The OSCMessage to distribute.
		 */
    private function distributeOSCMessage(msg : OSCMessage) : Void
    {
		/* AS3HX WARNING could not determine type for var: l exp: EField(EIdent(this),msgListener) type: null */
        for (l in this.msgListener)
        {
            l.acceptOSCMessage(msg);
        }
        
		if(Lambda.count(this.oscMethods) > 0){
			
			var oscMethod:IOSCListener;
			var oscMethodsArr:Array<Dynamic>;
			
			if (this.usePatternMatching) {
				oscMethodsArr = this.oscAddressSpace.getMethods(msg.address);
				for (l in oscMethods) {
					l.acceptOSCMessage(msg);
				}
			} else {
				oscMethod = this.oscMethods.get(msg.address);
				if (oscMethod != null) oscMethod.acceptOSCMessage(msg);
			}
		}
	}
    
    /**
		 * Registers an OSC Method handler
		 * @param	address The address of the OSC Method
		 * @param	listener The listener for handling calls to the OSC Method
		 */
    public function addMethod(address : String, listener : IOSCListener) : Void
    {
        this.oscMethods.set(address, listener);
        this.oscAddressSpace.addMethod(address, listener);
    }
    
    /**
		 * Unregisters the OSC Method under the given address
		 * @param	address The address of the OSC Method to be unregistered.
		 */
    public function removeMethod(address : String) : Void
    {
        this.oscMethods.set(address, null);
        this.oscAddressSpace.removeMethod(address);
    }
    
    /**
		 * Registers a general OSCMethod listener which will be called for every 
		 * recevied OSCMessage.
		 * @param	listener The IOSCListener implementation to handle the OSC Messages.
		 */
    public function addMsgListener(listener : IOSCListener) : Void
    {
        if (this.msgListener.indexOf(listener) > -1)
        {
            return;
        }
        this.msgListener.push(listener);
    }
    
    /**
		 * Removes the given OSC Method listener
		 * @param	listener The listener to be removed.
		 */
    public function removeMsgListener(listener : IOSCListener) : Void
    {
        var temp : Array<Dynamic> = new Array<Dynamic>();
        for (l/* AS3HX WARNING could not determine type for var: l exp: EField(EIdent(this),msgListener) type: null */ in this.msgListener)
        {
            if (l != listener)
            {
                temp.push(l);
            }
        }
        this.msgListener = temp.copy();
    }
}


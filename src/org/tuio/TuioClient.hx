package org.tuio;

import org.tuio.adapters.AbstractTuioAdapter;
import org.tuio.osc.*;

/**
	 * A class for receiving tracking data via the TUIO protocol using a seperate OSC parser 
	 * package located in org.tuio.osc.
	 * 
	 * @author Immanuel Bauer
	 */
class TuioClient extends AbstractTuioAdapter implements IOSCListener
{
	public var listenForCursors:Bool = true;
	public var listenForObjects:Bool = true;
	public var listenForBlobs:Bool = false;
	
    public var currentFseq(get, never) : Int;
    public var currentSource(get, never) : String;

    
    private var oscManager : OSCManager;
    
    private var fseq : Int;
    private var src : String = AbstractTuioAdapter.DEFAULT_SOURCE;
    
    /**
		 * Creates an instance of the TuioClient with the given IOSConnector.
		 * 
		 * @param	connector An instance that implements IOSConnector, establishes and handles an incoming connection. 
		 */
    public function new(connector : IOSCConnector)
    {
        super(this);
        
        if (this._tuioBlobs[this.src] == null)
        {
            this._tuioBlobs[this.src] = [];
        }
        if (this._tuioCursors[this.src] == null)
        {
            this._tuioCursors[this.src] = [];
        }
        if (this._tuioObjects[this.src] == null)
        {
            this._tuioObjects[this.src] = [];
        }
        
        if (connector != null)
        {
            this.oscManager = new OSCManager(connector);
            this.oscManager.addMsgListener(this);
        }
    }
    
    /**
		 * Callback function for receiving TUIO tracking data in OSCMessages as specified in the IOSCListener interface.
		 * 
		 * @param	msg The OSCMessage containing a single TUIOEvent.
		 */
    public function acceptOSCMessage(msg : OSCMessage) : Void
    {
		//PERFORMANCE MEASUREMENT - before this point 10 fingers increase GC from 200ms to 430ms, no significent code time difference (250ms > 300ms) - over 3s time period  (that's 39% and 12% of the whole process added by tuio);
		//return;
		//PERFORMANCE MEASUREMENT - before this point 10 fingers increase GC from 200ms to 780ms, code grows to 650ms (over 3s time period measured) 
		
        var tuioContainerList : Array<TuioContainer>;
        if (msg.arguments[0] == "source")
        {
            //this.src = Std.string(msg.arguments[1]);
            this.src = msg.arguments[1];
            if (this._tuioBlobs[this.src] == null)
            {
                this._tuioBlobs[this.src] = [];
            }
            if (this._tuioCursors[this.src] == null)
            {
                this._tuioCursors[this.src] = [];
            }
            if (this._tuioObjects[this.src] == null)
            {
                this._tuioObjects[this.src] = [];
            }
        }
        else if (msg.arguments[0] == "alive")
        {
			if (listenForCursors == true)
			{
				if (msg.address.indexOf("cur") > -1)
				{
					for (tcur in this._tuioCursors[this.src])
					{
						tcur.isAlive = false;
					}
					
					for (k in 1...msg.arguments.length)
					{
						for (tcur in this._tuioCursors[this.src])
						{
							if (tcur.sessionID == msg.arguments[k])
							{
								tcur.isAlive = true;
								break;
							}
						}
					}
					
					//tuioContainerList = this._tuioCursors[this.src].concat();
					tuioContainerList = this._tuioCursors.get(this.src);
					this._tuioCursors[this.src] = [];// new Array<TuioContainer>();
					
					for (tcur in tuioContainerList)
					{
						if (tcur.isAlive)
						{
							this._tuioCursors[this.src].push(tcur);
						}
						else
						{
							dispatchRemoveCursor( cast(tcur, TuioCursor) );
						}
					}
				}
            }
            if (msg.address.indexOf("obj") > -1)
            {
				if (listenForObjects == true)
				{
					for (to in this._tuioObjects[this.src])
					{
						to.isAlive = false;
					}
					
					for (t in 1...msg.arguments.length)
					{
						for (to in this._tuioObjects[this.src])
						{					
							var tuioObject:TuioObject = cast( to, TuioObject);
							if (tuioObject.sessionID == msg.arguments[t])
							{
								tuioObject.isAlive = true;
								break;
							}
						}
					}
					
					//tuioContainerList = this._tuioObjects[this.src].concat();
					tuioContainerList = this._tuioObjects.get(this.src);
					this._tuioObjects[this.src] = [];//new Array<TuioContainer>();
					
					for (to in tuioContainerList)
					{
						if (to.isAlive)
						{
							this._tuioObjects[this.src].push(to);
						}
						else
						{
							dispatchRemoveObject( cast(to, TuioObject) );
						}
					}
				}
            }
            else if (msg.address.indexOf("blb") > -1)
            {
				if (listenForBlobs == true)
				{
					for (tb in this._tuioBlobs[this.src])
					{
						tb.isAlive = false;
					}
					
					
					for (u in 1...msg.arguments.length)
					{
						for (tb in this._tuioBlobs[this.src])
						{
							if (tb.sessionID == msg.arguments[u])
							{
								tb.isAlive = true;
								break;
							}
						}
					}
					
					//tuioContainerList = this._tuioBlobs[this.src].concat();
					tuioContainerList = this._tuioBlobs.get(this.src);
					this._tuioBlobs[this.src] = [];// new Array<TuioContainer>();
					
					for (tb in tuioContainerList)
					{
						if (tb.isAlive)
						{
							this._tuioBlobs[this.src].push(tb);
						}
						else
						{
							dispatchRemoveBlob( cast(tb, TuioBlob));
						}
					}
				}
            }			
            else
            {
                return;
            }
        }
        else if (msg.arguments[0] == "set")
        {
            var isObj : Bool = false;
            var isBlb : Bool = false;
            var isCur : Bool = false;
            
            var is2D : Bool = true;
            var is25D : Bool = false;
            var is3D : Bool = false;
            

			/*
            if (msg.address.indexOf("/tuio/2D") == 0)
            {
                is2D = true;
            }
            else if (msg.address.indexOf("/tuio/25D") == 0)
            {
                is25D = true;
            }
            else if (msg.address.indexOf("/tuio/3D") == 0)
            {
                is3D = true;
            }
            else
            {
                return;
            }
            */
			
            if (listenForObjects && msg.address.indexOf("obj") > -1)
            {
                isObj = true;
            }
            else if (listenForCursors && msg.address.indexOf("cur") > -1)
            {
                isCur = true;
            }
            else if (listenForBlobs && msg.address.indexOf("blb") > -1)
            {
                isBlb = true;
            }
            else
            {
                return;
            }
            
            var s : Float = 0;
            var i : Float = 0;
            var x : Float = 0;
            var y : Float = 0;
            var z : Float = 0;
            var a : Float = 0;
            var b : Float = 0;
            var c : Float = 0;
            var X : Float = 0;
            var Y : Float = 0;
            var Z : Float = 0;
            var A : Float = 0;
            var B : Float = 0;
            var C : Float = 0;
            var w : Float = 0;
            var h : Float = 0;
            var d : Float = 0;
            var f : Float = 0;
            var v : Float = 0;
            var m : Float = 0;
            var r : Float = 0;
            
            var index : Int = 2;
            
            s = /*as3hx.Compat.parseFloat*/(msg.arguments[1]);
            
            if (isObj)
            {
                i = /*as3hx.Compat.parseFloat*/(msg.arguments[index++]);
            }
            
            x = /*as3hx.Compat.parseFloat*/(msg.arguments[index++]);
            y = /*as3hx.Compat.parseFloat*/(msg.arguments[index++]);
            
            if (!is2D)
            {
                z = /*as3hx.Compat.parseFloat*/(msg.arguments[index++]);
            }
            
            if (!isCur)
            {
                a = /*as3hx.Compat.parseFloat*/(msg.arguments[index++]);
                if (is3D)
                {
                    b = /*as3hx.Compat.parseFloat*/(msg.arguments[index++]);
                    c = /*as3hx.Compat.parseFloat*/(msg.arguments[index++]);
                }
            }
            
            if (isBlb)
            {
                w = /*as3hx.Compat.parseFloat*/(msg.arguments[index++]);
                h = /*as3hx.Compat.parseFloat*/(msg.arguments[index++]);
                if (!is3D)
                {
                    f = /*as3hx.Compat.parseFloat*/(msg.arguments[index++]);
                }
                else
                {
                    d = /*as3hx.Compat.parseFloat*/(msg.arguments[index++]);
                    v = /*as3hx.Compat.parseFloat*/(msg.arguments[index++]);
                }
            }
            
            X = /*as3hx.Compat.parseFloat*/(msg.arguments[index++]);
            Y = /*as3hx.Compat.parseFloat*/(msg.arguments[index++]);
            
            if (!is2D)
            {
                Z = /*as3hx.Compat.parseFloat*/(msg.arguments[index++]);
            }
            
            if (!isCur)
            {
                A = /*as3hx.Compat.parseFloat*/(msg.arguments[index++]);
                if (msg.address.indexOf("/tuio/3D") == 0)
                {
                    B = /*as3hx.Compat.parseFloat*/(msg.arguments[index++]);
                    C = /*as3hx.Compat.parseFloat*/(msg.arguments[index++]);
                }
            }
            
            m = /*as3hx.Compat.parseFloat*/(msg.arguments[index++]);
            
            if (!isCur)
            {
                r = /*as3hx.Compat.parseFloat*/(msg.arguments[index++]);
            }
            
            //generate object
            
            var type : String = msg.address.substring(6, msg.address.length);
            
            var tuioContainer : TuioContainer = null;
            
            if (isCur)
            {
                tuioContainerList = this._tuioCursors[this.src];
            }
            else if (isObj)
            {
                tuioContainerList = this._tuioObjects[this.src];
            }
            else if (isBlb)
            {
                tuioContainerList = this._tuioBlobs[this.src];
            }
            else
            {
                return;
            }
            
            //resolve if add or update
            for (tc in tuioContainerList)
            {
                if (tc.sessionID == s)
                {
                    tuioContainer = tc;
                    break;
                }
            }
            
		//PERFORMANCE MEASUREMENT - before this point 10 fingers increase GC to 625ms, code grows to 510ms (that's 54% and 65% of the whole process);

            if (tuioContainer == null)
            {
                if (isCur)
                {
                    tuioContainer = new TuioCursor(type, s, x, y, z, X, Y, Z, m, this.fseq, this.src);
                    this._tuioCursors[this.src].push(tuioContainer);
                    dispatchAddCursor(try cast(tuioContainer, TuioCursor) catch(e:Dynamic) null);
                }
                else if (isObj)
                {
                    tuioContainer = new TuioObject(type, s, i, x, y, z, a, b, c, X, Y, Z, A, B, C, m, r, this.fseq, this.src);
                    this._tuioObjects[this.src].push(tuioContainer);
                    dispatchAddObject(try cast(tuioContainer, TuioObject) catch(e:Dynamic) null);
                }
                else if (isBlb)
                {
                    tuioContainer = new TuioBlob(type, s, x, y, z, a, b, c, w, h, d, f, v, X, Y, Z, A, B, C, m, r, this.fseq, this.src);
                    this._tuioBlobs[this.src].push(tuioContainer);
                    dispatchAddBlob(try cast(tuioContainer, TuioBlob) catch(e:Dynamic) null);
                }
                else
                {
                    return;
                }
            }
            else if (isCur)
            {
                (try cast(tuioContainer, TuioCursor) catch(e:Dynamic) null).update(x, y, z, X, Y, Z, m, this.fseq);
                dispatchUpdateCursor(try cast(tuioContainer, TuioCursor) catch(e:Dynamic) null);
            }
            else if (isObj)
            {
                (try cast(tuioContainer, TuioObject) catch(e:Dynamic) null).update(x, y, z, a, b, c, X, Y, Z, A, B, C, m, r, this.fseq);
                dispatchUpdateObject(try cast(tuioContainer, TuioObject) catch(e:Dynamic) null);
            }
            else if (isBlb)
            {
                (try cast(tuioContainer, TuioBlob) catch(e:Dynamic) null).update(x, y, z, a, b, c, w, h, d, f, v, X, Y, Z, A, B, C, m, r, this.fseq);
                dispatchUpdateBlob(try cast(tuioContainer, TuioBlob) catch(e:Dynamic) null);
            }
            else
            {
                return;
            }
        }
        else if (msg.arguments[0] == "fseq")
        {
            var newFseq : Int = Std.int(msg.arguments[1]);
            if (newFseq != this.fseq)
            {
                dispatchNewFseq();
                this.fseq = newFseq;
                //as fseq should be the last message in a TUIO bundle, the source is reset to DEFAULT_SOURCE
                this.src = AbstractTuioAdapter.DEFAULT_SOURCE;
            }
        }
    }
    /**
		 * @return The last received fseq value by the tracker.
		 */
    private function get_currentFseq() : Int
    {
        return this.fseq;
    }
    
    /**
		 * @return The last received source specification by the tracker.
		 */
    private function get_currentSource() : String
    {
        return this.src;
    }
    
    private function dispatchNewFseq() : Void
    {
        for (l in this.listeners)
        {
            l.newFrame(this.fseq);
        }
    }
}


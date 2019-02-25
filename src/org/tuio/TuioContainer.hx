package org.tuio;


/**
	 * This is a generic class that contains values present in every profile specified in TUIO 1.1
	 * 
	 * @author Immanuel Bauer
	 */
class TuioContainer
{
    public var type(get, never) : String;
    public var sessionID(get, never) : Int;
    public var x(get, never) : Float;
    public var y(get, never) : Float;
    public var z(get, never) : Float;
    public var X(get, never) : Float;
    public var Y(get, never) : Float;
    public var Z(get, never) : Float;
    public var m(get, never) : Float;
    public var frameID(get, never) : Int;
    public var source(get, never) : String;

    
    /** @private */
    @:allow(org.tuio)
    private var _sessionID : Int;
    /** @private */
    @:allow(org.tuio)
    private var _x : Float;
    /** @private */
    @:allow(org.tuio)
    private var _y : Float;
    /** @private */
    @:allow(org.tuio)
    private var _z : Float;
    /** @private */
    @:allow(org.tuio)
    private var _X : Float;
    /** @private */
    @:allow(org.tuio)
    private var _Y : Float;
    /** @private */
    @:allow(org.tuio)
    private var _Z : Float;
    /** @private */
    @:allow(org.tuio)
    private var _m : Float;
    /** @private */
    @:allow(org.tuio)
    private var _type : String;
    /** @private */
    @:allow(org.tuio)
    private var _frameID : Int;
    /** @private */
    @:allow(org.tuio)
    private var _source : String;
    
    public var isAlive : Bool;
    
    public function new(type : String, sID : Float, x : Float, y : Float, z : Float, X : Float, Y : Float, Z : Float, m : Float, frameID : Int, source : String)
    {
        this._type = type;
        this._sessionID = Std.int(sID);
        this._x = x;
        this._y = y;
        this._z = z;
        this._X = X;
        this._Y = Y;
        this._Z = Z;
        this._m = m;
        this._frameID = frameID;
        this._source = source;
        this.isAlive = true;
    }
    
    private function get_type() : String
    {
        return this._type;
    }
    
    private function get_sessionID() : Int
    {
        return this._sessionID;
    }
    
    private function get_x() : Float
    {
        return this._x;
    }
    
    private function get_y() : Float
    {
        return this._y;
    }
    
    private function get_z() : Float
    {
        return this._z;
    }
    
    private function get_X() : Float
    {
        return this._X;
    }
    
    private function get_Y() : Float
    {
        return this._Y;
    }
    
    private function get_Z() : Float
    {
        return this._Z;
    }
    
    private function get_m() : Float
    {
        return this._m;
    }
    
    private function get_frameID() : Int
    {
        return this._frameID;
    }
    
    private function get_source() : String
    {
        return this._source;
    }

    public function flip():Void
    {
        _x = 1-_x;
        _y = 1-_y;
    }
}



package org.tuio;


/**
	 * This class represents a TuioObject as specified in TUIO 1.1
	 * 
	 * @author Immanuel Bauer
	 */
class TuioObject extends TuioContainer
{
    public var classID(get, set) : Int;
    public var a(get, never) : Float;
    public var b(get, never) : Float;
    public var c(get, never) : Float;
    public var A(get, never) : Float;
    public var B(get, never) : Float;
    public var C(get, never) : Float;
    public var r(get, never) : Float;

    
    private var _id : Int;
    private var _a : Float;
    private var _b : Float;
    private var _c : Float;
    private var _A : Float;
    private var _B : Float;
    private var _C : Float;
    private var _r : Float;
    
    public function new(type : String, sID : Float, i : Float, x : Float, y : Float, z : Float, a : Float, b : Float, c : Float, X : Float, Y : Float, Z : Float, A : Float, B : Float, C : Float, m : Float, r : Float, frameID : Int, source : String)
    {
        super(type, sID, x, y, z, X, Y, Z, m, frameID, source);
        
        this._id = Std.int(i);
        this._a = a;
        this._b = b;
        this._c = c;
        this._A = A;
        this._B = B;
        this._C = C;
        this._r = r;
    }
    
    /**
		 * Updates the values of the TuioObject
		 */
    public function update(x : Float, y : Float, z : Float, a : Float, b : Float, c : Float, X : Float, Y : Float, Z : Float, A : Float, B : Float, C : Float, m : Float, r : Float, frameID : Int) : Void
    {
        this._x = x;
        this._y = y;
        this._z = z;
        this._X = X;
        this._Y = Y;
        this._Z = Z;
        this._m = m;
        
        this._a = a;
        this._b = b;
        this._c = c;
        this._A = A;
        this._B = B;
        this._C = C;
        this._r = r;
        
        this._frameID = frameID;
    }
    
    private function get_classID() : Int
    {
        return this._id;
    }
    
    private function set_classID(value:Int) : Int
    {
        return this._id = value;
    }
    
    private function get_a() : Float
    {
        return this._a;
    }
    
    private function get_b() : Float
    {
        return this._b;
    }
    
    private function get_c() : Float
    {
        return this._c;
    }
    
    private function get_A() : Float
    {
        return this._A;
    }
    
    private function get_B() : Float
    {
        return this._B;
    }
    
    private function get_C() : Float
    {
        return this._C;
    }
    
    private function get_r() : Float
    {
        return this._r;
    }
    
    /**
		 * This function converts the TuioObject's values into a String for output purposes
		 */
    public function toString() : String
    {
        var out : String = "";
        out += "TuioObject(";
        out += "type: " + this._type;
        out += ", sessionID: " + this._sessionID;
        out += ", classID: " + this._id;
        out += ", x: " + this._x;
        out += ", y: " + this._y;
        out += ", z: " + this._z;
        out += ", a: " + this._a;
        out += ", b: " + this._b;
        out += ", c: " + this._c;
        out += ", X: " + this._X;
        out += ", Y: " + this._Y;
        out += ", Z: " + this._Z;
        out += ", A: " + this._A;
        out += ", B: " + this._B;
        out += ", C: " + this._C;
        out += ", m: " + this._m;
        out += ", r: " + this._r;
        out += ")";
        
        return out;
    }
    
    /**
		 * Creates a new <code>TuioObject</code> instance containing the same values
		 * @return The cloned object
		 */
    public function clone() : TuioObject
    {
        return new TuioObject(_type, _sessionID, _id, _x, _y, _z, _a, _b, _c, _X, _Y, _Z, _A, _B, _C, _m, _r, _frameID, _source);
    }
}


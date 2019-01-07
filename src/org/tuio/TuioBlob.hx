package org.tuio;


/**
	 * This class represents a TuioBlob as specified in TUIO 1.1
	 * 
	 * @author Immanuel Bauer
	 */
class TuioBlob extends TuioContainer
{
    public var a(get, never) : Float;
    public var b(get, never) : Float;
    public var c(get, never) : Float;
    public var w(get, never) : Float;
    public var h(get, never) : Float;
    public var d(get, never) : Float;
    public var f(get, never) : Float;
    public var v(get, never) : Float;
    public var A(get, never) : Float;
    public var B(get, never) : Float;
    public var C(get, never) : Float;
    public var r(get, never) : Float;

    
    private var _a : Float;
    private var _b : Float;
    private var _c : Float;
    private var _w : Float;
    private var _h : Float;
    private var _d : Float;
    private var _f : Float;
    private var _v : Float;
    private var _A : Float;
    private var _B : Float;
    private var _C : Float;
    private var _r : Float;
    
    public function new(type : String, sID : Float, x : Float, y : Float, z : Float, a : Float, b : Float, c : Float, w : Float, h : Float, d : Float, f : Float, v : Float, X : Float, Y : Float, Z : Float, A : Float, B : Float, C : Float, m : Float, r : Float, frameID : Int, source : String)
    {
        super(type, sID, x, y, z, X, Y, Z, m, frameID, source);
        
        this._a = a;
        this._b = b;
        this._c = c;
        this._w = w;
        this._h = h;
        this._d = d;
        this._f = f;
        this._v = v;
        this._A = A;
        this._B = B;
        this._C = C;
        this._r = r;
        
        this._frameID;
    }
    
    /**
		 * Updates the values of the TuioBlob
		 */
    public function update(x : Float, y : Float, z : Float, a : Float, b : Float, c : Float, w : Float, h : Float, d : Float, f : Float, v : Float, X : Float, Y : Float, Z : Float, A : Float, B : Float, C : Float, m : Float, r : Float, frameID : Int) : Void
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
        this._w = w;
        this._h = h;
        this._d = d;
        this._f = f;
        this._v = v;
        this._A = A;
        this._B = B;
        this._C = C;
        this._r = r;
        
        this._frameID = frameID;
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
    
    private function get_w() : Float
    {
        return this._w;
    }
    
    private function get_h() : Float
    {
        return this._h;
    }
    
    private function get_d() : Float
    {
        return this._d;
    }
    
    private function get_f() : Float
    {
        return this._f;
    }
    
    private function get_v() : Float
    {
        return this._v;
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
		 * This function converts the TuioBlob's values into a String for output purposes
		 */
    public function toString() : String
    {
        var out : String = "";
        out += "TuioBlob(";
        out += "type: " + this._type;
        out += ", sessionID: " + this._sessionID;
        out += ", x: " + this._x;
        out += ", y: " + this._y;
        out += ", z: " + this._z;
        out += ", a: " + this._a;
        out += ", b: " + this._b;
        out += ", c: " + this._c;
        out += ", w: " + this._w;
        out += ", h: " + this._h;
        out += ", d: " + this._d;
        out += ", v: " + this._v;
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
}


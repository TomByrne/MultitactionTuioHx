package multitaction.utils;

class GeomTools
{
	inline public static function dist(x1:Float, y1:Float, x2:Float, y2:Float):Float 
	{
		var xDif:Float = x1 - x2;
		var yDif:Float = y1 - y2;
		return hypotonuse(xDif, yDif);
	}
	inline public static function hypotonuse(w:Float, h:Float):Float
	{
		return Math.sqrt(w*w + h*h);
	}
}
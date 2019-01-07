package org.tuio.debug;

import flash.display.Sprite;

/**
	 * <p>Default implementation of the debug cursor circle that is being shown by <code>TuioDebug</code> for
	 * each tuio cursor.</p>
	 * 
	 * <p><code>TuioDebugCursor</code> implements <code>ITuioDebugCursor</code> in order to be marked as debug
	 * information and not as the content of the actual application. This is necessary for the event dispatching
	 * mechanism in <code>TuioManager</code>.</p>
	 *  
	 * @see ITuioDebugCursor
	 *   
	 * @author Johannes Luderschmidt
	 * 
	 */
class TuioDebugCursor extends Sprite implements ITuioDebugCursor
{
    public var sessionId(get, set) : Int;
    public var source(get, set) : String;

    private var _sessionId : Int;
    private var _source : String;
    
    /**
		 * 
		 * @param radius of the debug circle.
		 * @param color of the circle's fill.
		 * @param alpha of the circle's fill.
		 * @param lineThickness thickness of the line around the circle.
		 * @param lineColor color of the line around the circle.
		 * @param lineAlpha alpha of the line around the circle.
		 * 
		 */
    public function new(radius : Float, color : Float, alpha : Float, lineThickness : Float, lineColor : Float, lineAlpha : Float)
    {
        super();
        adjustGraphics(radius, color, alpha, lineThickness, lineColor, lineAlpha);
    }
    
    
    /**
		 * carries out the Graphics drawing.
		 * 
		 * @param radius of the debug circle.
		 * @param color of the circle's fill.
		 * @param alpha of the circle's fill.
		 * @param lineThickness thickness of the line around the circle.
		 * @param lineColor color of the line around the circle.
		 * @param lineAlpha alpha of the line around the circle.
		 * 
		 */
    public function adjustGraphics(radius : Float, color : Float, alpha : Float, lineThickness : Float, lineColor : Float, lineAlpha : Float) : Void
    {
        this.graphics.beginFill( Std.int(color), alpha);
        this.graphics.lineStyle(lineThickness, lineColor, lineAlpha);
        this.graphics.drawCircle(0, 0, radius);
        this.graphics.endFill();
    }
    
    
    private function get_sessionId() : Int
    {
        return _sessionId;
    }
    
    private function set_sessionId(sessionId : Int) : Int
    {
        this._sessionId = sessionId;
        return sessionId;
    }
    
    private function get_source() : String
    {
        return this._source;
    }
    private function set_source(source : String) : String
    {
        this._source = source;
        return source;
    }
}

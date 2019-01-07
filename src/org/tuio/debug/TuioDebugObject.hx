package org.tuio.debug;

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

/**
	 * <p>Default implementation of the debug object square that is being shown by <code>TuioDebug</code> for
	 * each tuio object.</p>
	 * 
	 * <p><code>TuioDebugObject</code> implements <code>ITuioDebugObject</code> in order to be marked as debug
	 * information and not as the content of the actual application. This is necessary for the event dispatching
	 * mechanism in <code>TuioManager</code>.</p>
	 *  
	 * @see ITuioDebugObject
	 *   
	 * @author Johannes Luderschmidt
	 * 
	 */
class TuioDebugObject extends Sprite implements ITuioDebugObject
{
    public var sessionId(get, set) : Int;
    public var fiducialId(get, set) : Int;
    public var objectRotation(get, set) : Float;
    public var source(get, set) : String;

    private var _sessionId : Int;
    private var _fiducialId : Int;
    private var _objectRotation : Float;
    private var _source : String;
    
    /**
		 * 
		 * @param objectId fiducial id
		 * @param width of the square
		 * @param height of the square
		 * @param color of the square's fill.
		 * @param alpha of the square's fill.
		 * @param lineThickness thickness of the line around the square.
		 * @param lineColor color of the line around the square.
		 * @param lineAlpha alpha of the line around the square.
		 * 
		 */
    public function new(fiducialId : Float, sessionId : Float, objectRotation : Float, width : Float, height : Float, color : Float, alpha : Float, lineThickness : Float, lineColor : Float, lineAlpha : Float, source : String)
    {
        super();
        this.sessionId = Std.int(sessionId);
        this.fiducialId = Std.int(fiducialId);
        this.objectRotation = objectRotation;
        this.source = source;
        adjustGraphics(fiducialId, width, height, Std.int(color), alpha, lineThickness, lineColor, lineAlpha);
    }
    
    /**
		 * draws the Graphics.
		 * 
		 * @param objectId fiducial id
		 * @param width of the square
		 * @param height of the square
		 * @param color of the square's fill.
		 * @param alpha of the square's fill.
		 * @param lineThickness thickness of the line around the square.
		 * @param lineColor color of the line around the square.
		 * @param lineAlpha alpha of the line around the square.
		 * 
		 */
    public function adjustGraphics(objectId : Float, width : Float, height : Float, color : UInt, alpha : Float, lineThickness : Float, lineColor : Float, lineAlpha : Float) : Void
    //draw object rect
    {
        
        this.graphics.clear();
        this.graphics.beginFill(color, alpha);
        this.graphics.lineStyle(lineThickness, lineColor, lineAlpha);
        this.graphics.drawRect(-0.5 * width, -0.5 * height, width, height);
        this.graphics.endFill();
        
        //draw direction line
        this.graphics.lineStyle(3, 0x0, 1);
        this.graphics.moveTo(0, 0);
        this.graphics.lineTo(0, -0.5 * height + 5);
        
        //draw objectid label
        var fiducialIdLabel : TextField = new TextField();
        fiducialIdLabel.autoSize = TextFieldAutoSize.LEFT;
        fiducialIdLabel.background = false;
        fiducialIdLabel.border = false;
        fiducialIdLabel.text = "" + objectId;
        fiducialIdLabel.width / 2 + 5;
        fiducialIdLabel.defaultTextFormat = fiducialIdTextFormat();
        fiducialIdLabel.setTextFormat(fiducialIdTextFormat());
        
        var translationX : Float = -0.5 * width + 0.5 * fiducialIdLabel.width;
        var translationY : Float = 0.5 * height - 0.5 * fiducialIdLabel.height;
        //copy TextField into a bitmap
        var typeTextBitmap : BitmapData = new BitmapData(Std.int(fiducialIdLabel.width), 
        Std.int(fiducialIdLabel.height), true, 0x00000000);
        typeTextBitmap.draw(fiducialIdLabel);
        
        //calculate center of TextField
        var typeTextTranslationX : Float = -0.5 * fiducialIdLabel.width + translationX + 5;
        var typeTextTranslationY : Float = -0.5 * fiducialIdLabel.height + translationY - 5;
        
        //create Matrix which moves the TextField to the center
        var matrix : Matrix = new Matrix();
        matrix.translate(typeTextTranslationX, typeTextTranslationY);
        
        //actually draw the text on the stage (with no-repeat and anti-aliasing)
        this.graphics.beginBitmapFill(typeTextBitmap, matrix, false, true);
        this.graphics.lineStyle(0, 0, 0);
        this.graphics.drawRect(typeTextTranslationX, typeTextTranslationY, 
                fiducialIdLabel.width, fiducialIdLabel.height
        );
        this.graphics.endFill();
    }
    
    private function fiducialIdTextFormat() : TextFormat
    {
        var format : TextFormat = new TextFormat();
        format.font = "Arial";
        format.color = 0xffffff;
        format.size = 11;
        format.underline = false;
        
        return format;
    }
    
    private function get_sessionId() : Int
    {
        return this._sessionId;
    }
    private function set_sessionId(sessionId : Int) : Int
    {
        this._sessionId = sessionId;
        return sessionId;
    }
    private function get_fiducialId() : Int
    {
        return _fiducialId;
    }
    private function set_fiducialId(fiducialId : Int) : Int
    {
        this._fiducialId = fiducialId;
        return fiducialId;
    }
	#if html5
    override private function set_rotation(value : Float) : Float
	#elseif air
    private function set_rotation(value : Float) : Float
	#end
    {
        super.rotation = value;
        this.objectRotation = value / 180 * Math.PI;
        return value;
    }
    private function get_objectRotation() : Float
    {
        return this._objectRotation;
    }
    private function set_objectRotation(objectRotation : Float) : Float
    {
        this._objectRotation = objectRotation;
        return objectRotation;
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

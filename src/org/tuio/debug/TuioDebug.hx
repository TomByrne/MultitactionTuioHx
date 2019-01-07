package org.tuio.debug;

import flash.errors.Error;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.display.Stage;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import org.tuio.*;

/**
	 * 
	 * <p>implements the interface <code>ITuioListener</code> to show debug information about all tuio cursors and objects 
	 * that are prevailing in the application.</p>
	 * 
	 * <p>The appearance of the cursors and objects is controlled by the classes <code>TuioDebugCursor</code> and 
	 * <code>TuioDebugObject</code>. Their appearance can be tweaked with multiple settings. Additionally, custom debug cursor 
	 * and object implementations can be set via the functions <code>customCursorSprite</code> and <code>customObjectClass</code>.</p> 
	 * 
	 * @see org.tuio.ITuioListener
	 * @see TuioDebugCursor
	 * @see ITuioDebugCursor
	 * @see TuioDebugObject
	 * @see ITuioDebugObject
	 * 
	 * @author Johannes Luderschmidt
	 * 
	 */
class TuioDebug implements ITuioListener
{
    public var objectWidth(get, set) : Float;
    public var objectHeight(get, set) : Float;
    public var objectColor(get, set) : Float;
    public var objectAlpha(get, set) : Float;
    public var objectLineThickness(get, set) : Float;
    public var objectLineColor(get, set) : Float;
    public var objectLineAlpha(get, set) : Float;
    public var customObjectClass(get, set) : Class<Dynamic>;
    public var cursorRadius(get, set) : Float;
    public var cursorColor(get, set) : Float;
    public var cursorAlpha(get, set) : Float;
    public var cursorLineThickness(get, set) : Float;
    public var cursorLineColor(get, set) : Float;
    public var cursorLineAlpha(get, set) : Float;
    public var showDebugText(get, set) : Bool;
    public var customCursorSprite(get, set) : Class<Dynamic>;
    public var showCursors(get, set) : Bool;
    public var showObjects(get, set) : Bool;

    
    //@:meta(Embed(source="/org/tuio/assets/fonts.swf",fontName="Arial"))

    private var Arial : Class<Dynamic>;
    private var arialFont : Font;
    
    private var stage : Stage;
    private var tuioClient : TuioClient;
    
    private var fseq : Int;
    
    private var cursors : Array<Dynamic>;
    private var objects : Array<Dynamic>;
    private var blobs : Array<Dynamic>;
    
    private var _showCursors : Bool = true;
    private var _showObjects : Bool = true;
    private var _showBlobs : Bool = true;
    
    private var _showDebugText : Bool = true;
    
    private var _cursorRadius : Float = 13;
    private var _cursorColor : Float = 0x0;
    private var _cursorAlpha : Float = 0;
    private var _cursorLineThickness : Float = 3;
    private var _cursorLineColor : Float = 0x0;
    private var _cursorLineAlpha : Float = 0.5;
    private var _customCursorSprite : Class<Dynamic>;
    
    private var _objectWidth : Float = 80;
    private var _objectHeight : Float = 80;
    private var _objectColor : Float = 0x0;
    private var _objectAlpha : Float = 0.5;
    private var _objectLineThickness : Float = 0;
    private var _objectLineColor : Float = 0x0;
    private var _objectLineAlpha : Float = 0;
    private var _customObjectClass : Class<Dynamic>;
    
    private static var allowInst : Bool = true;
    private static var inst : TuioDebug;
    
    public function new(stage : Stage)
    {
		/*
        if (!allowInst)
        {
            throw new Error("Error: Instantiation failed: Use TuioDebug.getInstance() instead of new.");
        }
        else
        {*/
            this.stage = stage;
            fseq = 0;
            cursors = new Array<Dynamic>();
            objects = new Array<Dynamic>();
            blobs = new Array<Dynamic>();
            
            _customObjectClass = TuioDebugObject;
            _customCursorSprite = TuioDebugCursor;
            
            //this.arialFont = Type.createInstance(Arial, []);
			/*
        }
        if (inst == null)
        {
            allowInst = true;
            inst = new TuioDebug(stage);
            allowInst = false;
        }
		*/
    }
    
    /**
		 * initializes Singleton instance of TuioDebug. Must be called before <code>getInstance()</code> 
		 * can be called.
		 *  
		 * @param stage
		 * @return Singleton instance of TuioDebug.
		 * 
		 */
	/*
    public static function init(stage : Stage) : TuioDebug
    {
        return inst;
    }
	*/
    
    /**
		 * Singleton instance of TuioDebug.
		 * 
		 * @return Singleton instance of TuioDebug.
		 * 
		 */
	/*
    public static function getInstance() : TuioDebug
    {
        if (inst == null)
        {
            throw new Error("Please initialize with method init(...) first!");
        }
        return inst;
    }
    */
    /**
		 * Called if a new object was tracked.
		 * @param	tuioObject the received /tuio/2Dobj.
		 */
    public function addTuioObject(tuioObject : TuioObject) : Void
    {
        addTuioObjectWithDebugOption(tuioObject, false);
    }
    
    /**
		 * creates actual debug representation of TUIO object and shows it on screen 
		 *  
		 * @param tuioObject the current TUIO object
		 * @param debugMode sets whether the TUIO id should be shown (debugMode == false) or 
		 * whether only the hint 'Debug' should be shown (debugMode == true) as the debug TUIO session id 
		 * starts  
		 * with the highest possible unsigned integer value and decrements for each other TUIO debug
		 * element in order to not interfere with regular TUIO session ids from a tracker or from
		 * the TUIO debug application. Thus, the high session ids would be looking awkwardly and only
		 * the 'Debug' string is being shown.
		 * 
		 */
    public function addTuioObjectWithDebugOption(tuioObject : TuioObject, debugMode : Bool) : Void
    {
        var objectSprite : Sprite;
        
        if (_customObjectClass == TuioDebugObject)
        {
            objectSprite = new TuioDebugObject(tuioObject.classID, tuioObject.sessionID, tuioObject.a, _objectWidth, _objectHeight, _objectColor, _objectAlpha, _objectLineThickness, _objectLineColor, _objectLineAlpha, tuioObject.source);
        }
        else
        {
            objectSprite = Type.createInstance(_customObjectClass, [tuioObject]);
            if (!(Std.is(objectSprite, ITuioDebugObject)))
            {
                throw new Error("Custom Tuio Object class must implement ITuioDebugObject.");
            }
        }
        var objectObject : Dynamic = {};
        if (_showObjects)
        {
            objectSprite.x = tuioObject.x * stage.stageWidth;
            objectSprite.y = tuioObject.y * stage.stageHeight;
            
            objectSprite.rotation = tuioObject.a / Math.PI * 180;
            
            objectObject.object = objectSprite;
            objectObject.sessionID = tuioObject.sessionID;
            objectObject.source = tuioObject.source;
            objects.push(objectObject);
            stage.addChild(objectSprite);
            
            if (_showDebugText)
            {
                var label : TextField = new TextField();
                label.autoSize = TextFieldAutoSize.LEFT;
                label.selectable = false;
                label.background = false;
                label.border = false;
                label.text = generateObjectLabelText(objectSprite.x, objectSprite.y, tuioObject.classID, tuioObject.sessionID, debugMode);
                
                label.defaultTextFormat = debugTextFormat();
                label.setTextFormat(debugTextFormat());
                label.embedFonts = true;
                
                objectSprite.addChild(label);
                label.x = Math.round(_objectWidth / 2);
                label.y = -Math.round(label.height / 2);
                
                objectObject.label = label;
            }
        }
    }
    
    /**
		 * updates the display of the TUIO debug object
		 * 
		 * @param	tuioObject The received /tuio/2Dobj.
		 */
    public function updateTuioObject(tuioObject : TuioObject) : Void
    {
        updateTuioObjectWithDebugOption(tuioObject, false);
    }
    
    /**
		 * updates the display of the TUIO debug object.
		 *  
		 * @param tuioObject The received /tuio/2Dobj.
		 * @param debugMode sets whether the TUIO id should be shown (debugMode == false) or 
		 * whether only the hint 'Debug' should be shown (debugMode == true) as the debug TUIO session id 
		 * starts  
		 * with the highest possible unsigned integer value and decrements for each other TUIO debug
		 * element in order to not interfere with regular TUIO session ids from a tracker or from
		 * the TUIO debug application. Thus, the high session ids would be looking awkwardly and only
		 * the 'Debug' string is being shown.
		 * 
		 */
    public function updateTuioObjectWithDebugOption(tuioObject : TuioObject, debugMode : Bool) : Void
    {
        for (object in objects)
        {
            if (object.sessionID == tuioObject.sessionID)
            {
                var debugObject : DisplayObjectContainer = try cast(object.object, DisplayObjectContainer) catch(e:Dynamic) null;
                debugObject.x = tuioObject.x * stage.stageWidth;
                debugObject.y = tuioObject.y * stage.stageHeight;
                debugObject.rotation = tuioObject.a / Math.PI * 180;
                if (_showDebugText)
                {
                    object.label.text = generateObjectLabelText(object.object.x, object.object.y, tuioObject.classID, tuioObject.sessionID, debugMode);
                    object.label.setTextFormat(debugTextFormat());
                }
                break;
            }
        }
    }
    
    /**
		 * Called if a tracked object was removed.
		 * 
		 * @param	tuioObject The values of the received /tuio/2Dobj.
		 */
    public function removeTuioObject(tuioObject : TuioObject) : Void
    {
        var i : Int = 0;
        for (object in objects)
        {
            if (object.sessionID == tuioObject.sessionID)
            {
                stage.removeChild(object.object);
                objects.splice(i, 1);
                break;
            }
            i = i + 1;
        }
    }
    
    /**
		 * width of debug object rectangle.
		 * 
		 */
    private function get_objectWidth() : Float
    {
        return _objectWidth;
    }
    private function set_objectWidth(objectWidth : Float) : Float
    {
        _objectWidth = objectWidth;
        return objectWidth;
    }
    
    
    /**
		 * height of debug object rectangle. 
		 * 
		 */
    private function get_objectHeight() : Float
    {
        return _objectHeight;
    }
    private function set_objectHeight(objectHeight : Float) : Float
    {
        _objectHeight = objectHeight;
        return objectHeight;
    }
    
    
    /**
		 * color of the filling of debug object rectangle.
		 *  
		 */
    private function get_objectColor() : Float
    {
        return _objectColor;
    }
    private function set_objectColor(objectColor : Float) : Float
    {
        _objectColor = objectColor;
        return objectColor;
    }
    
    /**
		 * alpha of the filling of debug object rectangle. 
		 * 
		 */
    private function get_objectAlpha() : Float
    {
        return _objectAlpha;
    }
    private function set_objectAlpha(objectAlpha : Float) : Float
    {
        _objectAlpha = objectAlpha;
        return objectAlpha;
    }
    
    /**
		 * thickness of the line around a debug object rectangle.
		 *  
		 */
    private function get_objectLineThickness() : Float
    {
        return _objectLineThickness;
    }
    private function set_objectLineThickness(objectLineThickness : Float) : Float
    {
        _objectLineThickness = objectLineThickness;
        return objectLineThickness;
    }
    
    /**
		 * color of the line around a debug object rectangle.
		 *  
		 */
    private function get_objectLineColor() : Float
    {
        return _objectLineColor;
    }
    private function set_objectLineColor(objectLineColor : Float) : Float
    {
        _objectLineColor = objectLineColor;
        return objectLineColor;
    }
    
    /**
		 * alpha of the line around a debug object rectangle.
		 *  
		 */
    private function get_objectLineAlpha() : Float
    {
        return _objectLineAlpha;
    }
    private function set_objectLineAlpha(objectLineAlpha : Float) : Float
    {
        _objectLineAlpha = objectLineAlpha;
        return objectLineAlpha;
    }
    
    /**
		 * sets base class for the Sprite that should be drawn on screen when a new
		 * object is added via a Tuio message.
		 *  
		 */
    private function get_customObjectClass() : Class<Dynamic>
    {
        return _customObjectClass;
    }
    private function set_customObjectClass(customObjectClass : Class<Dynamic>) : Class<Dynamic>
    {
        _customObjectClass = customObjectClass;
        return customObjectClass;
    }
    
    /**
		 * Called if a new cursor was tracked.
		 * @param	tuioObject The values of the received /tuio/**Dcur.
		 */
    public function addTuioCursor(tuioCursor : TuioCursor) : Void
    {
        var cursorSprite : Sprite;
        
        if (_customCursorSprite == TuioDebugCursor)
        {
            cursorSprite = new TuioDebugCursor(_cursorRadius, _cursorColor, _cursorAlpha, _cursorLineThickness, _cursorLineColor, _cursorLineAlpha);
        }
        else
        {
            try
            {
                cursorSprite = Type.createInstance(_customCursorSprite, [tuioCursor]);
            }
            catch (error : Error)
            {
                cursorSprite = Type.createInstance(_customCursorSprite, []);
            }
            if (!(Std.is(cursorSprite, ITuioDebugCursor)))
            {
                throw new Error("Custom Tuio Debug Cursor class must implement ITuioDebugCursor.");
            }
        }
        (try cast(cursorSprite, ITuioDebugCursor) catch(e:Dynamic) null).sessionId = tuioCursor.sessionID;
        (try cast(cursorSprite, ITuioDebugCursor) catch(e:Dynamic) null).source = tuioCursor.source;
        
        var cursorObject : Dynamic = {};
        
        if (_showCursors)
        {
            cursorSprite.x = tuioCursor.x * stage.stageWidth;
            cursorSprite.y = tuioCursor.y * stage.stageHeight;
            cursorObject.cursor = cursorSprite;
            cursorObject.sessionID = tuioCursor.sessionID;
            cursorObject.source = tuioCursor.source;
            cursors.push(cursorObject);
            stage.addChild(cursorSprite);
            
            if (_showDebugText)
            {
                var label : TextField = new TextField();
                label.autoSize = TextFieldAutoSize.LEFT;
                label.selectable = false;
                label.background = false;
                label.border = false;
                label.text = generateCursorLabelText(cursorSprite.x, cursorSprite.y, tuioCursor.sessionID, tuioCursor.source);
                
                label.defaultTextFormat = debugTextFormat();
                label.setTextFormat(debugTextFormat());
                label.embedFonts = true;
                
                cursorSprite.addChild(label);
                label.x = _cursorRadius + 3;
                label.y = -Math.round(label.height / 2);
                
                cursorObject.label = label;
            }
        }
    }
    
    /**
		 * Called if a tracked cursor was updated.
		 * @param	tuioCursor The values of the received /tuio/2Dcur.
		 */
    public function updateTuioCursor(tuioCursor : TuioCursor) : Void
    {
        for (cursor in cursors)
        {
            if (cursor.sessionID == tuioCursor.sessionID && cursor.source == tuioCursor.source)
            {
                cursor.cursor.x = tuioCursor.x * stage.stageWidth;
                cursor.cursor.y = tuioCursor.y * stage.stageHeight;
                
                if (_showDebugText)
                {
                    cursor.label.text = generateCursorLabelText(cursor.cursor.x, cursor.cursor.y, tuioCursor.sessionID, tuioCursor.source);
                }
                break;
            }
        }
    }
    
    /**
		 * Called if a tracked cursor was removed.
		 * @param	tuioCursor The values of the received /tuio/2Dcur.
		 */
    public function removeTuioCursor(tuioCursor : TuioCursor) : Void
    {
        var i : Int = 0;
        for (cursor in cursors)
        {
            if (cursor.sessionID == tuioCursor.sessionID && cursor.source == tuioCursor.source)
            {
                stage.removeChild(cursor.cursor);
                cursors.splice(i, 1);
                break;
            }
            i = i + 1;
        }
    }
    
    private function generateCursorLabelText(xVal : Float, yVal : Float, id : Float, source : String) : String
    {
        var cursorLabel : String;
        cursorLabel = "x: " + xVal + "\ny: " + yVal + "\nsessionId: " + id + "\nsource: " + source;
        return cursorLabel;
    }
    
    private function debugTextFormat() : TextFormat
    {
        var format : TextFormat = new TextFormat();
        format.font = "_typewriter";
        format.color = 0x0;
        format.size = 11;
        format.underline = false;
        
        return format;
    }
    
    /**
		 * Called if a new blob was tracked.
		 * @param	tuioBlob The values of the received /tuio/**Dblb.
		 */
    public function addTuioBlob(tuioBlob : TuioBlob) : Void
    {
        if (_showBlobs)
        {
            _showCursors = true;
            addTuioCursor(new TuioCursor("2dcur", tuioBlob.sessionID, tuioBlob.x, tuioBlob.y, tuioBlob.z, tuioBlob.X, tuioBlob.Y, tuioBlob.Z, tuioBlob.m, tuioBlob.frameID, "TuioDebug"));
        }
    }
    
    /**
		 * Called if a tracked blob was updated.
		 * @param	tuioBlob The values of the received /tuio/**Dblb.
		 */
    public function updateTuioBlob(tuioBlob : TuioBlob) : Void
    {
        if (_showBlobs)
        {
            _showCursors = true;
            updateTuioCursor(new TuioCursor("2dcur", tuioBlob.sessionID, tuioBlob.x, tuioBlob.y, tuioBlob.z, tuioBlob.X, tuioBlob.Y, tuioBlob.Z, tuioBlob.m, tuioBlob.frameID, "TuioDebug"));
        }
    }
    
    /**
		 * Called if a tracked blob was removed.
		 * @param	tuioBlob The values of the received /tuio/**Dblb.
		 */
    public function removeTuioBlob(tuioBlob : TuioBlob) : Void
    {
        if (_showBlobs)
        {
            _showCursors = true;
            removeTuioCursor(new TuioCursor("2dcur", tuioBlob.sessionID, tuioBlob.x, tuioBlob.y, tuioBlob.z, tuioBlob.X, tuioBlob.Y, tuioBlob.Z, tuioBlob.m, tuioBlob.frameID, "TuioDebug"));
        }
    }
    
    public function newFrame(id : Int) : Void
    {
        this.fseq = id;
    }
    
    private function generateObjectLabelText(xVal : Float, yVal : Float, objectId : Float, sessionId : Float, debugMode : Bool = false) : String
    {
        var objectLabel : String;
        if (!debugMode)
        {
            objectLabel = "x: " + xVal + "\ny: " + yVal + "\nfiducialId: " + objectId + "\nsessionId: " + sessionId;
        }
        else
        {
            objectLabel = "x: " + xVal + "\ny: " + yVal + "\nfiducialId: " + objectId + "\nsessionId: Debug";
        }
        return objectLabel;
    }
    
    /**
		 * radius of the debug cursor circle.
		 *  
		 */
    private function get_cursorRadius() : Float
    {
        return _cursorRadius;
    }
    private function set_cursorRadius(cursorRadius : Float) : Float
    {
        _cursorRadius = cursorRadius;
        return cursorRadius;
    }
    
    /**
		 * color of the filling of the debug cursor circle.
		 *  
		 */
    private function get_cursorColor() : Float
    {
        return _cursorColor;
    }
    private function set_cursorColor(cursorColor : Float) : Float
    {
        _cursorColor = cursorColor;
        return cursorColor;
    }
    
    /**
		 * alpha of the filling of the debug cursor circle.
		 *  
		 */
    private function get_cursorAlpha() : Float
    {
        return _cursorAlpha;
    }
    private function set_cursorAlpha(cursorAlpha : Float) : Float
    {
        _cursorAlpha = cursorAlpha;
        return cursorAlpha;
    }
    
    /**
		 * thickness of the line around a debug cursor circle.
		 * 
		 */
    private function get_cursorLineThickness() : Float
    {
        return _cursorLineThickness;
    }
    private function set_cursorLineThickness(cursorLineThickness : Float) : Float
    {
        _cursorLineThickness = cursorLineThickness;
        return cursorLineThickness;
    }
    
    /**
		 * color of the line around a debug cursor circle.
		 *  
		 */
    private function get_cursorLineColor() : Float
    {
        return _cursorLineColor;
    }
    private function set_cursorLineColor(cursorLineColor : Float) : Float
    {
        _cursorLineColor = cursorLineColor;
        return cursorLineColor;
    }
    
    /**
		 * alpha of the line around a debug cursor circle.
		 *  
		 */
    private function get_cursorLineAlpha() : Float
    {
        return _cursorLineAlpha;
    }
    private function set_cursorLineAlpha(cursorLineAlpha : Float) : Float
    {
        _cursorLineAlpha = cursorLineAlpha;
        return cursorLineAlpha;
    }
    
    /**
		 * controls whether debug text (session id, x position, y position and fiducial id) should be shown next to
		 * a debug cursor or debug object.
		 *   
		 * @param showDebugText 
		 * 
		 */
    private function set_showDebugText(showDebugText : Bool) : Bool
    {
        _showDebugText = showDebugText;
        return showDebugText;
    }
    
    private function get_showDebugText() : Bool
    {
        return _showDebugText;
    }
    
    /**
		 * sets base class for the Sprite that should be drawn on screen when a new
		 * cursor is added via a Tuio message.
		 *  
		 * @param customCursorSprite class name of class that should be used as debug cursor information.
		 * 
		 */
    private function set_customCursorSprite(customCursorSprite : Class<Dynamic>) : Class<Dynamic>
    {
        _customCursorSprite = customCursorSprite;
        return customCursorSprite;
    }
    
    /**
		 * returns base class of the Sprite that is being drawn on screen when a new
		 * cursor is added via a Tuio message.
		 *  
		 * @return class of debug cursor sprite. 
		 * 
		 */
    private function get_customCursorSprite() : Class<Dynamic>
    {
        return _customCursorSprite;
    }
    
    /**
		 * controls whether debug information for objects is shown. 
		 *   
		 * @param showCursors 
		 * 
		 */
    private function set_showCursors(showCursors : Bool) : Bool
    {
        _showCursors = showCursors;
        return showCursors;
    }
    private function get_showCursors() : Bool
    {
        return _showCursors;
    }
    
    /**
		 * controls whether debug information for objects is shown. 
		 *   
		 * @param showCursors 
		 * 
		 */
    private function set_showObjects(showObjects : Bool) : Bool
    {
        _showObjects = showObjects;
        return showObjects;
    }
    private function get_showObjects() : Bool
    {
        return _showObjects;
    }
}

package org.tuio.util;

import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.display.Stage;
import flash.geom.Point;
import org.tuio.debug.ITuioDebugBlob;
import org.tuio.debug.ITuioDebugCursor;
import org.tuio.debug.ITuioDebugObject;
import org.tuio.debug.ITuioDebugTextSprite;

/**
	 * This class provides static functions for display list traversals and lookups which are used internally.
	 */
class DisplayListHelper
{
    
    /**
		 * Finds the most top DisplayObject under a given point which is eanbled for user interaction.
		 */
    public static function getTopDisplayObjectUnderPoint(point : Point, stage : Stage) : DisplayObject
    {
        var targets : Array<Dynamic> = stage.getObjectsUnderPoint(point);
        var item : DisplayObject = ((targets.length > 0)) ? targets[targets.length - 1] : stage;
        
        while (targets.length > 0)
        {
            item = try cast(targets.pop(), DisplayObject) catch(e:Dynamic) null;
            //ignore debug cursor/object/blob and send object under debug cursor/object/blob
            if ((Std.is(item, ITuioDebugCursor) || Std.is(item, ITuioDebugBlob) || Std.is(item, ITuioDebugObject) || Std.is(item, ITuioDebugTextSprite)) && targets.length > 1)
            {
                continue;
            }
            if (item.parent != null && !(Std.is(item, InteractiveObject)))
            {
                item = item.parent;
            }
            if (Std.is(item, InteractiveObject))
            {
                if ((try cast(item, InteractiveObject) catch(e:Dynamic) null).mouseEnabled)
                {
                    return item;
                }
            }
        }
        item = stage;
        
        return item;
    }
    
    public static function bubbleListCheck(obj : DisplayObject) : Bool
    {
        if (obj.parent != null)
        {
            return bubbleListCheck(obj.parent);
        }
        else
        {
            return false;
        }
    }

    public function new()
    {
    }
}

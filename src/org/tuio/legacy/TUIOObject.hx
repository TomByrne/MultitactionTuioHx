/** * Legacy TUIOObject class. */package org.tuio.legacy;

import flash.errors.Error;
import flash.display.DisplayObject;
import flash.geom.Point;

/**	 * Legacy TUIOObject class from Touchlib TUIO AS3. Use only for the port of existing code to TUIO AS3.	 *  	 * For the current Tuio event implementation see:	 * @see org.tuio.TuioManager	 * @see org.tuio.TouchEvent	 *  	 * For more information about this legacy Tuio implementation see: 	 * @see TuioLegacyListener	 * @see TouchEvent	 * 	 * 	 */class TUIOObject
{private var isNew : Bool;private var eventArray : Array<Dynamic>;public var tuioAlive : Bool;public var tuioType : String;public var tuioObject : DisplayObject;public var x : Float;public var y : Float;public var oldX : Float;public var oldY : Float;public var dX : Float;public var dY : Float;public var id : Int;public var sID : Int;public var area : Float = 0;public var width : Float = 0;public var height : Float = 0;public var angle : Float;public var pressure : Float;public var startTime : Float;public var lastModifiedTime : Float;public var downX : Float;public var downY : Float;public function new(type : String, id : Int, x : Float, y : Float, dX : Float, dY : Float, sID : Int = -1, angle : Float = 0, height : Float = 0.0, width : Float = 0.0, tuioObject : DisplayObject = null)
    {
        this.eventArray = new Array<Dynamic>();this.tuioType = type;this.id = id;this.x = x;this.y = y;this.oldX = x;this.oldY = y;this.dX = dX;this.dY = dY;this.sID = sID;this.angle = angle;this.width = width;this.height = height;this.area = width * height;this.tuioAlive = true;try
        {
            this.tuioObject = tuioObject;
        }
        catch (e : Error)
        {
            this.tuioObject = null;
        }this.isNew = true;var d : Date = Date.now();this.startTime = d.time;this.lastModifiedTime = this.startTime;
    }public function addListener(receiver : Dynamic) : Void
    {
        for (i in 0...this.eventArray.length)
        {
            if (this.eventArray[i] == receiver)
            {
                return;
            }
        }eventArray.push(receiver);
    }public function removeListener(receiver : Dynamic) : Void
    {
        for (i in 0...this.eventArray.length)
        {
            if (eventArray[i] == receiver)
            {
                eventArray.splice(i, 1);
            }
        }
    }
}
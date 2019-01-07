package org.tuio.adapters;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.NativeMenuItem;
import flash.display.SpreadMethod;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;
import flash.utils.Dictionary;
import org.tuio.*;
import org.tuio.debug.*;
import org.tuio.util.DisplayListHelper;

/**
	 * Listens on MouseEvents, "translates" them to the analog TuioTouchEvents and TuioFiducialEvents and dispatches
	 * them on <code>DisplayObject</code>s under the mouse pointer.
	 * 
	 * Additionally, it provides means to simulate multi-touch input with a single mouse.
	 * By pressing the 'Shift' key a touch can be added permanently. Pressing the 'Ctrl' key
	 * in Windows or the 'Command' key in Mac OS X while clicking a touch, will add the touch to a group. 
	 * Furthermore, object interaction can be simulated by choosing a fiducial id from the context menu and
	 * manipulating the debug representation of the fiducial subsequently. It can be dragged around
	 * or if 'r' is pressed it can be rotated. If 'Shift' is pressed a fiducial will be removed.
	 * 
	 * A group of touches will be moved around together. To rotate a group of touches, hold
	 * the 'r' key, while dragging. To move the touches apart from or towards each other (e.g., to perform pinch/scale
	 * gestures) hold the 's' key while dragging. To make a group disappear after dragging hold the 'Space'
	 * key while dragging. The latter is handy if you want to test physical properties like inertia of a group of objects.  
	 * 
	 * 
	 * @author Johannes Luderschmidt
	 * 
	 * @see org.tuio.TuioTouchEvent
	 * @see org.tuio.TuioFiducialEvent
	 * 
	 */
class MouseTuioAdapter extends AbstractTuioAdapter
{
    private var stage : Stage;
    private var tuioSessionId : Int;
    private var touchMoveId : Float;
    private var touchMoveSrc : String;
    private var movedObject : ITuioDebugObject;
    private var shiftKey : Bool;
    private var groups : Dictionary;
    
    private var frameId : Int = 0;
    private var lastSentFrameId : Float = 0;
    private var lastX : Float;
    private var lastY : Float;
    
    private var spaceKey : Bool;
    private var rKey : Bool;
    private var sKey : Bool;
    private var centerOfGroupedTouchesX : Float;
    private var centerOfGroupedTouchesY : Float;
    private var fiducialX : Float;
    private var fiducialY : Float;
    
    private var fiducialContextMenu : ContextMenu;
    
    private var TWO_D_CUR(default, never) : String = "2Dcur";
    private var TWO_D_OBJ(default, never) : String = "2Dobj";
    
    private var src : String = "_mouse_tuio_adapter_";
    
    /**
		 * initializes MouseToTouchDispatcher by adding appropriate event listeners to it. Basically, MouseToTouchDispatcher
		 * listens on mouse events and translates them to touches. However, additionally keyboard listeners are being added
		 * that listen on keyboard events to control certain actions like rotation of a touches group by holding 'r'.
		 * 
		 * @param stage 
		 * @param useTuioManager call the add, move and remove functions of the TuioManager instead of simply dispatching TuioTouchEvents. You have to initialize TuioManager before.
		 * @param useTuioDebug show the touches as debug cursors. You have to initialize TuioDebug before.
		 * 
		 */
    public function new(stage : Stage)
    {
        super(this);
        this.stage = stage;
        enableAdapter();
        
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
        
        tuioSessionId = 0;
        
        lastX = stage.mouseX;
        lastY = stage.mouseY;
        
        groups = new Dictionary();
        
        spaceKey = false;
        rKey = false;
        centerOfGroupedTouchesX = 0;
        centerOfGroupedTouchesY = 0;
        
        //Flash does not have MouseEvent.RIGHT_CLICK
        if (MouseEvent.RIGHT_CLICK)
        {
            createContextMenu();
        }
        else
        {
            addFlashContextMenu();
        }
    }
    
    public function enableAdapter() : Void
    {
        stage.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
        stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
        
        //Flash does not have MouseEvent.RIGHT_CLICK
        if (MouseEvent.RIGHT_CLICK)
        {
            stage.addEventListener(MouseEvent.RIGHT_CLICK, contextMenuClick);
        }
        else
        {
            addFlashContextMenu();
        }
        
        stage.addEventListener(Event.EXIT_FRAME, sendFrameEvent);
    }
    
    public function disableAdapter() : Void
    {
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
        stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
        
        //Flash does not have MouseEvent.RIGHT_CLICK
        if (MouseEvent.RIGHT_CLICK)
        {
            stage.removeEventListener(MouseEvent.RIGHT_CLICK, contextMenuClick);
        }
        else
        {
            removeFlashContextMenu();
        }
        
        stage.removeEventListener(Event.EXIT_FRAME, sendFrameEvent);
    }
    
    /**
		 * Causes a Tuio update event to be sent. Is, e.g., used in gesture API.
		 */
    private function sendFrameEvent(event : Event) : Void
    {
        if (this.frameId != this.lastSentFrameId)
        {
            for (l/* AS3HX WARNING could not determine type for var: l exp: EField(EIdent(this),listeners) type: null */ in this.listeners)
            {
                l.newFrame(this.frameId);
            }
            this.lastSentFrameId = this.frameId;
        }
    }
    
    /**
		 * If there is no existing touch 
		 * under the mouse pointer, a new touch will be added. However, if there already is one it will be marked
		 * for movement and no new touch is being added. Alternatively, if there is a fiducial underneath the mouse 
		 * pointer it will be selected for movement. If the 'Shift' key is pressed and there is an 
		 * existing touch beneath the mouse cursor this touch will be removed. Alternatively, If the 'Shift' key is pressed
		 * and there is a fiducial underneath the mouse pointer, the fiducial will be removed. 
		 * 
		 * If the 'Ctrl/Command' key is pressed 
		 * the touch will be added to a group (marked by a dot in the center of a touch) if it does not belong to a 
		 * group already. If it does it will be removed from the group.
		 * 
		 * NOTE: Adding touches permanently does only work if TuioDebug is being used and useTuioDebug is switched on.
		 *  
		 * @param event
		 * 
		 */
    private function handleMouseDown(event : MouseEvent) : Void
    {
        var cursorUnderPoint : ITuioDebugCursor = getCursorUnderPointer(event.stageX, event.stageY);
        var objectUnderPoint : ITuioDebugObject = getObjectUnderPointer(event.stageX, event.stageY);
        
        if (cursorUnderPoint != null)
        {
            startMoveCursor(cursorUnderPoint, event);
        }
        else if (objectUnderPoint != null)
        {
            startMoveObject(objectUnderPoint, event);
        }
        //add new mouse pointer
        else
        {
            
            var frameId : Int = this.frameId++;
            var tuioCursor : TuioCursor = createTuioCursor(event.stageX, event.stageY, 0, 0, this.tuioSessionId, frameId);
            Reflect.field(_tuioCursors, Std.string(this.src)).push(tuioCursor);
            dispatchAddCursor(tuioCursor);
            
            this.touchMoveId = this.tuioSessionId;
            this.touchMoveSrc = this.src;
            
            stage.addEventListener(MouseEvent.MOUSE_MOVE, dispatchTouchMove);
            stage.addEventListener(MouseEvent.MOUSE_UP, dispatchTouchUp);
            
            //takes care that the cursor will not be removed on mouse up
            this.shiftKey = event.shiftKey;
        }
    }
    
    //==========================================  CONTEXT MENU STUFF ==========================================
    /**
		 * 
		 * creates a context menu with 100 context menu items that allows to choose
		 * to add a debug fiducial with the fiducialId of the chosen menu item. 
		 */
    private function createContextMenu() : Void
    {
        fiducialContextMenu = new ContextMenu();
        
        for (i in 0...100)
        {
            var item : NativeMenuItem = new NativeMenuItem("Add Fiducial " + i);
            fiducialContextMenu.addItem(item);
            item.addEventListener(Event.SELECT, contextMenuSelected);
        }
    }
    
    /**
		 * shows the context menu
		 *  
		 * @param event mouse event.
		 * 
		 */
    private function contextMenuClick(event : MouseEvent) : Void
    {
        this.fiducialX = event.stageX;
        this.fiducialY = event.stageY;
        fiducialContextMenu.display(stage, this.fiducialX, this.fiducialY);
    }
    
    /**
		 * adds a debug fiducial with the fiducialId of the chosen menu item to the stage.
		 *  
		 * @param event
		 * 
		 */
    private function contextMenuSelected(event : Event) : Void
    {
        var itemLabel : String = (try cast(event.target, NativeMenuItem) catch(e:Dynamic) null).label;
        var fiducialId : Float = as3hx.Compat.parseInt(itemLabel.substring(itemLabel.lastIndexOf(" ") + 1, itemLabel.length));
        dispatchAddFiducial(this.fiducialX, this.fiducialY, fiducialId);
        this.tuioSessionId = this.tuioSessionId + 1;
    }
    
    /**
		 * 
		 * @param stageX x position of mouse 
		 * @param stageY y position of mouse
		 * @param fiducialId chosen fiducialId
		 * 
		 */
    private function dispatchAddFiducial(stageX : Float, stageY : Float, fiducialId : Int) : Void
    {
        var frameId : Int = this.frameId++;
        var tuioObject : TuioObject = createTuioObject(fiducialId, stageX, stageY, this.tuioSessionId, 0, frameId);
        Reflect.field(_tuioObjects, Std.string(this.src)).push(tuioObject);
        dispatchAddObject(tuioObject);
    }
    
    //==========================================  TOUCH STUFF ==========================================
    
    /**
		 * decides whether a TUIO debug cursor should be removed, added to a cursor group or it should be moved around.
		 * 
		 * @param cursorUnderPoint TUIO debug cursor under the mouse pointer.
		 * @param event
		 * 
		 */
    private function startMoveCursor(cursorUnderPoint : ITuioDebugCursor, event : MouseEvent) : Void
    //update or remove cursor under mouse pointer
    {
        
        if (event.shiftKey)
        
        //remove cursor{
            
            if (cursorUnderPoint.source == this.src)
            {
                removeCursor(event, cursorUnderPoint.sessionId, cursorUnderPoint.source);
                deleteFromGroup(cursorUnderPoint);
            }
            else
            {
                trace("You can only remove touches that you created via mouse clicks.");
            }
        }
        else if (event.ctrlKey)
        {
            var cursorObject : Dynamic = this.groups[cursorUnderPoint.sessionId];
            
            //add cursor to group
            if (cursorObject == null)
            
            //add to group{
                
                if (cursorUnderPoint.source == this.src)
                {
                    addToGroup(cursorUnderPoint);
                }
                else
                {
                    trace("You can only add those touches to groups that have been created via mouse clicks.");
                }
            }
            //remove from group
            else
            {
                
                (try cast(cursorObject.cursor, DisplayObjectContainer) catch(e:Dynamic) null).removeChild(cursorObject.markerSprite);
                deleteFromGroup(cursorUnderPoint);
            }
        }
        //take care that cursor is not removed after mouse up
        else
        {
            
            if (this.groups[this.touchMoveId] == null)
            {
                this.shiftKey = true;
            }
            //move cursor
            this.touchMoveId = cursorUnderPoint.sessionId;
            this.touchMoveSrc = cursorUnderPoint.source;
            
            //take care that cursor is moved around the middle
            this.lastX = stage.mouseX;
            this.lastY = stage.mouseY;
            
            stage.addEventListener(MouseEvent.MOUSE_MOVE, dispatchTouchMove);
            stage.addEventListener(MouseEvent.MOUSE_UP, dispatchTouchUp);
        }
    }
    
    /**
		 *adds a cursor to a group.
		 *  
		 * @param cursorUnderPoint the cursor that should be added to the group.  
		 * 
		 */
    private function addToGroup(cursorUnderPoint : ITuioDebugCursor) : Void
    {
        var cursorObject : Dynamic = this.groups[cursorUnderPoint.sessionId];
        
        cursorObject = {};
        cursorObject.cursor = cursorUnderPoint;
        
        var markerSprite : Sprite = new Sprite();
        markerSprite.graphics.beginFill(0xff0000);
        markerSprite.graphics.drawCircle(0, 0, 3);
        markerSprite.graphics.endFill();
        (try cast(cursorUnderPoint, DisplayObjectContainer) catch(e:Dynamic) null).addChild(markerSprite);
        
        cursorObject.markerSprite = markerSprite;
        
        this.groups[cursorUnderPoint.sessionId] = cursorObject;
    }
    
    /**
		 * deletes a cursor from the group dictionary.
		 *  
		 * @param cursorUnderPoint the cursor that should be removed from the group.
		 * 
		 */
    private function deleteFromGroup(cursorUnderPoint : ITuioDebugCursor) : Void
    {
        ;
    }
    
    /**
		 * moves a touch or a group of touches (depending if dragged touch is member of a group). 
		 * 
		 * If the 'r' key is pressed and a touch that is member of a group is 
		 * moved around, the group will be rotated around its berycenter. To rotate the touches, 
		 * drag the mouse up and down while 'r' is pressed.
		 * 
		 * If the 's' key is pressed and a touch that is member of a group is 
		 * moved around, the group will be rotated around its berycenter. To scale the touches, 
		 * drag the mouse left and right while 's' is pressed.
		 * 
		 * 'r' and 's' can be used in combination. 
		 *  
		 * @param event
		 * 
		 */
    private function dispatchTouchMove(event : MouseEvent) : Void
    {
        var xDiff : Float = stage.mouseX - this.lastX;
        var yDiff : Float = stage.mouseY - this.lastY;
        
        if (this.groups[this.touchMoveId] != null)
        {
            this.lastX = stage.mouseX;
            this.lastY = stage.mouseY;
            var cursorObject : Dynamic;
            var cursor : DisplayObjectContainer;
            
            var xPos : Float;
            var yPos : Float;
            var cursorMatrix : Matrix;
            
            //simply move grouped touches if neither 'r' nor 's' key is pressed
            if (!this.rKey && !this.sKey)
            {
                for (cursorObject/* AS3HX WARNING could not determine type for var: cursorObject exp: EField(EIdent(this),groups) type: null */ in this.groups)
                {
                    cursor = try cast(cursorObject.cursor, DisplayObjectContainer) catch(e:Dynamic) null;
                    xPos = cursor.x + xDiff;
                    yPos = cursor.y + yDiff;
                    moveCursor(xPos, yPos, xDiff, yDiff, cursorObject.cursor.sessionId, cursorObject.cursor.source);
                }
            }
            //rotate grouped touches if 'r' key is pressed
            else
            {
                
                for (cursorObject/* AS3HX WARNING could not determine type for var: cursorObject exp: EField(EIdent(this),groups) type: null */ in this.groups)
                {
                    cursor = try cast(cursorObject.cursor, DisplayObjectContainer) catch(e:Dynamic) null;
                    
                    cursorMatrix = cursor.transform.matrix;
                    cursorMatrix.translate(-this.centerOfGroupedTouchesX, -this.centerOfGroupedTouchesY);
                    if (this.rKey)
                    {
                        cursorMatrix.rotate(0.01 * yDiff);
                    }
                    if (this.sKey)
                    {
                        var finalScaleFactor : Float = 1;
                        var scaleFactor : Float = 1;
                        var i : Float;
                        var scaleTimes : Float = 0;
                        if (xDiff > 0)
                        {
                            scaleFactor = 1.01;
                            scaleTimes = xDiff;
                        }
                        else if (xDiff < 0)
                        {
                            scaleFactor = 0.99;
                            scaleTimes = -xDiff;
                        }
                        //apply scaling as often as mouse have been moved in x direction since the last frame
                        for (i in 0...scaleTimes)
                        {
                            finalScaleFactor = finalScaleFactor * scaleFactor;
                        }
                        cursorMatrix.scale(finalScaleFactor, finalScaleFactor);
                    }
                    cursorMatrix.translate(this.centerOfGroupedTouchesX, this.centerOfGroupedTouchesY);
                    xPos = cursorMatrix.tx;
                    yPos = cursorMatrix.ty;
                    moveCursor(xPos, yPos, xDiff, yDiff, cursorObject.cursor.sessionId, cursorObject.cursor.source);
                }
            }
        }
        //if no touch from group has been selected, simply move single touch
        else
        {
            
            if (this.src == this.touchMoveSrc)
            {
                moveCursor(stage.mouseX, stage.mouseY, xDiff, yDiff, this.touchMoveId, this.touchMoveSrc);
            }
            else
            {
                trace("You can only move touches that have been created via mouse clicks.");
            }
        }
    }
    
    /**
		 * takes care of the touch movement by dispatching an appropriate TuioTouchEvent or using the TuioManager and 
		 * adjusts the display of the touch in TuioDebug.
		 *  
		 * @param stageX the x coordinate of the touch 
		 * @param stageY the y coordinate of the touch 
		 * @param sessionId the session id of the touch 
		 * 
		 */
    private function moveCursor(stageX : Float, stageY : Float, diffX : Float, diffY : Float, sessionId : Int, source : String) : Void
    {
        var frameId : Int = this.frameId++;
        
        updateTuioCursor(getTuioCursor(sessionId, source), stageX, stageY, diffX, diffY, sessionId, frameId);
        dispatchUpdateCursor(getTuioCursor(sessionId, source));
    }
    
    /**
		 * removes the touch that is being dragged around from stage if no key has been pressed.
		 * 
		 * If the 'Shift' key has been pressed the touch will remain on the stage. 
		 * 
		 * If the 'Ctrl/Command' key has been pressed the touch will remain on stage and will be 
		 * added to a group.
		 * 
		 * If the 'Space' key is being pressed and a group of touches is being moved around the 
		 * whole group of touches will be removed.
		 *   
		 * @param event
		 * 
		 */
    private function dispatchTouchUp(event : MouseEvent) : Void
    {
        if (this.groups[this.touchMoveId] == null)
        
        //keep touch if shift key has been pressed{
            
            if (!this.shiftKey && !event.ctrlKey)
            {
                removeCursor(event, tuioSessionId, this.src);
            }
            else if (event.ctrlKey)
            {
                var cursorUnderPoint : ITuioDebugCursor = getCursorUnderPointer(event.stageX, event.stageY);
                addToGroup(cursorUnderPoint);
            }
        }
        else if (this.spaceKey)
        
        //remove all touches from group if space key is pressed{
            
            for (cursorObject/* AS3HX WARNING could not determine type for var: cursorObject exp: EField(EIdent(this),groups) type: null */ in this.groups)
            {
                var cursor : DisplayObjectContainer = try cast(cursorObject.cursor, DisplayObjectContainer) catch(e:Dynamic) null;
                removeCursor(event, cursorObject.cursor.sessionId, cursorObject.cursor.source);
                deleteFromGroup(cursorObject.cursor);
            }
        }
        
        tuioSessionId = as3hx.Compat.parseInt(tuioSessionId + 1);
        touchMoveId = tuioSessionId;
        
        lastX = 0;
        lastY = 0;
        
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, dispatchTouchMove);
        stage.removeEventListener(MouseEvent.MOUSE_UP, dispatchTouchUp);
    }
    
    private function deleteTuioCursorFromGlobalList(cursorID : Float) : Void
    {
        var i : Float = 0;
        for (tuioCursor/* AS3HX WARNING could not determine type for var: tuioCursor exp: EArray(EIdent(_tuioCursors),EField(EIdent(this),src)) type: Dynamic */ in Reflect.field(_tuioCursors, Std.string(this.src)))
        {
            if (tuioCursor.sessionID == cursorID)
            {
                Reflect.field(_tuioCursors, Std.string(this.src)).splice(i, 1);
            }
            i = i + 1;
        }
    }
    
    /**
		 * removes a touch from stage by dispatching an appropriate TuioTouchEvent or using the TuioManager and 
		 * removes the display of the touch in TuioDebug.
		 *  
		 * @param event
		 * @param sessionId session id of touch
		 * 
		 */
    private function removeCursor(event : MouseEvent, sessionId : Int, source : String) : Void
    {
        var frameId : Int = this.frameId++;
        
        dispatchRemoveCursor(getTuioCursor(sessionId, source));
        deleteTuioCursorFromGlobalList(sessionId);
    }
    /**
		 * returns the touch under the mouse pointer if there is one. Otherwise null will be returned.
		 * If the mouse pointer is above the red dot of a touch that beloings to a group still the
		 * touch will be returned.
		 *   
		 * @param stageX
		 * @param stageY
		 * @return the touch under the mouse pointer if there is one. Otherwise null will be returned.
		 * 
		 */
    private function getCursorUnderPointer(stageX : Float, stageY : Float) : ITuioDebugCursor
    {
        var cursorUnderPointer : ITuioDebugCursor = null;
        
        var objectsUnderPoint : Array<Dynamic> = stage.getObjectsUnderPoint(new Point(stageX, stageY));
        
        if (Std.is(objectsUnderPoint[objectsUnderPoint.length - 1], ITuioDebugCursor))
        {
            cursorUnderPointer = objectsUnderPoint[objectsUnderPoint.length - 1];
        }
        else if (objectsUnderPoint.length > 1 && Std.is(objectsUnderPoint[objectsUnderPoint.length - 2], ITuioDebugCursor))
        
        //if mouse pointer is above marker sprite, return ITuioDebugCursor beneath marker sprite{
            
            cursorUnderPointer = objectsUnderPoint[objectsUnderPoint.length - 2];
        }
        
        return cursorUnderPointer;
    }
    
    
    /**
		 * 
		 * @param stageX
		 * @param stageY
		 * @return 
		 * 
		 */
    private function getObjectUnderPointer(stageX : Float, stageY : Float) : ITuioDebugObject
    {
        var objectUnderPointer : ITuioDebugObject = null;
        
        var objectsUnderPoint : Array<Dynamic> = stage.getObjectsUnderPoint(new Point(stageX, stageY));
        
        if (Std.is(objectsUnderPoint[objectsUnderPoint.length - 1], ITuioDebugObject))
        {
            objectUnderPointer = objectsUnderPoint[objectsUnderPoint.length - 1];
        }
        else if (objectsUnderPoint.length > 1 && Std.is(objectsUnderPoint[objectsUnderPoint.length - 2], ITuioDebugObject))
        
        //if mouse pointer is above marker sprite, return ITuioDebugCursor beneath marker sprite{
            
            objectUnderPointer = objectsUnderPoint[objectsUnderPoint.length - 2];
        }
        
        return objectUnderPointer;
    }
    
    /**
		 * created a TuioCursor instance from the submitted parameters.
		 *  
		 * @param stageX an x coordinate in global coordinates.
		 * @param stageY a y coordinate in global coordinates.
		 * @param touchId the session id of a touch.
		 * 
		 * @return the TuioCursor.
		 * 
		 */
    private function createTuioCursor(stageX : Float, stageY : Float, diffX : Float, diffY : Float, sessionId : Int, frameId : Int) : TuioCursor
    {
        return new TuioCursor(TWO_D_CUR, sessionId, stageX / stage.stageWidth, stageY / stage.stageHeight, 0, diffX / stage.stageWidth, diffY / stage.stageHeight, 0, 0, frameId, this.src);
    }
    
    /**
		 * created a TuioContainer instance from the submitted parameters.
		 *  
		 * @param stageX an x coordinate in global coordinates.
		 * @param stageY a y coordinate in global coordinates.
		 * @param touchId the session id of a touch.
		 * 
		 * @return the TuioContainer.
		 * 
		 */
    /*private function createTuioContainer(type:String, stageX:Number, stageY:Number, sessionId:uint, frameId:uint):TuioContainer{
		return new TuioContainer(type,sessionId,stageX/stage.stageWidth, stageY/stage.stageHeight,0,0,0,0,0,frameId);
		}*/
    
    private function updateTuioCursor(tuioCursor : TuioCursor, stageX : Float, stageY : Float, diffX : Float, diffY : Float, sessionId : Int, frameId : Int) : Void
    {
        tuioCursor.update(stageX / stage.stageWidth, stageY / stage.stageHeight, 0, diffX / stage.stageWidth, diffY / stage.stageHeight, 0, 0, frameId);
    }
    
    //==========================================  FIDUCIAL STUFF ==========================================
    
    /**
		 * decides whether a TUIO debug object should be removed or moved around.
		 * 
		 * @param cursorUnderPoint TUIO debug object under the mouse pointer.
		 * @param event
		 * 
		 */
    private function startMoveObject(objectUnderPoint : ITuioDebugObject, event : MouseEvent) : Void
    //update or remove cursor under mouse pointer
    {
        
        if (event.shiftKey)
        
        //remove cursor{
            
            removeObject(event);
        }
        //move cursor
        else
        {
            
            this.movedObject = objectUnderPoint;
            
            //store start position in order to move object around the point where it has been clicked
            this.lastX = stage.mouseX;
            this.lastY = stage.mouseY;
            
            stage.addEventListener(MouseEvent.MOUSE_MOVE, dispatchObjectMove);
            stage.addEventListener(MouseEvent.MOUSE_UP, dispatchObjectUp);
        }
    }
    
    /**
		 * moves a fiducial. 
		 * 
		 * If the 'r' key is being pressed the TUIO object will be rotated.
		 *  
		 * @param event
		 * 
		 */
    private function dispatchObjectMove(event : MouseEvent) : Void
    {
        var stageX : Float = (try cast(this.movedObject, DisplayObjectContainer) catch(e:Dynamic) null).x + stage.mouseX - this.lastX;
        var stageY : Float = (try cast(this.movedObject, DisplayObjectContainer) catch(e:Dynamic) null).y + stage.mouseY - this.lastY;
        if (!this.rKey)
        {
            if (this.movedObject.source == this.src)
            {
                moveObject(stageX, stageY, this.movedObject.sessionId, this.movedObject.fiducialId, this.movedObject.objectRotation);
            }
            else
            {
                trace("You can only move objects that have been created via mouse clicks.");
            }
        }
        else
        {
            var rotationVal : Float = this.movedObject.objectRotation + (0.01 * (stage.mouseY - this.lastY));
            if (this.movedObject.source == this.src)
            {
                moveObject((try cast(this.movedObject, DisplayObjectContainer) catch(e:Dynamic) null).x, (try cast(this.movedObject, DisplayObjectContainer) catch(e:Dynamic) null).y, this.movedObject.sessionId, this.movedObject.fiducialId, rotationVal);
            }
            else
            {
                trace("You can only rotate objects that have been created via mouse clicks.");
            }
        }
        this.lastX = stage.mouseX;
        this.lastY = stage.mouseY;
    }
    
    /**
		 * takes care of the fiducial movement by dispatching an appropriate FiducialEvent or using the TuioManager and
		 * the TuioFiducialDispatcher to adjust the display of the fiducial in TuioDebug.
		 *  
		 * @param stageX the x coordinate of the mouse pointer 
		 * @param stageY the y coordinate of the mouse pointer 
		 * @param sessionId the session id of the fiducial 
		 * 
		 */
    private function moveObject(stageX : Float, stageY : Float, sessionId : Int, fiducialId : Int, rotation : Float) : Void
    {
        var frameId : Int = this.frameId++;
        var updateTuioObject : TuioObject = getTuioObject(sessionId, this.src);
        updateTuioObject.update(stageX / stage.stageWidth, stageY / stage.stageHeight, 0, rotation, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, frameId);
        dispatchUpdateObject(updateTuioObject);
    }
    
    /**
		 * Removes the move and up listener for fiducial movement.
		 *   
		 * @param event
		 * 
		 */
    private function dispatchObjectUp(event : MouseEvent) : Void
    {
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, dispatchObjectMove);
        stage.removeEventListener(MouseEvent.MOUSE_UP, dispatchObjectUp);
    }
    
    /**
		 * removes a fiducial from stage by dispatching an appropriate FiducialEvent and 
		 * removes the display of the fiducial in TuioDebug.
		 *  
		 * @param event
		 * 
		 */
    private function removeObject(event : MouseEvent) : Void
    {
        var frameId : Int = this.frameId++;
        if (this.movedObject.source == this.src)
        {
            dispatchRemoveObject(getTuioObject(this.movedObject.sessionId, this.movedObject.source));
        }
        else
        {
            trace("You can only remove objects that have been created via mouse clicks.");
        }
    }
    
    private function createTuioObject(fiducialId : Float, stageX : Float, stageY : Float, sessionId : Int, rotation : Float, frameId : Int) : TuioObject
    {
        return new TuioObject(TWO_D_OBJ, sessionId, fiducialId, stageX / stage.stageWidth, stageY / stage.stageHeight, 0, rotation, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, frameId, this.src);
    }
    
    //==========================================  KEYBOARD STUFF ==========================================
    
    /**
		 * if the 'Space' key is being pressed spaceKey is set to true in this instance. 
		 * 
		 * If the 'r' key is being pressed rKey is set to true in this instance and the 
		 * barycentric coordinates of the touch group is being calculated. 
		 *  
		 * @param event
		 * 
		 */
    private function keyDown(event : KeyboardEvent) : Void
    //if space has been pressed, all touches will be released
    {
        
        if (event.keyCode == 32)
        
        //space{
            
            this.spaceKey = true;
        }
        
        //if 's' or 'r' has been pressed while a grouped touch has been
        //clicked, touches will be 's'caled or 'r'otated
        if (event.keyCode == 82 || event.keyCode == 83)
        {
            if (event.keyCode == 82)
            
            //r{
                
                //caused by some very odd bug, an error appears when applying the rotation
                //if this.rKey is set to true again if it has been already set to true (remove
                //if statement and try it out to see what i mean)
                if (!this.rKey)
                {
                    this.rKey = true;
                }
            }
            if (event.keyCode == 83)
            
            //s{
                
                //the same mentioned above applies to this statement
                if (!this.sKey)
                {
                    this.sKey = true;
                }
            }
            var cursorUnderPoint : ITuioDebugCursor = getCursorUnderPointer(stage.mouseX, stage.mouseY);
            if (cursorUnderPoint != null && this.groups[cursorUnderPoint.sessionId] != null)
            
            //rotate around barycenter of touches{
                
                var xPos : Float;
                var yPos : Float;
                var xPositions : Array<Dynamic> = new Array<Dynamic>();
                var yPositions : Array<Dynamic> = new Array<Dynamic>();
                var calcCenterPoint : Point = new Point();
                var touchAmount : Float = 0;
                
                calcCenterPoint.x = 0;
                calcCenterPoint.y = 0;
                
                
                for (cursorObject/* AS3HX WARNING could not determine type for var: cursorObject exp: EField(EIdent(this),groups) type: null */ in this.groups)
                {
                    var cursor : DisplayObjectContainer = try cast(cursorObject.cursor, DisplayObjectContainer) catch(e:Dynamic) null;
                    xPos = cursor.x;
                    yPos = cursor.y;
                    xPositions.push(xPos);
                    yPositions.push(yPos);
                    
                    calcCenterPoint.x = calcCenterPoint.x + xPos;
                    calcCenterPoint.y = calcCenterPoint.y + yPos;
                    
                    touchAmount = touchAmount + 1;
                }
                
                this.centerOfGroupedTouchesX = calcCenterPoint.x / touchAmount;
                this.centerOfGroupedTouchesY = calcCenterPoint.y / touchAmount;
            }
        }
    }
    
    /**
		 * sets keyboard variables to false.
		 *  
		 * @param event
		 * 
		 */
    private function keyUp(event : KeyboardEvent) : Void
    {
        if (event.keyCode == 32)
        
        //space{
            
            this.spaceKey = false;
        }
        if (event.keyCode == 82)
        
        //r{
            
            this.rKey = false;
            this.centerOfGroupedTouchesX = 0;
            this.centerOfGroupedTouchesY = 0;
        }
        if (event.keyCode == 83)
        
        //s{
            
            this.sKey = false;
        }
    }
    
    //==========================================  FLASH CONTEXT MENU STUFF ==========================================
    
    private function addFlashContextMenu() : Void
    {  //flash provides a ContextMenu class in flash.ui that enables to use  
        //the context menu in an swf. however, ContextMenu is not provided
        //in the flex sdk and thus not supported by TUIO AS3. so go ahead
        //if you want to use flash and implement it yourself like this:
        //http://www.republicofcode.com/tutorials/flash/as3contextmenu/
        
    }
    
    private function removeFlashContextMenu() : Void
    {  //flash provides a ContextMenu class in flash.ui that enables to use  
        //the context menu in an swf. however, ContextMenu is not provided
        //in the flex sdk and thus not supported by TUIO AS3. so go ahead
        //if you want to use flash and implement it yourself like this:
        //http://www.republicofcode.com/tutorials/flash/as3contextmenu/
        
    }
}

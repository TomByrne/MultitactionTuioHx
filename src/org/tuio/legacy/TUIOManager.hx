package org.tuio.legacy;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.TimerEvent;
import flash.ui.Keyboard;
import flash.utils.Dictionary;
import flash.utils.Timer;
import mx.core.Application;
import org.tuio.TuioClient;
import org.tuio.TuioManager;
import org.tuio.connectors.UDPConnector;
import org.tuio.debug.TuioDebug;

/**
	 * Legacy TUIOManager from fiducialtuioas3 (http://code.google.com/p/fiducialtuioas3/).
	 * 
	 * The functionality of TUIOManager is now integrated into <code>org.tuio.TuioManager</code> and 
	 * <code>org.tuio.ITuioFiducialReceiver</code>.  
	 * 
	 * @author Frederic Friess
	 * 
	 */
class TUIOManager extends Sprite
{
    
    private var PropObjectDict : Dictionary;
    private var AliveDict : Dictionary;
    
    private var timeInMillisec : Float;
    
    
    public function new()
    {
        super();
        
        PropObjectDict = new Dictionary();
        AliveDict = new Dictionary();
        var RemoveChecker : Timer = new Timer(1000, 0);
        
        addEventListener(Event.ADDED_TO_STAGE, onStageAdd);
        
        RemoveChecker.addEventListener(TimerEvent.TIMER, timerHandler);
        RemoveChecker.start();
        
        
        this.timeInMillisec = 0;
    }
    
    // for Hardware Test
    public function makeHotSpotImage(evt : KeyboardEvent) : Void
    {
        if (evt.charCode == Keyboard.ENTER)
        
        //				trace("start:");{
            
            var time : Date = Date.now();
            this.timeInMillisec = (time.getSeconds() * 1000) + time.getMilliseconds();
        }
    }
    
    // for Hardware Test
    public function Touchhandler(evt : TouchEvent) : Void
    {
        var time : Date = Date.now();
        var temp : Float = (time.getSeconds() * 1000) + time.getMilliseconds();
        //			trace("Lag of "+String( ((temp - this.timeInMillisec)/1000))+" sek");
        this.timeInMillisec = 0;
    }
    
    private function onStageAdd(evt : Event = null) : Void
    {
        var tuio : TuioClient = 
        new TuioClient(new UDPConnector());
        var legacyListener : TuioLegacyListener = TuioLegacyListener.init(stage, tuio);
        var tuioDebug : TuioDebug = TuioDebug.init(stage);
        tuioDebug.showDebugText = false;
        tuioDebug.cursorLineColor = 0xcccccc;
        tuioDebug.cursorLineAlpha = 1;
        tuioDebug.cursorLineThickness = 5;
        var fiducialLegacyListener : FiducialTuioAS3LegacyListener = FiducialTuioAS3LegacyListener.init(stage, this);
        tuio.addListener(legacyListener);
        tuio.addListener(tuioDebug);
        tuio.addListener(fiducialLegacyListener);
        tuio.addListener(TuioManager.init(stage));
        //			tuio.addListener(TuioFiducialDispatcher.init(stage,1000));
        
        stage.addEventListener(TouchEvent.MOUSE_DOWN, Touchhandler);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, makeHotSpotImage);
        
        removeEventListener(Event.ADDED_TO_STAGE, onStageAdd);
    }
    
    
    
    private function timerHandler(evt : TimerEvent) : Void
    //speichern der statuse der Props vor der änderung
    {
        
        var preAliveArray : Array<Dynamic> = new Array<Dynamic>();
        for (f_id in Reflect.fields(PropObjectDict))
        
        //trace(f_id+"----------"){
            
            var prop : PropObject = cast((Reflect.field(PropObjectDict, f_id)), PropObject);
            if (prop.isActiv)
            {
                preAliveArray.push(f_id);
            }
            else
            {
                preAliveArray.push(0);
            }
        }
        
        // alle auf 0 setzen
        var tempArray : Array<Dynamic> = new Array<Dynamic>();
        for (f_id in Reflect.fields(PropObjectDict))
        {
            tempArray.push(0);
        }
        
        // alle deaktivieren
        for (f_id in Reflect.fields(PropObjectDict))
        {
            var prop : PropObject = cast((Reflect.field(PropObjectDict, f_id)), PropObject);
            prop.isActiv = false;
        }
        
        
        // die lebenden wieder aktivieren
        for (f_id in Reflect.fields(PropObjectDict))
        {
            var prop : PropObject = cast((Reflect.field(PropObjectDict, f_id)), PropObject);
            var s_id = prop.s_id;
            for (alive_s_id in Reflect.fields(AliveDict))
            {
                if (s_id == alive_s_id)
                {
                    prop.isActiv = true;
                }
            }
        }
        AliveDict = new Dictionary();
        
        
        //speichern der statuse der Props nach der änderung
        var postAliveArray : Array<Dynamic> = new Array<Dynamic>();
        for (f_id in Reflect.fields(PropObjectDict))
        
        //trace(f_id+"----------"){
            
            var prop : PropObject = cast((Reflect.field(PropObjectDict, f_id)), PropObject);
            if (prop.isActiv)
            {
                postAliveArray.push(f_id);
            }
            else
            {
                postAliveArray.push(0);
            }
        }
        
        // die gestorbenen melden
        for (i in 0...postAliveArray.length)
        {
            if ((preAliveArray[i] != postAliveArray[i]) && (postAliveArray[i] == 0))
            {
                var f_id = preAliveArray[i];
                var prop : PropObject = cast((PropObjectDict[f_id]), PropObject);
                prop.dispatchEvent(new PropEvent(PropEvent.REMOVE_PROP, prop.s_id, prop.f_id));
            }
        }
    }
    
    
    
    public function getProp(id : Float) : PropObject
    {
        if (this.PropObjectDict[id] == null)
        {
            var evt : PropEvent = new PropEvent(PropEvent.SET_PROP, -1, id);
            Reflect.setField(PropObjectDict, Std.string(id), createProp(evt));
        }
        return this.PropObjectDict[id];
    }
    
    
    private function createProp(evt : PropEvent) : PropObject
    //var spr:PropView = new PropView();
    {
        
        var tmpProp : PropObject = new PropObject(evt.s_id, evt.f_id);
        return tmpProp;
    }
    
    
    public function onPropSet(evt : PropEvent) : Void
    {
        if (PropObjectDict[evt.f_id] != null)
        {
            var prop : PropObject = this.getProp(evt.f_id);
            prop.set_s_ID(evt.s_id);
            
            // onAdd ueberprüfen
            if (!prop.isActiv)
            {
                prop.dispatchEvent(new PropEvent(PropEvent.ADD_PROP, evt.s_id, evt.f_id, evt.xpos, evt.ypos, evt.angle, evt.xspeed, evt.yspeed, evt.rspeed, evt.maccel, evt.raccel, evt.speed, true, true));
            }
            prop.isActiv = true;
            
            prop.dispatchEvent(new PropEvent(PropEvent.MOVE_PROP, evt.s_id, evt.f_id, evt.xpos, evt.ypos, evt.angle, evt.xspeed, evt.yspeed, evt.rspeed, evt.maccel, evt.raccel, evt.speed, true, true));
            prop.dispatchEvent(new PropEvent(PropEvent.ROTATE_PROP, evt.s_id, evt.f_id, evt.xpos, evt.ypos, evt.angle, evt.xspeed, evt.yspeed, evt.rspeed, evt.maccel, evt.raccel, evt.speed, true, true));
            prop.dispatchEvent(new PropEvent(PropEvent.VELOCETY_MOVE_PROP, evt.s_id, evt.f_id, evt.xpos, evt.ypos, evt.angle, evt.xspeed, evt.yspeed, evt.rspeed, evt.maccel, evt.raccel, evt.speed, true, true));
            prop.dispatchEvent(new PropEvent(PropEvent.VELOCETY_ROTATE_PROP, evt.s_id, evt.f_id, evt.xpos, evt.ypos, evt.angle, evt.xspeed, evt.yspeed, evt.rspeed, evt.maccel, evt.raccel, evt.speed, true, true));
            prop.dispatchEvent(new PropEvent(PropEvent.ACCEL_MOVE_PROP, evt.s_id, evt.f_id, evt.xpos, evt.ypos, evt.angle, evt.xspeed, evt.yspeed, evt.rspeed, evt.maccel, evt.raccel, evt.speed, true, true));
            prop.dispatchEvent(new PropEvent(PropEvent.ACCEL_ROTATE_PROP, evt.s_id, evt.f_id, evt.xpos, evt.ypos, evt.angle, evt.xspeed, evt.yspeed, evt.rspeed, evt.maccel, evt.raccel, evt.speed, true, true));
        }
    }
    
    
    
    public function onPropAlive(evt : PropEvent) : Void
    {
        AliveDict[evt.s_id] = true;
    }
}

package multitaction.tuio.processors.touch.base;

import multitaction.model.touch.TuioTouchesSettingsModel;
import starling.core.Starling;
import starling.display.Stage;
import starling.events.TouchProcessor;

/**
 * ...
 * @author Michal Moczynski
 */
class StarlingTuioTouchProcessor extends TouchProcessor 
{
	var tuioTouchSettingsModel:TuioTouchesSettingsModel;
	public function new(stage:Stage, tuioTouchSettingsModel:TuioTouchesSettingsModel) 
	{
		this.tuioTouchSettingsModel = tuioTouchSettingsModel;
		super(stage);		
	}
	
    override public function enqueue(touchID:Int, phase:String, globalX:Float, globalY:Float,
                            pressure:Float = 1.0, width:Float = 1.0, height:Float = 1.0):Void
	{
		if (tuioTouchSettingsModel.useWindoesTouches.value == true)
		{
			super.enqueue( touchID, phase, globalX, globalY, pressure, width, height);
		}
	}
	
	public function injectTouch(touchID:Int, phase:String, globalX:Float, globalY:Float,
                            pressure:Float = 1.0, width:Float = 1.0, height:Float = 1.0):Void
	{
		super.enqueue( touchID, phase, Std.int(globalX * Starling.current.stage.stageWidth), Std.int(globalY * Starling.current.stage.stageHeight), pressure, width, height);
	}

	public function removeTouch(touchID:Int):Void
	{
		var i:Int = 0;
		for (touch in this.__currentTouches)
		{
			if(touch.id == touchID)
			{
				this.__currentTouches.removeAt(i);
				i--;
				this.log("remove touch from starling " + touchID);
			}
			i++;
		}
	}

}
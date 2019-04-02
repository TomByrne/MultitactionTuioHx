package multitaction.model.touch;

import org.tuio.TuioCursor;
import imagsyd.signals.Signal;

/**
 * ...
 * @author Michal Moczynski
 */
@:rtti
class TouchObjectsModel implements ITouchObjectsModel
{
	//public var starlingTuioTouchProcessors:Array<StarlingTuioTouchProcessor> = [];
	
	public var cursorsAdded:Map<UInt, TuioCursor> = new Map<UInt, TuioCursor>();
	public var cursorsUpdated:Map<UInt, TuioCursor> = new Map<UInt, TuioCursor>();
	public var cursorsRemoved:Map<UInt, TuioCursor> = new Map<UInt, TuioCursor>();
    
	public var onProcessed:Signal0 = new Signal0();
	
	public var touchesArray:Array<TuioCursor> = new Array<TuioCursor>();

	//to check if specific touch ID has been accepted in the past
	//public var touchesThatBeganMap:Map<Int, Bool> = new Map<Int, Bool>();

	public function new() 
	{
		
	}

	public function tick()
	{
		touchesArray = [];
	}

    public function processed()
	{
        onProcessed.dispatch();
		cursorsAdded = new Map<UInt, TuioCursor>();
		cursorsUpdated = new Map<UInt, TuioCursor>();
		cursorsRemoved = new Map<UInt, TuioCursor>();
    }

	/*public function processed()
	{
		for (tc in cursorsAdded) 
		{
			for(starlingTuioTouchProcessor in starlingTuioTouchProcessors)
			{
				starlingTuioTouchProcessor.injectTouch( tc.sessionID, TouchPhase.BEGAN, tc.x, tc.y);
			}
		}

		for (tc in cursorsUpdated) 
		{
			for(starlingTuioTouchProcessor in starlingTuioTouchProcessors)
			{
				if(touchesThatBeganMap.exists(tc.sessionID))
				{
					starlingTuioTouchProcessor.injectTouch( tc.sessionID, TouchPhase.MOVED, tc.x, tc.y);
				}
			}
		}

		for (tc in cursorsRemoved) 
		{
			for(starlingTuioTouchProcessor in starlingTuioTouchProcessors)
			{
				if(touchesThatBeganMap.exists(tc.sessionID))
				{
					starlingTuioTouchProcessor.injectTouch( tc.sessionID, TouchPhase.ENDED, tc.x, tc.y);
				}

				touchesThatBeganMap.remove(tc.sessionID);
			}

		}
		cursorsAdded = new Map<UInt, TuioCursor>();
		cursorsUpdated = new Map<UInt, TuioCursor>();
		cursorsRemoved = new Map<UInt, TuioCursor>();
	}*/
	
}
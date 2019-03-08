package multitaction.model.touch;
import multitaction.model.settings.TuioSettingsModel;
import multitaction.tuio.processors.touch.base.StarlingTuioTouchProcessor;
import org.tuio.TuioCursor;
import starling.core.Starling;
import starling.events.TouchPhase;

/**
 * ...
 * @author Michal Moczynski
 */
@:rtti
class TouchObjectsModel implements ITouchObjectsModel
{
	public var starlingTuioTouchProcessors:Array<StarlingTuioTouchProcessor> = [];
	
	public var cursorsAdded:Map<UInt, TuioCursor> = new Map<UInt, TuioCursor>();
	public var cursorsUpdated:Map<UInt, TuioCursor> = new Map<UInt, TuioCursor>();
	public var cursorsRemoved:Map<UInt, TuioCursor> = new Map<UInt, TuioCursor>();
	
	public var touchesArray:Array<TuioCursor> = new Array<TuioCursor>();

	//to check if specific touch ID has been accepted in the past
	public var touchesThatBeganMap:Map<Int, Bool> = new Map<Int, Bool>();

	public function new() 
	{
		
	}

	public function tick()
	{
		touchesArray = [];
	}

/*	
	public function removeTouch(touchID:Int)
	{
		for(starlingTuioTouchProcessor in starlingTuioTouchProcessors)
			starlingTuioTouchProcessor.removeTouch( touchID );		
	}
*/

	public function processed()
	{
		for (tc in cursorsAdded) 
		{
			for(starlingTuioTouchProcessor in starlingTuioTouchProcessors)
			{
//				this.log(" BEGAN touch " + tc.sessionID);
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
//					this.log(" ENDED touch " + tc.sessionID);
					starlingTuioTouchProcessor.injectTouch( tc.sessionID, TouchPhase.ENDED, tc.x, tc.y);
				}

				touchesThatBeganMap.remove(tc.sessionID);
			}

		}
		cursorsAdded = new Map<UInt, TuioCursor>();
		cursorsUpdated = new Map<UInt, TuioCursor>();
		cursorsRemoved = new Map<UInt, TuioCursor>();
	}
	
}
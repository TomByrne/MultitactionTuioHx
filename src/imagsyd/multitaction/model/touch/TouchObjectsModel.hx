package imagsyd.multitaction.model.touch;
import imagsyd.multitaction.tuio.processors.touch.base.StarlingTuioTouchProcessor;
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
	@inject public var starlingTuioTouchProcessor:StarlingTuioTouchProcessor;
	
	public var cursorsAdded:Map<UInt, TuioCursor> = new Map<UInt, TuioCursor>();
	public var cursorsUpdated:Map<UInt, TuioCursor> = new Map<UInt, TuioCursor>();
	public var cursorsRemoved:Map<UInt, TuioCursor> = new Map<UInt, TuioCursor>();
	
	public var touchesArray:Array<TuioCursor> = new Array<TuioCursor>();

	public function new() 
	{
		
	}

	public function tick()
	{
		touchesArray = [];
	}
	
	public function processed()
	{
		for (tc in cursorsAdded) 
		{
			starlingTuioTouchProcessor.injectTouch( tc.sessionID, TouchPhase.BEGAN, tc.x * Starling.current.nativeStage.stageWidth, tc.y * Starling.current.nativeStage.stageHeight);
		}
		for (tc in cursorsUpdated) 
		{
			starlingTuioTouchProcessor.injectTouch( tc.sessionID, TouchPhase.MOVED, tc.x * Starling.current.nativeStage.stageWidth, tc.y * Starling.current.nativeStage.stageHeight);
		}
		for (tc in cursorsRemoved) 
		{
			starlingTuioTouchProcessor.injectTouch( tc.sessionID, TouchPhase.ENDED, tc.x * Starling.current.nativeStage.stageWidth, tc.y * Starling.current.nativeStage.stageHeight);
		}
		cursorsAdded = new Map<UInt, TuioCursor>();
		cursorsUpdated = new Map<UInt, TuioCursor>();
		cursorsRemoved = new Map<UInt, TuioCursor>();
	}
	
}
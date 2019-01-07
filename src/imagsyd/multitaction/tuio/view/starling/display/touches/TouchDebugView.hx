package imagsyd.multitaction.tuio.view.starling.display.touches;

import imagsyd.gestures.TouchInfo;
import imagsyd.multitaction.tuio.view.starling.display.touches.DebugTouchPointView;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Touch;

/**
 * ...
 * @author Michal Moczynski
 */
class TouchDebugView extends Sprite 
{

	private var touchIndicators:Map<Int, DebugTouchPointView> = new Map<Int, DebugTouchPointView>();
	
	public function new() 
	{
		super();		
	}
	
	public function initialize() 
	{
		var q:Quad = new Quad(1920, 1080, 0xff0000);
		q.alpha = .1;
		addChild(q);
		/*
		stage.addEventListener( MouseEvent.MOUSE_DOWN, handleMouseBegin);
		stage.addEventListener( MouseEvent.MOUSE_MOVE, handleMouseMove);
		stage.addEventListener( MouseEvent.MOUSE_UP, handleMouseEnd);
		*/
	}
	/*
	function handleMouseBegin(e:MouseEvent):Void 
	{
		if (touchIndicators.exists( -1 ))
		{
			touchIndicators.get(-1).updateData(e.stageX, e.stageY);
		}
		else
		{
			var t:DebugTouchPointView = new DebugTouchPointView();
			t.updateData(e.stageX, e.stageY);
			addChild(t);
			touchIndicators.set(-1, t);
		}	
	}
	
	function handleMouseMove(e:MouseEvent):Void 
	{
		if (touchIndicators.exists( -1 ))
		{
			touchIndicators.get(-1).updateData(e.stageX, e.stageY);
		}
	}
	
	function handleMouseEnd(e:MouseEvent):Void 
	{
		if (touchIndicators.exists( -1 ))
		{
			var t:DebugTouchPointView = touchIndicators.get(-1);
			removeChild(t);
			t = null;
			touchIndicators.remove(-1);
		}
	}
	*/
	
	public function handleTouchBegin(touch:TouchInfo):Void 
	{
		if (touchIndicators.exists( touch.id ))
		{
			touchIndicators.get(touch.id).updateData(touch.globalX, touch.globalY);
		}
		else
		{
			var t:DebugTouchPointView = new DebugTouchPointView();
			t.updateData(touch.globalX, touch.globalY);
			addChild(t);
			touchIndicators.set(touch.id, t);
		}	
	}
	
	public function handleTouchMove(touch:TouchInfo):Void 
	{
		if (touchIndicators.exists( touch.id ))
		{
			touchIndicators.get(touch.id).updateData(touch.globalX, touch.globalY);
		}
	}
	
	public function handleTouchEnd(touch:TouchInfo):Void 
	{
		if (touchIndicators.exists( touch.id ))
		{
			var t:DebugTouchPointView = touchIndicators.get(touch.id);
			removeChild(t);
			t = null;
			touchIndicators.remove(touch.id);
		}
	}
	
}
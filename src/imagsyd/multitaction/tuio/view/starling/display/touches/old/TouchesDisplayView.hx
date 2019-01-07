package imagsyd.multitaction.tuio.view.starling.display.touches.old;

import com.imagination.core.managers.layout2.LayoutManager;
import com.imagination.core.managers.layout2.settings.LayoutScale;
import imagsyd.multitaction.tuio.view.starling.display.touches.old.touch.TouchPoint;
import starling.display.BlendMode;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Touch;
import starling.filters.BlurFilter;

/**
 * ...
 * @author Michal Moczynski
 */
class TouchesDisplayView extends Sprite
{
	var indicators:Map<Int, TouchPoint> = new Map<Int, TouchPoint>();
	var back:Quad;
	var touchPointsPool:Array<TouchPoint>;

	public function new() 
	{
		super();
		
	}
	
	public function initialize() 
	{
		createTouches();
		this.touchable = false;
	}
	
	function createTouches() 
	{
		touchPointsPool = [];
		for (i in 0 ... 100) 
		{
			var tp:TouchPoint = new TouchPoint();
			tp.visible = false;
			addChild(tp);
			touchPointsPool.push( tp );
		}
	}
	
	public function addIndicator(t:Touch) 
	{
		if ( indicators.exists( t.id ) == false )
		{
			var indicator:TouchPoint = touchPointsPool.shift();
			indicator.visible = true;
			touchPointsPool.push(indicator);
			indicators.set( t.id, indicator);
			indicator.x = t.globalX;
			indicator.y = t.globalY;
			addChild(indicator);
		}
		else
		{
			updateIndicator(t);
		}
	}
	
	public function updateIndicator(t:Touch) 
	{
		if ( indicators.exists( t.id ) )
		{
			var indicator:TouchPoint = indicators.get(t.id);
			indicator.x = t.globalX;
			indicator.y = t.globalY;
		}
	}
	
	public function removeIndicator(t:Touch) 
	{
		if ( indicators.exists( t.id )  )
		{
			var indicator:TouchPoint = indicators.get(t.id);
			indicators.remove( t.id );
			indicator.visible = false;
		}
		
	}
	
}
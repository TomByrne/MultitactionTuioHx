package imagsyd.multitaction.tuio.view.starling.display.touches.old.touch;

import com.imagination.texturePacker.impl.convert.starling.StarlingConverter;
import starling.display.BlendMode;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;

/**
 * @author Michal Moczynski
 */

class TouchPoint extends Sprite
{
	var back:Quad;
	var targetAlpha:Float;

	public function new() 
	{
		super();
		
	}
	
	public function initialize() 
	{
		back = new Quad( 50, 50, 0x001b9d );
		back.alpha = .1;
		back.x = -back.width / 2;
		back.y = -back.height / 2;
		back.color = 0x001b9d;
		addChild(back);		
		this.touchable = false;
	}	
}
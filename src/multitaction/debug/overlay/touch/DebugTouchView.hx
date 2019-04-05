package multitaction.debug.overlay.touch;

import openfl.display.Sprite;


/**
 * ...
 * @author Michal Moczynski
 */
class DebugTouchView extends Sprite 
{
	public function new() 
	{
		super();
        
        mouseEnabled = false;

		graphics.beginFill(0x999999);
        graphics.drawCircle(0, 0, 20);
        graphics.endFill();
		alpha = 0.3;
	}
	
	public function updateData(xPos:Float, yPos:Float) 
	{
		this.x = xPos;
		this.y = yPos;
	}
	
}
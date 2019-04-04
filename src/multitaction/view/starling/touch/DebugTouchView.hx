package multitaction.view.starling.touch;
import starling.display.Quad;
import starling.display.Sprite;


/**
 * ...
 * @author Michal Moczynski
 */
class DebugTouchView extends Sprite 
{
	var indicator:Quad;

	public function new() 
	{
		super();
		
		indicator = new Quad(40, 40, 0xffffff);
		indicator.x = indicator.y = -20;
		indicator.alpha = 0.3;
		addChild(indicator);
	}
	
	public function updateData(xPos:Float, yPos:Float) 
	{
		this.x = xPos;
		this.y = yPos;
	}
	
}
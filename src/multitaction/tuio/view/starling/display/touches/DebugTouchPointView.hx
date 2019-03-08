package multitaction.tuio.view.starling.display.touches;
import starling.display.Quad;
import starling.display.Sprite;


/**
 * ...
 * @author Michal Moczynski
 */
class DebugTouchPointView extends Sprite 
{
	var indicator:Quad;

	public function new() 
	{
		super();
		
	}
	
	public function initialize() 
	{
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
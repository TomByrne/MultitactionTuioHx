package multitaction.view.starling.marker;

import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;

/**
 * ...
 * @author Michal Moczynski
 */
 @:noCompletion
class DebugMarkerView extends Sprite 
{
	var background:Quad;
	var text:TextField;

	public function new() 
	{
		super();
		
		background = new Quad(150, 150, 0xff0000);
		background.alpha = 0.3;
		background.x = -background.width / 2;
		background.y = -background.height / 2;
		addChild(background);
		
		text = new TextField(100, 40, "");
		//text.color = 0xffffff;
		text.x = 50;
		addChild(text);		
	}
	
	public function setID(classID:Int, uid:String)
	{
		text.text = Std.string(classID) + "\n" + Std.string(uid);
	}
	
}
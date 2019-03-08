package multitaction.tuio.view.openfl.debug.touchPanel;

import imagsyd.notifier.Notifier;
import openfl.display.Quad;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * ...
 * @author Michal Moczynski
 */
class DebugToggleView extends Sprite 
{
	var background:openfl.display.Quad;
	var nameText:openfl.text.TextField;
	var nameString:String;
	static var onColor:UInt = 0x8ac765;
	static var offColor:UInt = 0xc76565;
	var indicator:openfl.display.Quad;
	public var notifier:Notifier<Bool>;

	public function new( notifier:Notifier<Bool>,  nameString:String ) 
	{
		super();
		this.notifier = notifier;//listener in the mediator
		this.nameString = nameString;
	}
	
	public function initialize() 
	{
		background = new Quad(50, 20, 0x666666);
		background.alpha = 0.3;
		addChild(background);
		
		indicator = new Quad( 20, 20, offColor);
		indicator.x = 5;
		addChild(indicator);
		
		nameText = new TextField();
		nameText.defaultTextFormat = new TextFormat("_typewriter", 17, 0x555555, null, null, null, null, null, TextFormatAlign.LEFT);
		nameText.text = nameString;
		nameText.width = 400;
		nameText.height = 30;
		nameText.x = 60;
//		nameText.y = 5;
		addChild(nameText);
		
	}
	
	public function updateIndicator( value:Bool )
	{
		if (value)
		{
			indicator.x = 25;
			indicator.color = onColor;
		}
		else
		{
			indicator.x = 5;
			indicator.color = offColor;
		}
	}
	
}
package imagsyd.multitaction.tuio.view.openfl.debug.tuioMarkers.element;
import imagsyd.multitaction.tuio.processors.maker.base.ITuioProcessor;
import imagsyd.multitaction.tuio.processors.maker.base.ITuioStackableProcessor;
import openfl.display.Quad;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * ...
 * @author Michal Moczynski
 */
class TuioProcessesPanelElementView extends Sprite
{
	public var processor:ITuioStackableProcessor;
	var background:Quad;
	var nameText:openfl.text.TextField;

	public function new(processor:ITuioStackableProcessor) 
	{
		this.processor = processor;
		super();
	}
	
	public function initialize() 
	{
		background = new Quad(250, 30, 0x8ac765);
		background.alpha = 0.3;
		addChild(background);
		
		nameText = new TextField();
		nameText.defaultTextFormat = new TextFormat("_typewriter", 17, 0x555555, null, null, null, null, null, TextFormatAlign.LEFT);
		nameText.text = processor.displayName;
		nameText.width = 200;
		nameText.height = 30;
		nameText.x = 5;
		nameText.y = 5;
		addChild(nameText);
	}
	
	public function setActicve(active:Bool) 
	{
		if (active)
		{
			nameText.alpha = 1;
			background.color = 0x8ac765;
		}
		else
		{
			nameText.alpha = .7;
			background.color = 0xc76565;
		}
	}
	
}
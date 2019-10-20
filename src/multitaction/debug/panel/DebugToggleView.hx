package multitaction.debug.panel;

import imagsyd.notifier.Notifier;
import openfl.display.Quad;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.events.MouseEvent;
import imagsyd.debug.view.controls.Toggle;

/**
 * ...
 * @author Michal Moczynski
 */
 @:noCompletion
class DebugToggleView extends Sprite 
{
	//static var onColor:UInt = 0x8ac765;
	//static var offColor:UInt = 0xc76565;

	public var notifier:Notifier<Bool>;
    
	//var background:Quad;
	var nameText:TextField;
	var nameString:String;
	var toggle:Toggle;
	//var indicator:Quad;

	public function new( nameString:String, ?notifier:Notifier<Bool> ) 
	{
		super();
		this.notifier = notifier;//listener in the mediator
		this.nameString = nameString;

        if(notifier != null) notifier.add(onNotifierChanged);

		/*background = new Quad(50, 20, 0x666666);
		background.alpha = 0.3;
		addChild(background);
		
		indicator = new Quad( 20, 20, offColor);
		indicator.x = 5;
		addChild(indicator);*/

        toggle = new Toggle();
        toggle.autoToggle = false;
        toggle.setLabels('', '');
        toggle.width = 50;
        toggle.height = 20;
        addChild(toggle);

        toggle.clicked.add(onToggleClicked);
		
		nameText = new TextField();
		nameText.defaultTextFormat = new TextFormat("_typewriter", 17, 0x555555, null, null, null, null, null, TextFormatAlign.LEFT);
		nameText.text = nameString;
		nameText.width = 400;
		nameText.height = 30;
		nameText.x = 60;
//		nameText.y = 5;
		addChild(nameText);
		
        //addEventListener(MouseEvent.CLICK, onClick);

		onNotifierChanged();
	}

    function onToggleClicked()
    {
        notifier.value = !notifier.value;
    }

    //function onNotifierChanged() updateIndicator(notifier.value);
    function onNotifierChanged()
    {
        toggle.selected.value = notifier.value;
    }

    /*function onClick(e:MouseEvent)
    {
        if(notifier != null) notifier.value = !notifier.value;
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
	}*/
	
}
package multitaction.debug.overlay.marker;

import openfl.text.TextFormat;
import openfl.display.Sprite;
import openfl.text.TextField;
import multitaction.model.marker.IMarkerObjectsModel.MarkerObjectElement;

/**
 * ...
 * @author Michal Moczynski
 */
 @:noCompletion
class DebugMarkerView extends Sprite 
{
	var text:TextField;

	public function new() 
	{
		super();

        mouseEnabled = false;

        graphics.beginFill(0x444444, 0.3);
        graphics.drawRect(-75, -75, 150, 150);
        graphics.endFill();
		
		text = new TextField();
        text.defaultTextFormat = new TextFormat('_typewriter', 24, 0xffffff);
        text.width = 100;
        text.height = 100;
		text.x = 50;
        text.mouseEnabled = false;
		addChild(text);		
	}
	
	public function setID(classID:Int, uid:String)
	{
		text.text = Std.string(classID) + "\n" + Std.string(uid);
	}

    public function update(markerObjectsElement:MarkerObjectElement){
        
		x = markerObjectsElement.posScreen.x;
		y = markerObjectsElement.posScreen.y;
//        var scale = markerObjectsElement.safetyRadiusX / 0.1;
//		scaleX = scale;
//		scaleY = scale;
		rotation = markerObjectsElement.rotation * 180 / Math.PI;
    }
	
}
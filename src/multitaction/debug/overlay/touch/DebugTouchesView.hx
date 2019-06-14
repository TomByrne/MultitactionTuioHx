package multitaction.debug.overlay.touch;

import multitaction.model.touch.ITouchObjectsModel;
import openfl.display.Sprite;

/**
 * ...
 * @author Michal Moczynski
 */
 @:noCompletion
class DebugTouchesView extends Sprite 
{
    var touchObjectsModel:ITouchObjectsModel;
	var touchIndicators:Map<Int, DebugTouchView> = new Map<Int, DebugTouchView>();
	
	public function new() 
	{
		super();		
	}
	
	public function initialize(touchObjectsModel:ITouchObjectsModel) 
	{
        this.touchObjectsModel = touchObjectsModel;
        touchObjectsModel.onProcessed.add(onTouchesProcessed);
	}

    function onTouchesProcessed()
    {
        if(!visible) return;

        for(touch in touchObjectsModel.touchList)
        {
            var id:UInt = touch.id;
            if(touch.state == TouchState.END){
                var t:DebugTouchView = touchIndicators.get(id);
                if (t != null)
                {
                    removeChild(t);
                    t = null;
                    touchIndicators.remove(id);
                }
            }else{
                addOrUpdateTouch(id, touch);
            }
        }

		for (id in touchIndicators.keys())
		{
            if(Lambda.find( touchObjectsModel.touchList, touch -> touch.id == id) == null)
            {
                var t:DebugTouchView = touchIndicators.get(id);
                if (t != null)
                {
                    t.scaleX = t.scaleY = 0.3;
                    haxe.Timer.delay( removeTouchIndicator.bind(id), 3000);
                }
            }
        }
    }
	
	function removeTouchIndicator(id:Int):Void 
    {
        var t:DebugTouchView = touchIndicators.get(id);
        if (t != null)
        {
            removeChild(t);
            t = null;
            touchIndicators.remove(id);
        }
    }
	function addOrUpdateTouch(id:Int, cursor:TouchObject):Void 
	{
        var t:DebugTouchView = touchIndicators.get(id);
		if (t != null)
		{
			t.updateData(cursor.x, cursor.y);
		}
		else
		{
			var t:DebugTouchView = new DebugTouchView();
			t.updateData(cursor.x, cursor.y);
			addChild(t);
			touchIndicators.set(id, t);
		}	
	}
	
}
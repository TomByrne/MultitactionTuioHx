package multitaction.view.starling.touch;

import multitaction.model.touch.ITouchObjectsModel;
import multitaction.view.starling.touch.DebugTouchView;
import starling.display.Sprite;
import org.tuio.TuioCursor;

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

        for(id in touchObjectsModel.cursorsAdded.keys())
        {
            addOrUpdateTouch(id, touchObjectsModel.cursorsAdded.get(id));
        }
        for(id in touchObjectsModel.cursorsUpdated.keys())
        {
            addOrUpdateTouch(id, touchObjectsModel.cursorsUpdated.get(id));
        }
        for(id in touchObjectsModel.cursorsRemoved.keys())
        {
            var t:DebugTouchView = touchIndicators.get(id);
            if (t != null)
            {
                removeChild(t);
                t = null;
                touchIndicators.remove(id);
            }
        }
    }
	
	function addOrUpdateTouch(id:Int, cursor:TuioCursor):Void 
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
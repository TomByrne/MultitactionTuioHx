package multitaction.model.touch;

import org.tuio.TuioCursor;
import imagsyd.signals.Signal;
import multitaction.model.touch.ITouchObjectsModel;

/**
 * ...
 * @author Michal Moczynski
 */
@:rtti
class TouchObjectsModel implements ITouchObjectsModel
{
    public var touchList:Array<TouchObject> = [];
    public var touches:Map<UInt, TouchObject> = new Map<UInt, TouchObject>();  
    
	public var onProcessed:Signal0 = new Signal0();

	public function new() 
	{
		
	}

	public function tick()
	{
	}

    public function processed()
	{
        onProcessed.dispatch();

        var i = 0;
        while(i < touchList.length){
            var touch = touchList[i];
            if(touch.state == TouchState.END){
                touchList.splice(i, 1);
                touches.remove(touch.id);
            }else{
                i++;
            }
        }
    }

    public function abortTouch(id:UInt):Void
    {
        var touch = touches.get(id);
        if(touch == null) return;
        touches.remove(id);
        touchList.remove(touch);
    }
	
}
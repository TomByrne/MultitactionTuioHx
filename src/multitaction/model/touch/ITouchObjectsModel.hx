package multitaction.model.touch;

import org.tuio.TuioCursor;
import imagsyd.signals.Signal;

/**
 * ...
 * @author Michal Moczynski
 */
interface ITouchObjectsModel 
{
    public var touchList:Array<TouchObject>;
	public var touches:Map<UInt, TouchObject>;
    
	public var onProcessed:Signal0;
	
	public function tick():Void;
	public function processed():Void;

    public function abortTouch(id:UInt):Void;
}

typedef TouchObject =
{
    id:UInt,
    state:TouchState,

    x:Float,
    y:Float,
    rangeX:Float,
    rangeY:Float,

    cursor:TuioCursor,
}

@:enum abstract TouchState(String)
{
    var START = 'start';
    var MOVE = 'move';
    var END = 'end';
}
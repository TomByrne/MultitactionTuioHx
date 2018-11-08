package imagsyd.multitaction.model;
import openfl.geom.Point;
import org.tuio.TuioObject;

/**
 * ...
 * @author Michal Moczynski
 */
class TuioObjectsModel implements ITuioObjectsModel
{
	public var tuioObjects:Array<TuioObjectElement> = [];
	public var tuioObjectsMap:Map<UInt, UInt> = new Map<UInt, UInt>();//tuioObjects array id by sessionId
	
	public function new() 
	{
		
	}
	
}

typedef TuioObjectElement =
{
	pos:Array<Point>,
	r:Float,
	sessionId:UInt,
	classId:UInt,
	frameId:UInt
}
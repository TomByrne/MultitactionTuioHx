package imagsyd.multitaction.model;
import imagsyd.multitaction.model.TuioObjectsModel;
import imagsyd.multitaction.model.TuioObjectsModel.TuioObjectElement;

/**
 * ...
 * @author Michal Moczynski
 */
interface ITuioObjectsModel 
{
	public var tuioObjects:Array<TuioObjectElement>;
	public var tuioObjectsMap:Map<UInt, UInt>;
}
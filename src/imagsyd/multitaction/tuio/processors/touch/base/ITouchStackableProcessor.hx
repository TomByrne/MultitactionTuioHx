package imagsyd.multitaction.tuio.processors.touch.base;

/**
 * ...
 * @author Michal Moczynski
 */
interface ITouchStackableProcessor 
{

	public var displayName:String;
	public var active:Notifier<Bool>;
	
	//function process(outputArray:Array<MarkerObjectElement>):Void;
	
}
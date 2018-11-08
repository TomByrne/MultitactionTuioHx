package imagsyd.multitaction.tuio.touch.processors;

/**
 * ...
 * @author Michal Moczynski
 */
interface ITouchStackableProcessor 
{

	public var displayName:String;
	public var active:Notifier<Bool>;
	
	//function process(outputArray:Array<TuioObjectElement>):Void;
	
}
package multitaction.model.touch;
import multitaction.model.marker.IMarkerObjectsModel;
import multitaction.logic.processors.marker.base.ITuioStackableProcessor;

/**
 * ...
 * @author Michal Moczynski
 */
@:rtti
class TouchProcessorsModel
{
	/*
	@inject markerObjectsModel:TuioObjectsModel;
	*/
	@inject public var markerObjectsModel:IMarkerObjectsModel;
	@inject public var touchObjectsModel:TouchObjectsModel;
	
	public var tuioTouchProcessors:Array<ITuioStackableProcessor> = [];
	
	public function new() 
	{
	
	}
	
}

package multitaction.model.touch;
import org.swiftsuspenders.utils.DescribedType;
import multitaction.model.marker.IMarkerObjectsModel;
import multitaction.logic.processors.marker.base.ITuioStackableProcessor;

/**
 * ...
 * @author Michal Moczynski
 */
class TouchProcessorsModel implements DescribedType
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

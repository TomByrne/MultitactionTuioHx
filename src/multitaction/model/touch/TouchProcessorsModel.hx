package multitaction.model.touch;
import multitaction.model.marker.IMarkerObjectsModel;
import multitaction.logic.processors.marker.base.ITuioStackableProcessor;
import multitaction.logic.processors.touch.MarkerProximityTouchFilter;

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
	
	public function start()
	{		
		tuioTouchProcessors.push( new MarkerProximityTouchFilter(true, markerObjectsModel, touchObjectsModel ));
	}
	
}

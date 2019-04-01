package multitaction.model.touch;
import multitaction.model.marker.MarkerObjectsModel;
import multitaction.tuio.processors.marker.base.ITuioStackableProcessor;
import multitaction.tuio.processors.touch.MarkerProximityTouchFilter;

/**
 * ...
 * @author Michal Moczynski
 */
@:rtti
class TuioTouchesStackableProcessesModel
{
	/*
	@inject markerObjectsModel:TuioObjectsModel;
	*/
	@inject public var markerObjectsModel:MarkerObjectsModel;
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

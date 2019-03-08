package multitaction.model.touch;
import multitaction.model.marker.MarkerObjectsModel;
import multitaction.tuio.processors.maker.base.ITuioStackableProcessor;
import multitaction.tuio.processors.touch.MarkerPoximityTouchFilter;

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
		tuioTouchProcessors.push( new MarkerPoximityTouchFilter(true, markerObjectsModel, touchObjectsModel ));
	}
	
}

package com.imagination.multitaction.core.services.tuio.process;
import com.imagination.multitaction.core.managers.Marker;

/**
 * ...
 * @author Michal Moczynski
 */
class RoundCoordinatesMarkerProcess implements IMarkerProcess
{

	public function new() 
	{
		
	}
	
	public function process(marker:Marker):Marker
	{
		marker.x = Math.round(marker.x);
		marker.y = Math.round(marker.y);
		
		return marker;
	}
}
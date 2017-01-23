package imagsyd.imagination.services.tuio.process;
import imagsyd.imagination.managers.Marker;

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
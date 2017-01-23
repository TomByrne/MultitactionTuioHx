package imagsyd.imagination.services.tuio.process;
import imagsyd.imagination.managers.Marker;

/**
 * ...
 * @author Michal Moczynski
 */
class SnapAngleMarkerProcess implements IMarkerProcess
{
	private var snapAngle:Float = .4;
	static public inline var PI2:Float = 6.28318530718;

	public function new() 
	{
		
	}
		
	public function process(marker:Marker):Marker
	{
		if (marker.rotation < snapAngle || marker.rotation > PI2 - snapAngle)
			marker.rotation = 0;
		else if (marker.rotation > Math.PI - snapAngle && marker.rotation < Math.PI + snapAngle)
			marker.rotation = Math.PI;
			
		return marker;
	}
}
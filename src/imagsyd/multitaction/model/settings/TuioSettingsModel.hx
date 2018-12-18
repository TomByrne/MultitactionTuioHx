package imagsyd.multitaction.model.settings;

import imagsyd.geom.Point;
import imagsyd.notifier.Notifier;

/**
 * ...
 * @author Michal Moczynski
 */
class TuioSettingsModel 
{
	
	public var nativeScreenSize = new Notifier<Point>( new Point(3840, 2160) );
	
	public function new() 
	{
		
	}
}
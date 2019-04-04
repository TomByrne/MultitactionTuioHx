package multitaction.model.settings;

import imagsyd.geom.Point;
import imagsyd.notifier.Notifier;

/**
 * ...
 * @author Michal Moczynski
 */
class MultitactionSettingsModel 
{
	
	public var nativeScreenSize = new Notifier<Point>( new Point(3840, 2160) );
    
	public var debugTouchShown = new Notifier<Bool>( false );
    
	public var debugMarkerShown = new Notifier<Bool>( false );
}
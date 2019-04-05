package multitaction.model.settings;

import multitaction.utils.MarkerPoint;
import imagsyd.notifier.Notifier;

/**
 * ...
 * @author Michal Moczynski
 */
class MultitactionSettingsModel 
{
	
	public var nativeScreenSize = new Notifier<MarkerPoint>( {x:1920, y:1080} );
    
	public var debugTouchShown = new Notifier<Bool>( false );
    
	public var debugMarkerShown = new Notifier<Bool>( false );
}
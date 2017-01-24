package com.imagination.multitaction.core.managers;
import com.imagination.util.signals.Signal.Signal1;
import com.imagination.util.signals.Signal.Signal2;
import starling.events.Touch;

/**
 * ...
 * @author Michal Moczynski
 */
@:rtti
@:keepSub
class TuioMarkerManager
{

	public var onBegin:Signal1<Marker> = new Signal1(Marker);
	public var onMove:Signal1<Marker> = new Signal1(Marker);
	public var onEnd:Signal1<Marker> = new Signal1(Marker);

	public function new() 
	{
		
	}
	
}
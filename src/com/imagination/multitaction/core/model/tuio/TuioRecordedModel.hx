package com.imagination.multitaction.core.model.tuio;
import org.tuio.TuioBlob;
import org.tuio.TuioCursor;
import org.tuio.TuioObject;
/**
 * ...
 * @author Michal Moczynski
 */
@:rtti
@:keepSub
class TuioRecordedModel
{
	public var recordedAddedObjects:Array<TuioCursor> = new Array<TuioCursor>();
	public var recordedChangedObjects:Array<TuioCursor> = new Array<TuioCursor>();
	public var recordedRemovedObjects:Array<TuioCursor> = new Array<TuioCursor>();
//	public var recordedBlobs:Array<Array<TuioObject>> = new Array<Array<TuioBlob>()>;
//	public var recordedTuioCursors:Array<Array<TuioObject>> = new Array<Array<TuioCursor>>();
	
	public function new() 
	{
		
	}
	
}
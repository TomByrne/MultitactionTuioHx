package multitaction.tuio.view.starling.display.debugMarkers;
import multitaction.model.marker.MarkerObjectsModel;
import multitaction.tuio.listener.MultitactionCardListener;
import multitaction.tuio.view.starling.display.debugMarkers.marker.TuioDebugMarkerView;
import multitaction.tuio.view.starling.display.debugMarkers.marker.TuioDebugMarkerViewMediator;
import robotlegs.bender.bundles.mvcs.Mediator;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;

/**
 * ...
 * @author Michal Moczynski
 */

@:rtti
class DebugMarkersViewMediator extends Mediator 
{
	@inject public var view:DebugMarkersView;
	@inject public var mediatorMap:IMediatorMap;
	@inject public var markerObjectsModel:MarkerObjectsModel;
	
	public function new() 
	{
	}
	
	override public function initialize():Void
	{
		mediatorMap.map(TuioDebugMarkerView).toMediator(TuioDebugMarkerViewMediator);
		view.initialize(markerObjectsModel);
	}
	
	override public function destroy():Void
	{
		view.dispose();
	}
	
	override public function postDestroy():Void
	{
		super.postDestroy();
	}	
}
package imagsyd.multitaction.tuio.view.starling.display.debugMarkers;
import imagsyd.multitaction.model.TuioObjectsModel;
import imagsyd.multitaction.tuio.listener.MastercardCardListener;
import imagsyd.multitaction.tuio.view.starling.display.debugMarkers.marker.TuioDebugMarkerView;
import imagsyd.multitaction.tuio.view.starling.display.debugMarkers.marker.TuioDebugMarkerViewMediator;
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
	@inject public var tuioObjectsModel:TuioObjectsModel;
	
	public function new() 
	{
	}
	
	override public function initialize():Void
	{
		mediatorMap.map(TuioDebugMarkerView).toMediator(TuioDebugMarkerViewMediator);
		view.initialize(tuioObjectsModel);
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
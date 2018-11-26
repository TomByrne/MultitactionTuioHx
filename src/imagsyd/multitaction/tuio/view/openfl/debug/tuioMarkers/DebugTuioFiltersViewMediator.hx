package imagsyd.multitaction.tuio.view.openfl.debug.tuioMarkers;
import imagsyd.multitaction.model.marker.MarkerObjectsModel;
import imagsyd.multitaction.model.marker.TuioMarkersStackableProcessesModel;
import imagsyd.multitaction.tuio.view.openfl.debug.tuioMarkers.DebugTuioFiltersView;
import imagsyd.multitaction.tuio.view.openfl.debug.tuioMarkers.element.TuioProcessesPanelElementView;
import imagsyd.multitaction.tuio.view.openfl.debug.tuioMarkers.element.TuioProcessesPanelElementViewMediator;
import robotlegs.bender.bundles.mvcs.Mediator;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;

/**
 * ...
 * @author Michal Moczynski
 */

@:rtti
class DebugTuioFiltersViewMediator extends Mediator 
{
	@inject public var view:DebugTuioFiltersView;
	@inject public var mediatorMap:IMediatorMap;
	@inject public var tuioStackableProcessesModel:TuioMarkersStackableProcessesModel;	
	@inject public var markerObjectsModel:MarkerObjectsModel;
	
	public function new() 
	{
	}
	
	override public function initialize():Void
	{
		mediatorMap.map(TuioProcessesPanelElementView).toMediator(TuioProcessesPanelElementViewMediator);
		view.initialize(tuioStackableProcessesModel.tuioMarkerProcessors, markerObjectsModel.markerObjectsMap);
	}
	
	override public function destroy():Void
	{
//		view.dispose();
	}
	
	override public function postDestroy():Void
	{
		super.postDestroy();
	}
}
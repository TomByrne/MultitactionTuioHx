package multitaction;

import imagsyd.base.BaseBundle;
import multitaction.command.TuioDebugKeyboardCommand;
import multitaction.logic.TuioDebugViewsLogic;
import multitaction.model.marker.*;
import multitaction.model.settings.TuioSettingsModel;
import multitaction.model.touch.*;
import multitaction.tuio.*;
import multitaction.tuio.listener.*;
import multitaction.tuio.view.openfl.debug.touchPanel.DebugTuioTouchPanelView;
import multitaction.tuio.view.openfl.debug.touchPanel.DebugTuioTouchPanelViewMediator;
import multitaction.tuio.view.openfl.debug.tuioMarkers.DebugTuioFiltersView;
import multitaction.tuio.view.openfl.debug.tuioMarkers.DebugTuioFiltersViewMediator;
import multitaction.tuio.view.starling.display.touches.TouchDebugView;
import multitaction.tuio.view.starling.display.touches.TouchDebugViewMediator;
import imagsyd.startup.signals.StartupCompleteSignal;
import multitaction.logic.adapters.*;
import robotlegs.bender.framework.api.IContext;

/**
 * ...
 * @author Michal Moczynski
 */

@:rtti
@:keepSub
class BundleMultitaction extends BaseBundle 
{
	override public function extend(context:IContext):Void
	{
		BaseBundle.compilerDefine(["bundle_multitaction"]);
		
		add(context, [TuioTouchesSettingsModel, TuioSettingsModel,
                        TuioMarkersStackableProcessesModel, TuioTouchesStackableProcessesModel], { shared:true });
		
		add(context, [MarkerObjectsModel], { shared:true, aliases:[IMarkerObjectsModel] });
		add(context, [TouchObjectsModel], { shared:true, aliases:[ITouchObjectsModel] });
		
		#if !omitTuioComms
		add(context, [TuioService, MultitactionCardListener], { shared:true });
		#end
        
		add(context, [TuioDebugViewsLogic], { shared:true });
		
		mapMediator(context, TouchDebugView, TouchDebugViewMediator);
		mapMediator(context, DebugTuioFiltersView, DebugTuioFiltersViewMediator);
		mapMediator(context, DebugTuioTouchPanelView, DebugTuioTouchPanelViewMediator);		
		
		mapCommand(context, StartupCompleteSignal, TuioDebugKeyboardCommand);	

        #if (!omit_mt_touch_adapter)
            #if (html5)
                add(context, [DomTouchAdapterLogic], { setup:true });
            #elseif (openfl)
                add(context, [OpenflTouchAdapterLogic], { setup:true });
            #end
        #end	
	}
}
package multitaction;

import imagsyd.base.BaseBundle;
import imagsyd.startup.signals.StartupCompleteSignal;
import robotlegs.bender.framework.api.IContext;
import multitaction.model.marker.*;
import multitaction.model.settings.MultitactionSettingsModel;
import multitaction.model.touch.*;
import multitaction.logic.tuio.*;
import multitaction.logic.listener.*;
import multitaction.logic.processors.*;
import multitaction.logic.settings.*;
import multitaction.view.openfl.debug.*;
import multitaction.logic.adapters.*;
import multitaction.view.starling.*;
import multitaction.view.starling.touch.*;
import multitaction.view.starling.marker.*;

/**
 * ...
 * @author Michal Moczynski
 */
class BundleMultitaction extends BaseBundle 
{
	override public function extend(context:IContext):Void
	{
		BaseBundle.compilerDefine(["bundle_multitaction"]);
		
		add(context, [MultitactionSettingsModel, MarkerProcessorsModel, TouchProcessorsModel], { shared:true });
		
		add(context, [MarkerObjectsModel], { shared:true, aliases:[IMarkerObjectsModel] });
		add(context, [TouchObjectsModel], { shared:true, aliases:[ITouchObjectsModel] });
		
		#if !omitTuioComms
		add(context, [TuioConfigLogic, MultitactionCardListener, MarkerProcessorsLogic, TouchProcessorsLogic, MultitactionSettingsLogic], { setup:true });
		#end
        
		
        #if starling
		mapMediator(context, DebugTouchesView, DebugTouchesViewMediator);
		mapMediator(context, DebugMarkersView, DebugMarkersViewMediator);
		add(context, [MultitactionDebugViews], { setup:true });
        
		addDebugPanel(context, MultitactionDebugPanel, MultitactionDebugPanelMediator);
        #end	
		
        #if (!omit_mt_keybinding)
		    mapCommand(context, StartupCompleteSignal, multitaction.command.TuioDebugKeyboardCommand);	
        #end

        #if (!omit_mt_touch_adapter)
            #if (html5)
                add(context, [DomTouchAdapterLogic], { setup:true });
            #elseif (openfl)
                add(context, [OpenflTouchAdapterLogic], { setup:true });
            #end
        #end

        
	}
}
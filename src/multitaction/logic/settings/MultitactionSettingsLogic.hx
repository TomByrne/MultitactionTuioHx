package multitaction.logic.settings;

import org.swiftsuspenders.utils.DescribedType;
import multitaction.model.settings.MultitactionSettingsModel;

class MultitactionSettingsLogic implements DescribedType
{
	@inject public var multitactionSettingsModel:MultitactionSettingsModel;

    @:keep public function setup()
    {
        #if openfl

        var stage:openfl.display.Stage = openfl.Lib.current.stage;
        function onResize(e){
            multitactionSettingsModel.nativeScreenSize.value.x = stage.stageWidth;
            multitactionSettingsModel.nativeScreenSize.value.y = stage.stageHeight;
            multitactionSettingsModel.nativeScreenSize.dispatch();
        }
        stage.addEventListener(openfl.events.Event.RESIZE, onResize);
        onResize(null);

        #elseif lime

        function onResize(width:Int, height:Int){
            multitactionSettingsModel.nativeScreenSize.value.x = width;
            multitactionSettingsModel.nativeScreenSize.value.y = height;
            multitactionSettingsModel.nativeScreenSize.dispatch();
        }
        lime.app.Application.window.onResize = onResize;
        onResize(lime.app.Application.window.width, lime.app.Application.window.height);

        #end
    }
}
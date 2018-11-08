package imagsyd.multitaction.tuio.view.openfl.debug.touchPanel;
import com.imagination.core.type.Notifier;
import com.imagination.core.view.openfl.debug.base.BaseDebugPanel;
import imagsyd.multitaction.tuio.view.openfl.debug.touchPanel.DebugToggleView;
import openfl.display.Quad;

/**
 * ...
 * @author Michal Moczynski
 */
class DebugTuioTouchPanelView extends BaseDebugPanel
{
	var background:openfl.display.Quad;
	var windowsTouchToggle:imagsyd.multitaction.tuio.view.openfl.debug.touchPanel.DebugToggleView;
	var tuioTouchToggle:imagsyd.multitaction.tuio.view.openfl.debug.touchPanel.DebugToggleView;
	var showTouchesToggle:imagsyd.multitaction.tuio.view.openfl.debug.touchPanel.DebugToggleView;

	public function new() 
	{
		super();
		label.value = "TUIO TOUCHES";
	}
	
	public function initialize(tuioNotifier:Notifier<Bool>, winNotifier:Notifier<Bool>, showNotifier:Notifier<Bool> ) 
	{
		background = new Quad(800, 600, 0xffffff);
		addChild(background);
		
		windowsTouchToggle = new DebugToggleView( winNotifier, "Windows touches (ctrl + shift + w)" );
		windowsTouchToggle.x = 15;
		windowsTouchToggle.y = 15;
		addChild( windowsTouchToggle );
		
		tuioTouchToggle = new DebugToggleView( tuioNotifier, "TUIO touches (ctrl + shift + t)" );
		tuioTouchToggle.x = 15;
		tuioTouchToggle.y = 45;
		addChild( tuioTouchToggle );
		
		showTouchesToggle = new DebugToggleView( showNotifier, "Show touches" );
		showTouchesToggle.x = 15;
		showTouchesToggle.y = 75;
		addChild( showTouchesToggle );
	}
	
	override public function setLocation(x:Float, y:Float, w:Float, h:Float):Void 
	{
		this.x = x;
		this.y = y;
		
		background.width = w;		
		background.height = h;
	}	
}
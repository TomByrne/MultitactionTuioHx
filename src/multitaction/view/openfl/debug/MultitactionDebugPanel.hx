package multitaction.view.openfl.debug;

import imagsyd.debug.view.base.BaseDebugPanel;
import imagsyd.time.EnterFrame;
import imagsyd.notifier.Notifier;
import multitaction.model.marker.MarkerObjectsModel;
import multitaction.model.marker.MarkerObjectsModel.MarkerObjectElement;
import multitaction.logic.processors.marker.base.ITuioStackableProcessor;
import multitaction.view.openfl.debug.element.MultitactionProcessDebugView;
import openfl.display.Quad;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * ...
 * @author Michal Moczynski
 */
class MultitactionDebugPanel  extends BaseDebugPanel 
{
	var background:openfl.display.Quad;
	var markersMap:Map<String, MarkerObjectElement>;
	var markersList:openfl.text.TextField;
	var markersListLabel:openfl.text.TextField;
	static public inline var TOP_Y_POS:Float = 20;
	static public inline var SPACING:Float = 35;
	
	public function new() 
	{
		super();
        id = 'multitaction';
		label.value = "MULTITACTION";
	}
	
	public function initialize(showTouches:Notifier<Bool>, showMarkers:Notifier<Bool>, processors:Array<ITuioStackableProcessor>, markersMap:Map<String, MarkerObjectElement>) 
	{
		this.markersMap = markersMap;

		background = new Quad(600, 400, 0xffffff);
		addChild(background);	
        
		var posY:Float = TOP_Y_POS;	
		
		var showTouchesToggle:DebugToggleView = new DebugToggleView( "Show Touches", showTouches );
		showTouchesToggle.x = 15;
		showTouchesToggle.y = posY;
		addChild( showTouchesToggle );
		
		var showMarkersToggle:DebugToggleView = new DebugToggleView( "Show Markers", showMarkers );
		showMarkersToggle.x = showTouchesToggle.x + 200;
		showMarkersToggle.y = posY;
		addChild( showMarkersToggle );

        posY += 50;
		
		
		for ( p in processors ) 
		{
			var element:MultitactionProcessDebugView = new MultitactionProcessDebugView(p);
			element.x = 15;
			element.y = posY;
			addChild(element);
			
			posY += SPACING;
		}
		
		markersListLabel = new TextField();
		markersListLabel.defaultTextFormat = new TextFormat("_typewriter", 17, 0x555555, null, null, null, null, null, TextFormatAlign.LEFT);
		markersListLabel.text = "List of markers:";
		markersListLabel.x = 15;
		markersListLabel.y = posY + 15;
		addChild(markersListLabel);
		
		markersList = new TextField();
		markersList.defaultTextFormat = new TextFormat("_typewriter", 17, 0x555555, null, null, null, null, null, TextFormatAlign.LEFT);
		markersList.text = "No markers on the table.";
		markersList.width = 200;
		markersList.height = 30;
		markersList.x = 15;
		markersList.y = posY + 40;
		addChild(markersList);
		
		EnterFrame.add( handleFrame );
	}
	
	function handleFrame():Void 
	{
		markersList.text = "";
		for (marker in markersMap) 
		{
			markersList.text += "marker - code: " + marker.cardId + " uid: " + marker.uid + " pos: " + fixedFloat(marker.pos.x) + ", " + fixedFloat(marker.pos.y) + " rot: " + marker.rotation +"\n";
		}
		if (Lambda.count( markersMap ) == 0)
		{
			markersList.text = "No markers on the table.";			
		}
	}
	
	public function fixedFloat(v:Float, ?precision:Int = 3):Float
	{
	return Math.round( v * Math.pow(10, precision) ) / Math.pow(10, precision);
	}	
	
	override public function setLocation(x:Float, y:Float, w:Float, h:Float):Void 
	{
		this.x = x;
		this.y = y;
		
		background.width = w;		
		background.height = h;
		markersList.width = w - 30;
		markersListLabel.width = markersList.width;
		markersList.height = h - markersList.y - 10;
	}
}
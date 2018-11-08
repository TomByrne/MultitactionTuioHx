package imagsyd.multitaction.tuio.view.openfl.debug.tuioMarkers;
import imagsyd.multitaction.model.TuioObjectsModel;
import com.imagination.core.view.openfl.debug.base.BaseDebugPanel;
import com.imagination.util.time.EnterFrame;
import imagsyd.multitaction.model.TuioObjectsModel.TuioObjectElement;
import imagsyd.multitaction.tuio.processors.base.ITuioStackableProcessor;
import imagsyd.multitaction.tuio.view.openfl.debug.tuioMarkers.element.TuioProcessesPanelElementView;
import openfl.display.Quad;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import starling.display.Sprite;

/**
 * ...
 * @author Michal Moczynski
 */
class DebugTuioFiltersView  extends BaseDebugPanel 
{
	var background:openfl.display.Quad;
	var container:starling.display.Sprite;
	var markersArray:Array<TuioObjectElement>;
	var markersList:openfl.text.TextField;
	var markersListLabel:openfl.text.TextField;
	static public inline var TOP_Y_POS:Float = 20;
	static public inline var SPCAING:Float = 35;
	
	public function new() 
	{
		super();
		label.value = "TUIO FILTERS";
	}
	
	public function initialize(processors:Array<ITuioStackableProcessor>, markersArray:Array<TuioObjectElement>) 
	{
		this.markersArray = markersArray;
		background = new Quad(600, 400, 0xffffff);
		addChild(background);		
		
		
		var posY:Float = TOP_Y_POS;
		for ( p in processors ) 
		{
			var element:TuioProcessesPanelElementView = new TuioProcessesPanelElementView(p);
			element.x = 15;
			element.y = posY;
			addChild(element);
			
			posY += SPCAING;
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
		for (marker in markersArray) 
		{
			markersList.text += "marker - code: " + marker.classId + " session: " + marker.sessionId + " pos: " + fixedFloat(marker.pos[0].x) + ", " + fixedFloat(marker.pos[0].y) + " rot: " + marker.r +"\n";
		}
		if (markersArray.length == 0)
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
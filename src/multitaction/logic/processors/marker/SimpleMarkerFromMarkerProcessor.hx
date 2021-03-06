package multitaction.logic.processors.marker;
import imagsyd.signals.Signal.Signal1;
import imagsyd.notifier.Notifier;
import multitaction.logic.listener.BasicProcessableTuioListener;
import multitaction.logic.processors.marker.base.ITuioStackableProcessor;
import org.tuio.TuioObject;
import multitaction.model.marker.IMarkerObjectsModel;
import multitaction.utils.GeomTools;
import multitaction.utils.MarkerUID;
import multitaction.utils.MarkerPoint;


/**
 * ...
 * @author Michal Moczynski
 */
class SimpleMarkerFromMarkerProcessor implements ITuioStackableProcessor
{
	var doubleUpThreshold:Float = 200/1920;//distance in screen fraction (that's what tuio uses)
	var itemFound:Bool;
	var markerObjectsModel:IMarkerObjectsModel;

	public var displayName:String = "Create Markers";
	public var angleThreshold:Float = 30;
	public var active:Notifier<Bool> = new Notifier<Bool>(true);

	public function new(active:Bool, markerObjectsModel:IMarkerObjectsModel) 
	{
		this.active.value = active;
		this.markerObjectsModel = markerObjectsModel;
	}

	public function process(listener:BasicProcessableTuioListener):Void
	{
		for ( moe in markerObjectsModel.markerObjectsMap)
		{
			moe.alive = false;			
		}
		
		for (  to in listener.tuioObjects ) 
		{
			if ( markerObjectsModel.tuioToMarkerMap.exists( "t" + to.sessionID ) == false )
			{
				addNewMarker( to );
			}
			else
			{
				updateMarker( to );
			}
		}
		
		for ( moe in markerObjectsModel.markerObjectsMap)
		{
			if ( !moe.alive && moe.fromTuio)
			{
				markerObjectsModel.frameRemovedMarkers.push( moe.uid );
				markerObjectsModel.markerObjectsMap.remove( moe.uid );
			}
		}
	}
	
	function updateMarker(to:TuioObject) 
	{
		var moe:MarkerObjectElement = markerObjectsModel.markerObjectsMap.get( markerObjectsModel.tuioToMarkerMap.get("t" + to.sessionID ) );
		moe.inputRotation = to.a;
		moe.outputRotation = to.a;
		moe.alive = true;
		moe.frameId = to.frameID;
		moe.fractPos.unshift( { x:to.x, y:to.y } );

		if (moe.fractPos.length > 10)
			moe.fractPos.pop();

		if (moe.cardId != to.classID)
		{
			moe.previousCardId = moe.cardId;
			moe.cardId = to.classID;
			moe.cardIdChanged.dispatch(moe.uid);
			Log.log("Card ID change: " + moe.uid, '${moe.previousCardId} > ${moe.cardId}');
		}
	}
	
	function addNewMarker( to:TuioObject ) 
	{
		var moe:MarkerObjectElement = {
			fractPos:new Array<MarkerPoint>(), 
			posApp:{x:0.0, y:0.0}, 
			posScreen:{x:0.0, y:0.0}, 
			prevRotation:to.a, 
			inputRotation:to.a, 
			outputRotation:to.a, 
			uid: MarkerUID.getNextUID(), 
			cardId:to.classID, 
			previousCardId:null,
			tuioCardId:to.classID, 
			cardIdChanged:new Signal1<String>(),
			readCardIds:new Map<UInt,UInt>(), 
			lastCardChangeFrame:to.frameID,
			frameId:to.frameID,
			fromTuio:true, 
			alive:true, 
			safetyRadiusX:0.15,
			safetyRadiusY:0.25
			};

		Log.log( "    added moe with new uid " + moe.uid);
		moe.fractPos.unshift( { x:to.x, y:to.y } );
		
		markerObjectsModel.tuioToMarkerMap.set( "t" + to.sessionID, moe.uid);
		markerObjectsModel.markerObjectsMap.set( moe.uid, moe);
		markerObjectsModel.frameAddedMarkers.push( moe.uid );		
	}
	
	function findAllDoubleUp(tuioObjects:Map<UInt, TuioObject>, object:TuioObject):TuioObject
	{
		for (  to in tuioObjects ) 
		{
			var distance:Float = GeomTools.dist( to.x, to.y, object.x, object.y);
			if (distance < doubleUpThreshold )
			{
				if (to == object)
				{
					itemFound = true;
				}
				else
				{
					return to;
				}
			}
		}
		return null;		
	}
}
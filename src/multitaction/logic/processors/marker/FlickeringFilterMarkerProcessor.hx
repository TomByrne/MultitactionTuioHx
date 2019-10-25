package multitaction.logic.processors.marker;

import imagsyd.signals.Signal.Signal1;
import imagsyd.notifier.Notifier;
import multitaction.logic.listener.BasicProcessableTuioListener;
import multitaction.logic.processors.marker.base.ITuioStackableProcessor;
import org.tuio.TuioObject;
import multitaction.model.marker.IMarkerObjectsModel;
import multitaction.utils.MarkerUID;
import multitaction.utils.GeomTools;
import multitaction.utils.MarkerPoint;

/**
 * ...
 * @author Michal Moczynski
 */
class FlickeringFilterMarkerProcessor implements ITuioStackableProcessor
{
	var markerObjectsModel:IMarkerObjectsModel;
	var frameId:Int;
	
	public var velocityThreshold:Float = 0.08;
	public var movementThreshold:Float = 0.0008;//0.0008;
	public var rotationThreshold:Float = 0.017;
	public var nominalSpeed:Float = 0.02;
	public var distanceThresholdX:Float = 300 / 3840;
	public var distanceThresholdY:Float = 300 / 2160;
	public var maxSpeedMiutiplier:Float = 1;	
	public var keepAliveWhenLost:Int = 100; //for how many frames the lost markr is held in the system (on the top of able setting - better t set it to 1 on th table and handle it here)
	public var displayName:String = "Flicker filter";
	public var active:Notifier<Bool> = new Notifier<Bool>(true);
	
	public var toAge:Map<String, Int> = new Map<String, Int>();
	public var moeUpdatedByAge:Map<String, Int> = new Map<String, Int>();

	var retreiveOnlyTheSameCardId:Bool = false;

	var safeZoneSizeNotifier:Notifier<Float>;
	var safeZoneMaxMultiNotifier:Notifier<Float>;
	var keepAliveNotifier:Notifier<Float>;
	var retreiveMarkersNotifier:Notifier<Bool>;
	
	public function new(active:Bool, markerObjectsModel:IMarkerObjectsModel, safeZoneSizeNotifier:Notifier<Float>, safeZoneMaxMultiNotifier:Notifier<Float>, keepAliveNotifier:Notifier<Float>, retreiveMarkersNotifier:Notifier<Bool>) 
	{
		this.active.value = active;
		this.markerObjectsModel = markerObjectsModel;
		this.safeZoneSizeNotifier = safeZoneSizeNotifier;
		this.safeZoneMaxMultiNotifier = safeZoneMaxMultiNotifier;
		this.keepAliveNotifier = keepAliveNotifier;
		this.retreiveMarkersNotifier = retreiveMarkersNotifier;
		this.safeZoneSizeNotifier.add( handleSafeZoneSizeChanged, false, true );
		this.safeZoneMaxMultiNotifier.add( handleSafeZoneMaxMultiChanged, false, true );
		this.keepAliveNotifier.add( handleKeepAliveNotifierChanged, false, true );
		this.retreiveMarkersNotifier.add( handleRetreiveMarkersNotifierChanged, false, true );
	}
	
	function handleRetreiveMarkersNotifierChanged(val:Bool)
	{
		retreiveOnlyTheSameCardId = val;
	}

	function handleKeepAliveNotifierChanged(val:Float)
	{
		keepAliveWhenLost = Std.int(val);
		this.log("keepAliveWhenLost changed to " + keepAliveWhenLost);
	}

	function handleSafeZoneMaxMultiChanged(val:Float)
	{
		maxSpeedMiutiplier = val;
	}

	function handleSafeZoneSizeChanged(val:Float)
	{
		distanceThresholdX = val/3840;
		distanceThresholdY = val/2160;
	}

	public function process(listener:BasicProcessableTuioListener):Void
	{
		frameId = listener.frame;
		moeUpdatedByAge = new Map<String, Int>();
		
		for (  to in listener.tuioObjects ) 
		{
			toAge.set("t" + to.sessionID, frameId - to.frameID);
			if ( markerObjectsModel.tuioToMarkerMap.exists( "t" + to.sessionID ) == false )
			{
				if ( checkForDoubles( to ) == false)
				{					
					addNewMarker( to );
				}
				else
				{
					updateMarker( to );
				}
			}
			else
			{
				updateMarker( to );
			}
		}
		
		for ( moe in markerObjectsModel.markerObjectsMap)
		{
			if ( moe.frameId != null && listener.frame - moe.frameId > keepAliveWhenLost)
			{
				markerObjectsModel.frameRemovedMarkers.push( moe.uid );
				markerObjectsModel.markerObjectsMap.remove( moe.uid );
				//this.log( "    removed moe with uid " + moe.uid);
			}else{
				moe.outputRotation = moe.inputRotation;
			}
		}
	}
	
	function checkForDoubles( to:TuioObject ):Bool
	{
		var foundDouble:Bool = false;

		for (moe in markerObjectsModel.markerObjectsMap) 
		{
			calculateSafeRadius(moe);
			if (Math.abs(to.x - moe.fractPos[0].x) < moe.safetyRadiusX && Math.abs(to.y - moe.fractPos[0].y) < moe.safetyRadiusY)
			{
				if(retreiveOnlyTheSameCardId == false || to.classID == moe.cardId)
					markerObjectsModel.tuioToMarkerMap.set( "t" + to.sessionID, moe.uid );

				foundDouble = true;				
			}	
		}		
		return foundDouble;
	}
	
	function calculateSafeRadius(moe:MarkerObjectElement)
	{
		var speedMult:Float = 1;
		if(moe.fractPos.length > 3)
		{
			var pos = moe.fractPos[0];
			var pos1 = moe.fractPos[3];
			speedMult = 1 + GeomTools.dist( pos.x, pos.y, pos1.x, pos1.y ) / 0.025;
			if(speedMult > maxSpeedMiutiplier)
				speedMult = maxSpeedMiutiplier;
		}
		moe.safetyRadiusX = distanceThresholdX * speedMult;
		moe.safetyRadiusY = distanceThresholdY * speedMult;
	}

	function updateMarker( to:TuioObject ) 
	{
		var moe:MarkerObjectElement = markerObjectsModel.markerObjectsMap.get( markerObjectsModel.tuioToMarkerMap.get( "t" + to.sessionID ) );
		if (moe == null)//already updated in this frame (by older marker)
			return;
			
		calculateSafeRadius(moe);

		if (moeUpdatedByAge.exists(moe.uid))
		{
			var previousAge:Int = moeUpdatedByAge.get(moe.uid);
			if (toAge.get("t" + to.sessionID) < previousAge)	//the new to is younger
			{
				moe.outputRotation = moe.inputRotation;
				return;
			}
		}
		
		moeUpdatedByAge.set( moe.uid, toAge.get("t" + to.sessionID));		
		
		var vel:Float = Math.abs(to.X * to.Y);
		if( Math.abs( moe.prevRotation - to.a) > rotationThreshold)
		{
			moe.inputRotation = to.a;
			moe.prevRotation = to.a;
		}
		else
			moe.inputRotation = moe.prevRotation;

		if(to.classID == 12) trace('input: ' + (to.x * 3840)+' '+(to.y * 2160));

		moe.outputRotation = moe.inputRotation;
		moe.alive = true;
		moe.frameId = to.frameID;

		//updating card id
		if (moe.cardId != to.classID)
		{
//			this.log("moe.cardId != to.classID " + moe.cardId + " " +  to.classID);

			//TODO: introduce accuracy (low if it flickers constantly)

			//adding the duration of currently recognised tuio card id to the weights map
			var oldVal:UInt = moe.readCardIds.exists(moe.tuioCardId) ? moe.readCardIds.get(moe.tuioCardId) : 0;
			var dur:UInt = moe.frameId - moe.lastCardChangeFrame;
			moe.readCardIds.set(moe.tuioCardId, oldVal + dur );

			//setting tuio card id to the new one
			moe.tuioCardId = to.classID;
			
			//finding the strongest card id (which one was recognised for the longest)
			var maxCardId:UInt = getMaxCardId(moe);
			//checking if the change needs to actually happen
			if(maxCardId != moe.cardId)
			{
				moe.previousCardId = moe.cardId;
				moe.cardId = to.classID;
				moe.cardIdChanged.dispatch(moe.uid);
				this.log("   changing card to " + to.classID);
			}
			else 
			{
//				this.log("   not changing " + maxCardId + " is the strongest");
			}
		}
		//

		if (vel > velocityThreshold || GeomTools.dist(to.x, to.y, moe.fractPos[0].x, moe.fractPos[0].y) > movementThreshold)
		{
			moe.fractPos.unshift( { x:to.x, y:to.y } );
		}
			
		if (moe.fractPos.length > 10)
			moe.fractPos.pop();					
	}
	
	function getMaxCardId(moe:MarkerObjectElement):UInt
	{
		var maxKey:UInt = 0;
		var maxValue:UInt = 0;

		for(id in moe.readCardIds.keys())
		{
			var v:UInt = moe.readCardIds.get(id);
			if( v > maxValue )
			{
				maxValue = v;
				maxKey = id;
			}
		}

		return maxKey;
	}

	function addNewMarker( to:TuioObject ):MarkerObjectElement
	{
		var moe:MarkerObjectElement = {
			fractPos: new Array<MarkerPoint>(), 
			posApp: {x:0.0, y:0.0}, 
			posScreen: {x:0.0, y:0.0}, 
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
			safetyRadiusX:distanceThresholdX,
			safetyRadiusY:distanceThresholdY,
			};

		moe.fractPos.unshift( { x:to.x, y:to.y } );
		this.log( "    added moe with new uid " + moe.uid + " moe.safetyRadius " + moe.safetyRadiusX + " moe.fractPos " + moe.fractPos[0]);
		
		markerObjectsModel.tuioToMarkerMap.set( "t" + to.sessionID, moe.uid);
		markerObjectsModel.markerObjectsMap.set( moe.uid, moe);
		markerObjectsModel.frameAddedMarkers.push( moe.uid );		
		return moe;
	}
	
	/*function traceAllDistances(to:TuioObject) 
	{
		for ( moe in markerObjectsModel.markerObjectsMap)		
		{
            var pos = moe.fractPos[0];
            var pos1 = moe.fractPos[1];
			this.log( "            d: " + GeomTools.dist( to.x, to.y, pos.x, pos.y) + " speed " + GeomTools.dist( pos.x, pos.y, pos1.x, pos1.y) );
		}
	}*/
	
}
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
	public var distanceThreshold:Float = 0.11;
	public var maxSpeedMiutiplier:Float = 2.5;	
	public var keepAliveWhenLost:Int = 100; //for how many frames the lost markr is held in the system (on the top of able setting - better t set it to 1 on th table and handle it here)
	public var displayName:String = "Flicker filter";
	public var active:Notifier<Bool> = new Notifier<Bool>(true);
	
	public var toAge:Map<String, Int> = new Map<String, Int>();
	public var moeUpdatedByAge:Map<String, Int> = new Map<String, Int>();
	
	public function new(active:Bool, markerObjectsModel:IMarkerObjectsModel) 
	{
		this.active.value = active;
		this.markerObjectsModel = markerObjectsModel;
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
			}
		}
	}
	
	function checkForDoubles( to:TuioObject ):Bool
	{
		var foundDouble:Bool = false;

		for (moe in markerObjectsModel.markerObjectsMap) 
		{

			moe.safetyRadius = distanceThreshold;
			if (GeomTools.dist( to.x, to.y, moe.fractPos[0].x, moe.fractPos[0].y ) < distanceThreshold && to.classID == moe.cardId)
			{
				markerObjectsModel.tuioToMarkerMap.set( "t" + to.sessionID, moe.uid );
				foundDouble = true;				
			}	
		}		
		return foundDouble;
	}
	
	function updateMarker( to:TuioObject ) 
	{
		var moe:MarkerObjectElement = markerObjectsModel.markerObjectsMap.get( markerObjectsModel.tuioToMarkerMap.get( "t" + to.sessionID ) );
		if (moe == null)//already updated in this frame (by older marker)
			return;
			
		if (moeUpdatedByAge.exists(moe.uid))
		{
			var reviousAge:Int = moeUpdatedByAge.get(moe.uid);
			if (toAge.get("t" + to.sessionID) < reviousAge)	//he new to is yonger
			{
				return;
			}
		}
		
		moeUpdatedByAge.set( moe.uid, toAge.get("t" + to.sessionID));		
		
		var vel:Float = Math.abs(to.X * to.Y);
		if( Math.abs( moe.prevRotation - to.a) > rotationThreshold)
		{
			moe.rotation = to.a;
			moe.prevRotation = to.a;
		}
		else
			moe.rotation = moe.prevRotation;

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
			rotation:to.a, 
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
			safetyRadius:distanceThreshold};

		moe.fractPos.unshift( { x:to.x, y:to.y } );
		this.log( "    added moe with new uid " + moe.uid + " moe.safetyRadius " + moe.safetyRadius + " moe.fractPos " + moe.fractPos[0]);
		
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
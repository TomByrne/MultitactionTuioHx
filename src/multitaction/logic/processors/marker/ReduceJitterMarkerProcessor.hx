package multitaction.logic.processors.marker;

import imagsyd.geom.GeomTools;
import imagsyd.notifier.Notifier;
import multitaction.logic.listener.BasicProcessableTuioListener;
import multitaction.logic.processors.marker.base.ITuioStackableProcessor;
import multitaction.utils.MarkerPoint;
import multitaction.model.marker.IMarkerObjectsModel;

class ReduceJitterMarkerProcessor implements ITuioStackableProcessor
{
	public var displayName:String = "Reduce Jitter";
	public var active:Notifier<Bool> = new Notifier<Bool>(true);
    
	var markerObjectsModel:IMarkerObjectsModel;
	var nativeScreenSize:Notifier<MarkerPoint>;
	var range:Float;
	var radians:Float;
	var frames:Int;
	var infos:Map<String, MarkerJitterinfo> = new Map();

	public function new(active:Bool, markerObjectsModel:IMarkerObjectsModel, range:Float = 2, degrees:Float = 2, frames:Int = 20) 
	{
		this.active.value = active;
		this.markerObjectsModel = markerObjectsModel;
		this.range = range;
		this.frames = frames;
		this.radians = GeomTools.degsToRads(degrees);
	}

	public function process(listener:BasicProcessableTuioListener):Void
	{
		for ( moe in markerObjectsModel.markerObjectsMap ) 
		{
			if(!moe.fromTuio) continue;

			var x = moe.posScreen.x;
			var y = moe.posScreen.y;
			var r = moe.outputRotation;
			var info:MarkerJitterinfo = infos.get(moe.uid);
			if(info == null){
				infos.set(moe.uid, {
					fromX: x,
					fromY: y,
					fromR: r,
					frames: 0,

				});
				continue;
			}
			if((Math.abs(r - info.fromR) <= radians) && (GeomTools.dist(x, y, info.fromX, info.fromY) <= range)){
				info.frames++;
				if(info.frames == frames){
					info.fromX = x;
					info.fromY = y;
					info.fromR = r;
				}else if(info.frames > frames){
					moe.posScreen.x = info.fromX;
					moe.posScreen.y = info.fromY;
					moe.outputRotation = info.fromR;
				}
			}else{
				info.frames = 0;
				info.fromX = x;
				info.fromY = y;
				info.fromR = r;
			}
		}
	}
}

@:noCompletion
typedef MarkerJitterinfo =
{
	fromX:Float,
	fromY:Float,
	fromR:Float,
	frames:Int,
}
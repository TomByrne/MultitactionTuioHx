package imagsyd.imagination.model;

import imagsyd.imagination.model.box2d.Box2dModel;
import imagsyd.imagination.model.config.ConfigModel;
import imagsyd.imagination.model.content.ContentModel;
import imagsyd.imagination.model.example.ExampleModel;
//import imagsyd.imagination.model.session.SessionModel;
import imagsyd.imagination.model.tuio.TuioRecordedModel;
import imagsyd.imagination.services.tuioRecorder.TuioRecorderService;
import robotlegs.bender.framework.api.IConfig;
import robotlegs.bender.framework.api.IInjector;

/**
 * ...
 * @author Michal Moczynski
 */

@:rtti
@:keepSub
class ModelConfig implements IConfig 
{
	@inject public var injector:IInjector;
	@inject public var configModel:ConfigModel;
	
	public function new() { }
	
	public function configure():Void
	{
		injector.map(ExampleModel).asSingleton();
		injector.map(TuioRecordedModel).asSingleton();
		injector.map(ContentModel).asSingleton();
		injector.map(Box2dModel).asSingleton();
//		injector.map(SessionModel).asSingleton();
		
	}
}
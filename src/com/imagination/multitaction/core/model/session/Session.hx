package com.imagination.multitaction.core.model.session;

/*
import com.imagination.multitaction.core.core.model.content.ContentVO;
import com.imagination.multitaction.core.core.model.content.IndustryVO;
import com.imagination.multitaction.core.core.model.content.ObjectVO;
*/
import flash.geom.Point;
import openfl.Vector;
import org.osflash.signals.Signal;
/**
 * ...
 * @author Thomas Byrne
 */
class Session 
{
	public var creationDate:Date;
	public var marker:SessionMarker;
	
	public var selectedIndustryChanged:Signal = new Signal();
	public var selectedContentChanged:Signal = new Signal();
	public var selectedAssetChanged:Signal = new Signal();
	public var placementChanged:Signal = new Signal();
	public var InterestsChanged:Signal = new Signal();
	public var InterestAdded:Signal = new Signal();
	public var InterestRemoved:Signal = new Signal();
	
	/*
	private var _selectedIndustry:IndustryVO;
	private var _selectedContent:ContentVO;
	private var _selectedAsset:ObjectVO;
	*/
	
	private var _placementX:Float;
	private var _placementY:Float;
	private var _placementRot:Float;
	private var _placementCollision:Bool;
	
	private var _InterestedAssets:Vector<String>;
	private var _InterestedProducts:Vector<String>;
	private var _inCorner:Bool;
	public var dustPosChange:Signal = new Signal();
	public var destY:Float;
	public var destX:Float;
	public var euclideanQuater:Int = 0;
	public var quaterChangedSignal:Signal = new Signal();
	public var inCornerChangedSignal:Signal = new Signal();
	
	public function new() 
	{
		creationDate = new Date();
		_InterestedAssets = new Vector<String>();
		_InterestedProducts = new Vector<String>();
	}
	
	/*
	public function selectIndustry(industry:IndustryVO):Void 
	{
		if (_selectedIndustry == industry) return;
		_selectedIndustry = industry;
		_selectedContent = null;
		_selectedAsset = null;
		selectedIndustryChanged.dispatch(this);
	}
	*/
	
	/*
	public function selectContent(content:ContentVO):Void 
	{
		if (_selectedContent == content) return;
		_selectedContent = content;
		_selectedAsset = null;
		selectedContentChanged.dispatch();
	}
	
	public function selectAsset(asset:ObjectVO):Void 
	{
		if (_selectedAsset == asset) return;
		_selectedAsset = asset;
		selectedAssetChanged.dispatch();
	}
	
	public function get_selectedIndustry():IndustryVO 
	{
		return _selectedIndustry;
	}
	
	public function get_selectedContent():ContentVO 
	{
		return _selectedContent;
	}
	
	public function get_selectedAsset():ObjectVO 
	{
		return _selectedAsset;
	}
	*/
	
	public function get_placementX():Float 
	{
		return _placementX;
	}
	
	public function get_placementRot():Float 
	{
		return _placementRot;
	}
	
	public function get_placementY():Float 
	{
		return _placementY;
	}
	
	public function get_placementCollision():Bool 
	{
		return _placementCollision;
	}
	
	public function get_InterestedAssets():Vector<String> 
	{
		return _InterestedAssets;
	}
	
	public function get_InterestedProducts():Vector<String> 
	{
		return _InterestedProducts;
	}
	
	public function get_inCorner():Bool 
	{
		return _inCorner;
	}
	
	public function set_inCorner(value:Bool):Bool 
	{
		if (_inCorner != value)
		{
			_inCorner = value;
			inCornerChangedSignal.dispatch();
		}
		return _inCorner;
	}
	
	
	public function setPlacement(x:Float, y:Float, rot:Float, collision:Bool):Void {
		if (_placementX == x && _placementY == y && _placementRot == rot) return;
		
		_placementX = x;
		_placementY = y;
		_placementRot = rot;
		_placementCollision = collision;
		placementChanged.dispatch(this);
		
		checkIfInCorner();
	}
	
	private function checkIfInCorner():Void 
	{
		/*var pos:Point = new Point(_placementX, _placementY);
		
		if (Point.distance( pos, SCREEN_CENTRE ) >= MAX_DIST_TO_CENTR)
			inCorner = true;
		else*/
			inCorner = false;
	}
	
	/*
	public function addInterestedAsset(asset:ObjectVO):Void {
		if (_InterestedAssets.indexOf(asset.guid) != -1) return;
		
		_InterestedAssets.push(asset.guid);
		InterestsChanged.dispatch(this);
		InterestAdded.dispatch(asset.guid);
	}
	
	public function removeInterestedAsset(asset:ObjectVO):Void {
		var index:Int = _InterestedAssets.indexOf(asset.guid);
		if (index == -1) return;
		_InterestedAssets.splice(index, 1);
		InterestsChanged.dispatch(this);
		InterestRemoved.dispatch(asset.guid);
	}
	
	public function isInterestedAsset(asset:ObjectVO):Bool {
		return _InterestedAssets.indexOf(asset.guid) != -1;
	}
	
	public function addInterestedProduct(product:ObjectVO):Void {
		if (_InterestedProducts.indexOf(product.guid) != -1) return;
		
		_InterestedProducts.push(product.guid);
		InterestsChanged.dispatch(this);
		InterestAdded.dispatch(product.guid);
	}
	
	public function removeInterestedProduct(product:ObjectVO):Void {
		var index:Int = _InterestedProducts.indexOf(product.guid);
		if (index == -1) return;
		_InterestedProducts.splice(index, 1);
		InterestsChanged.dispatch(this);
		InterestRemoved.dispatch(product.guid);
	}
	
	public function isInterestedProduct(product:ObjectVO):Bool {
		return _InterestedProducts.indexOf(product.guid) != -1;
	}
	
	public function setInitialInterests(assets:Dynamic, products:Dynamic, selectedIndustry:IndustryVO):Void 
	{
		_InterestedAssets = new Vector<String>();
		for(id in assets) {
			_InterestedAssets.push(id);
		}
		
		_InterestedProducts = new Vector<String>();
		for(id in products) {
			_InterestedProducts.push(id);
		}
			
		//selectIndustry(selectedIndustry);
		InterestsChanged.dispatch(this);
	}
	
	public function clearInterests():Void 
	{
		_InterestedProducts = new Vector<String>();
		_InterestedAssets = new Vector<String>();
		InterestsChanged.dispatch(this);
	}
	*/
	public function setDustPosition(destX:Float, destY:Float):Void 
	{
		this.destY = destY;
		this.destX = destX;
		dustPosChange.dispatch();
	}
}
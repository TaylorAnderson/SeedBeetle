package level_editor;
import haxe.Json;
import haxe.ds.Either;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

/**
 * ...
 * @author Taylor
 */

 class LayerType {
	 public static inline var ENTITIES = "Entities";
	 public static inline var TILES = "Tiles";
	 public static inline var GRID = "Grid";
 }

 enum EntityPropType {
	 INT;
	 FLOAT;
	 STRING;
 }
 enum EntityGraphicType {
	IMAGE;
	RECTANGLE;
}

//
 @:structInit 
class EntityProjectData {
	public var name:String;
	@:optional public var width:Float = Global.GS;
	@:optional public var height:Float = Global.GS;
	@:optional public var originX:Float = 0;
	@:optional public var originY:Float = 0;
	@:optional public var resizableX:Bool=false;
	@:optional public var resizableY:Bool=false;
	@:optional public var rotatable:Bool = false;
	@:optional public var rotateIncrement:Float = 45;
	@:optional public var values:Array<EntityProjectProp> = [];
	@:optional public var graphicType:EntityGraphicType = EntityGraphicType.RECTANGLE;
	@:optional public var imgPath:String = "";
	@:optional public var tileImage:Bool = false;
	@:optional public var rectColor:Int = 0xFFFFFF;

 }
 @:structInit
 class EntityProjectProp {
	@:optional public var name:String = "";
	@:optional public var defaultValue:String = "";
	@:optional public var type:EntityPropType = EntityPropType.INT;
	@:optional public var min:String = "0";
	@:optional public var max:String = "0";
}
typedef EntityFileData = {
	name:String,
	x:Float,
	y:Float,
	?props:Array<EntityFileProp>
}
typedef EntityFileProp = {
	name:String,
	value:String
}
typedef LayerProjectData = {
	name:String,
	type:String,
	?gridSize:Int,
}
typedef LayerFileData = {
	name:String,
	type:String,
	?data:String,
	?entityArray:Array<EntityFileData>
}

typedef LevelProjectData = {
	width:Int,
	height:Int,
	layers:Array<LayerProjectData>,
	entities:Array<EntityProjectData>,
	tilesetPath:String,
}
typedef LevelFileData = {
	width:Int,
	height:Int,
	layers:Array<LayerFileData>,
	
}

typedef ToolConfig = {
	name:String,
	iconImgPath:String,
}



class DataManager {

	public var data:LevelFileData;
	public function new(data:LevelFileData) {
		this.data = data;
	}
	public function getData():LevelFileData {
		return data;
	}
	public function getStringData():String {
		return Json.stringify(data);
	}
}
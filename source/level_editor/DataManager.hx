package level_editor;
import haxe.Json;
import haxe.ds.Either;

/**
 * ...
 * @author Taylor
 */

 class LayerType {
	 public static inline var ENTITIES = "Entities";
	 public static inline var TILES = "Tiles";
	 public static inline var GRID = "Grid";
 }

typedef LevelData = {
	width:Int,
	height:Int,
	layers:Array<LayerData>
}
typedef LayerData = {
	name:String,
	type:String,
	?data:String,
	?entityArray:Array<EntityData>
}
typedef EntityData = {
	name:String,
	x:Float,
	y:Float,
	?props:Array<EntityProp>
}
typedef EntityProp = {
	name:String,
	value:String
}
class DataManager {

	public var data:LevelData;
	public function new(data:LevelData) {
		this.data = data;
	}
	public function getData():LevelData {
		return data;
	}
	public function getStringData():String {
		return Json.stringify(data);
	}
}
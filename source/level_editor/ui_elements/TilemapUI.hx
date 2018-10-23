package level_editor.ui_elements;

import flash.display.Sprite;
import flash.geom.Rectangle;
import openfl.Assets;
import openfl.display.Tilemap;
import openfl.display.Tileset;

/**
 * ...
 * @author Taylor
 */
class TilemapUI extends Sprite {

	private var tilemap:Tilemap;
	private var tileset:Tileset;
	private var tileIndices:Array<Int> = [];
	public function new(tilesetPath:String, gridSize:Int) {
		super();
		this.tileset = new Tileset(Assets.getBitmapData(tilesetPath));
		this.tilemap = new Tilemap(tileset.bitmapData.width, tileset.bitmapData.height, false);
		for (y in 0...Math.floor(tileset.bitmapData.height/gridSize)) {
			for (x in 0...Math.floor(tileset.bitmapData.width/gridSize)) {
				this.tileIndices.push(this.tileset.addRect(new Rectangle(x*gridSize, y*gridSize, gridSize, gridSize)));
			}
		}
		
	}
	
}
package level_editor.windows;

import flash.display.Sprite;
import flash.geom.Rectangle;
import level_editor.windows.Window;
import openfl.Assets;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.display.Tileset;

/**
 * ...
 * @author Taylor
 */
class TilemapWindow extends Window {

	private var tilesetPath:String;
	private var gridSize:Int
	private var tileButtons:Map<Sprite, Int> = new Map();
	public function new(tilesetPath:String, gridSize:Int) {
		super("Tile Palette");
		this.tilesetPath = tilesetPath;
		this.gridSize = gridSize;
		
	}
	override public function setupContent() {
		var tileset = new Tileset(Assets.getBitmapData(tilesetPath));
		var tilemap = new Tilemap(tileset.bitmapData.width, tileset.bitmapData.height, false);
		for (y in 0...Math.floor(tileset.bitmapData.height/gridSize)) {
			for (x in 0...Math.floor(tileset.bitmapData.width/gridSize)) {
				var index = tileset.addRect(new Rectangle(x * gridSize, y * gridSize, gridSize, gridSize));
				
				tilemap.addTile(new Tile(index, x, y));
				var tileBtn:Sprite = new Sprite();
				var g = tileBtn.graphics;
				g.beginFill(0, 0);
				g.drawRect(0, 0, gridSize, gridSize);
				g.endFill();
				tileBtn.x = x;
				tileBtn.y = y;
				this.content.addChild(tileBtn);
			}
		}
		
		this.content.addChild(tilemap);
	}
	
}
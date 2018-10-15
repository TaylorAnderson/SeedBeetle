package level_editor;

import flash.display.Sprite;
import openfl.Assets;
import openfl.Lib;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.geom.Rectangle;
/**
 * ...
 * @author Taylor
 */
class Background extends Sprite {

	private var tilemap:Tilemap;
	private var tileset:Tileset;
	public function new() {
		super();
		tileset = new Tileset(Assets.getBitmapData("graphics/bg-tile.png"));
		var t = tileset.addRect(new Rectangle(0, 0, 32, 32));
		var st = Lib.current.stage;
		tilemap = new Tilemap(st.stageWidth, st.stageHeight, tileset);
		for (x in 0...Math.floor(st.stageWidth / 32)) {
			for (y in 0...Math.floor(st.stageHeight / 32)) {
				tilemap.addTile(new Tile(t, x*32, y*32));
			}
		}
		
		this.addChild(tilemap);
		
	}
	
}
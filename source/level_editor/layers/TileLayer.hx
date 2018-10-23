package level_editor.layers;

import level_editor.DataManager.LayerProjectData;
import level_editor.DataManager.LayerFileData;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.Assets;
import openfl.display.Tile;
import haxepunk.HXP;
import openfl.geom.Rectangle;
/**
 * ...
 * @author Taylor
 */
typedef TileData = {
	current:Int,
	preview:Int,
	isPreview:Bool
}
class TileLayer extends Layer {

	private var tilemap:Tilemap;
	private var tileset:Tileset;
	private var tileIndices:Array<Int> = [];
	private var tiles:Array<Array<TileData>> = [];
	private var gridSize:Int;
	public function new(levelWidth:Int, levelHeight:Int, projectLayerData:LayerProjectData, fileLayerData:LayerFileData, tilemapPath:String) {
		super();

		
		if (projectLayerData.gridSize == null) projectLayerData.gridSize = Global.GS;
		this.tileset = new Tileset(Assets.getBitmapData(tilemapPath));
		this.gridSize = projectLayerData.gridSize;

		for (y in 0...Math.floor(tileset.bitmapData.height/projectLayerData.gridSize)) {
			for (x in 0...Math.floor(tileset.bitmapData.width/projectLayerData.gridSize)) {
				this.tileIndices.push(this.tileset.addRect(new Rectangle(x*this.gridSize, y*this.gridSize, this.gridSize, this.gridSize)));
			}
		}
		
		this.addChild(this.tilemap);
		
		this.loadFromString(fileLayerData.data);
	}

	private function loadFromString(str:String) {
		
		var tilesArr:Array<Array<String>> = [];
		var rows = str.split("\n");
		for (row in rows) {
			tilesArr.push(row.split(","));
		}
		tiles = [for (y in 0...tilesArr.length) [for (x in 0...tilesArr[y].length) {current: -1, preview: -1, isPreview: false}]];

		for (y in 0...tilesArr.length) {
			for (x in 0...tilesArr[y].length) {
				var index = Std.parseInt(tilesArr[y][x]);
				if (index >= 0) {
					setTile(index, x, y, false);
				}
			}
		}
	}

	public function setTile(tileIndex:Int, x:Int, y:Int, isPreview:Bool) {
		var newTile:TileData = tiles[y][x];
		if (isPreview) {
			newTile.isPreview =  true;
			newTile.preview = tileIndex;
		}
		else {
			newTile.current = tileIndex;
			newTile.isPreview = false;
		}
		this.draw();
	}
	public function setRect(tileIndex:Int, x:Int, y:Int, width:Int, height:Int, isPreview:Bool) {
		for (xPos in x...width) {
			for (yPos in y...height) {
				setTile(tileIndex, xPos, yPos, isPreview);
			}
		}
	}
	public function removeTile(x:Int, y:Int){ 
		tiles[y][x] = {current: -1, preview: -1, isPreview: false};
		this.draw();
	}
	public function removeRect(x:Int, y:Int, width:Int, height:Int) {
		for (xPos in x...width) {
			for (yPos in y...height) {
				removeTile(xPos, yPos);
			}
		}
	}

	private function draw() {
		tilemap.removeTiles(0, tilemap.numTiles);
		for (y in 0...tiles.length) {
			for (x in 0...tiles[y].length) {
				var tile = tiles[y][x];
				var index = tile.isPreview ? tile.preview : tile.current;
				if (index >= 0) {
					var tileGraphic = new Tile(index, x*this.gridSize, y*this.gridSize);
					tileGraphic.alpha = tile.isPreview ? 0.5 : 1;
					tilemap.addTile(tileGraphic);
				}
			}
		}
	}
}
package;

import haxe.xml.Fast;
import haxepunk.Entity;
import haxepunk.HXP;
import haxepunk.graphics.tile.Tilemap;
import haxepunk.masks.Grid;

import openfl.Assets;

/**
 * ...
 * @author Taylor
 */
class LevelChunk extends Entity {
	var xml:Xml;
	var fastXml:Fast;
	
	var tiles:Tilemap; 
	var bgTiles:Tilemap;
	var grid:Grid;
	var player:Player;
	var level:String;
	public var levelWidth:Int;
	public var levelHeight:Int;
	public function new(x:Float=0, y:Float=0, level:String, player:Player) {
		super(x, y);
		this.player = player;
		this.level = level;
	}
	override public function added() {
		
		this.loadLevel(level);
		//this.addGraphic(bgTiles); 
		this.addGraphic(tiles); 
		mask = grid;
		layer = -10;
		type = "level";
		
	}
	public function loadLevel(level:String) {
		xml = Xml.parse(Assets.getText(level));
		fastXml = new Fast(xml.firstElement());
		this.levelWidth = Std.parseInt(fastXml.att.width);
		this.levelHeight = Std.parseInt(fastXml.att.height);
		grid = new Grid(Std.parseInt(fastXml.att.width), Std.parseInt(fastXml.att.height), Global.GS, Global.GS);
		grid.loadFromString(fastXml.node.Grid.innerData, "", "\n");
		
		tiles = new Tilemap("graphics/tiles.png", Std.parseInt(fastXml.att.width), Std.parseInt(fastXml.att.height), Global.GS, Global.GS);
		tiles.pixelSnapping = true;
		
		
		
		/*bgTiles = new Tilemap("graphics/bgtiles.png", Std.parseInt(fastXml.att.width), Std.parseInt(fastXml.att.height), Global.GS, Global.GS);
		bgTiles.pixelSnapping = true;
		
		bgTiles.loadFromString(fastXml.node.BG.innerData, ",", "\n");*/
		
		
		for (s in fastXml.node.Entities.nodes.Player) {
			player.x = Std.parseInt(s.att.x);
			player.y = Std.parseInt(s.att.y);
		}
		
		for (s in fastXml.node.Entities.nodes.Seed) {
			var seed = new Seed(Std.parseInt(s.att.x), Std.parseInt(s.att.y));
			this.scene.add(seed);
		}
		
		autoTile();
	}
	
	public function autoTile():Void {
		var col:Int = 0;
		var row:Int = 0;
		while (row < tiles.height / 8)
		{
			if (getTile(col, row))
			{
				var left:Bool = 		getTile(col - 1, 	row);
				var right:Bool = 		getTile(col + 1, 	row);
				var top:Bool = 			getTile(col, 		row - 1);
				var bottom:Bool = 		getTile(col, 		row + 1);
				var topright:Bool = 	getTile(col + 1, 	row - 1);
				var topleft:Bool = 		getTile(col - 1, 	row - 1);
				var bottomright:Bool = 	getTile(col + 1, 	row + 1);
				var bottomleft:Bool = 	getTile(col - 1, 	row + 1);
				var onedeep:Bool = 
				!getTile(col, row - 2, 2) || 
				!getTile(col - 2, row, 2) || 
				!getTile(col + 2, row, 2) || 
				!getTile(col, row + 2, 2) ||
				!getTile(col-2, row-2, 2) ||
				!getTile(col+2, row-2, 2) ||
				!getTile(col + 2, row + 2, 2) ||
				
				!getTile(col+2, row+1, 2) ||
				!getTile(col+1, row+2, 2) ||
				!getTile(col+2, row-1, 2) ||
				!getTile(col-1, row+2, 2) ||
				!getTile(col - 2, row + 2); 
				var index:Int = 0;
				//top left
				if (right && !left)
				{
					index = 9;
				}
				//top middle
				if (left && right && !top)
				{
					index = 10;
				}
				//top right
				if (left && !right)
				{
					index = 11;
				}
				//mid left
				if (top && bottom && !left)
				{
					index = 13;
				}
				//middle
				if (left && right && top && bottom)
				{
					if (bottomright && bottomleft && topright && topleft)
						index = 14;
					if (onedeep)
					{
						index = HXP.choose(0, 1);
					}

					if (!bottomright)
					{
						index = 2;
					}
					if (!bottomleft)
					{
						index = 3;
					}
					if (!topright)
					{
						index = 6;
					}
					if (!topleft)
					{
						index = 7;
					}
				}
				//middle right
				if (top && bottom && !right)
				{
					index = 15;
				}
				//bottom left
				if (top && right && !bottom && !left)
				{
					index = 17;
				}
				//bottom middle
				if (left && right && top && !bottom)
				{
					index = 18;
				}
				//bottom right
				if (left && top && !bottom && !right)
				{
					index = 19;
				}
				
				
				tiles.setTile(col, row, index);
			}
			col++;
			if (col >= tiles.width / 8)
			{
				col = 0;
				row++;
			}
		}
	}
	
	public function getTile(col:Int, row:Int, offset:Int = 1):Bool
	{
		return grid.getTile(col, row);
	}
}
	
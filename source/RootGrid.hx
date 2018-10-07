package;

import haxepunk.Entity;
import haxepunk.Graphic;
import haxepunk.HXP;
import haxepunk.Mask;
import haxepunk.ai.path.NodeGraph;
import haxepunk.graphics.Image;
import haxepunk.graphics.tile.Tilemap;
import haxepunk.masks.Grid;
import motion.Actuate;

/**
 * ...
 * @author ...
 */
class RootGrid extends Entity 
{
	public var navGrid:Grid;
	var lvl:LevelChunk;
	var square:Entity;
	var lvlGrid:Grid;
	public var nodeGraph:NodeGraph;
	public var fullNodeGraph:NodeGraph; // for finding points closest to the grid 
	
	public var onGridLoaded:Void->Void = null;
	public function new() 
	{
		super(0, 0);	
		square = new Entity(0, 0);
		square.setHitbox(Global.GS, Global.GS);
		square.type = "level";
	}
	
	override public function added() {
		
		this.scene.add(square);
		lvl = cast(this.scene, GameScene).level;
		lvlGrid = lvl.grid;
		navGrid = new Grid(lvlGrid.width, lvlGrid.height, Global.GS, Global.GS);
		nodeGraph = new NodeGraph({});
		fullNodeGraph = new NodeGraph({});
		fullNodeGraph.fromGrid(lvl.grid.getInverted());
		
		Actuate.timer(0.01).onComplete(loadGrid);
	}
	public function loadGrid() {
		
		navGrid.clearRect(0, 0, navGrid.width, navGrid.height);
		for (x in 0...Math.floor(lvlGrid.width / Global.GS)) {
			for (y in 0...Math.floor(lvlGrid.height / Global.GS)) {
				if (lvlGrid.getTile(x, y)) {
					if (lvl.decoTiles.getTile(x, y) < 27) navGrid.setTile(x, y);
				}
				else {
					var col = square.collide("level", x * Global.GS, y * Global.GS);
					if (col != null && !Std.is(col, ISwitchObject)  && !Std.is(col, Player)) {
						navGrid.setTile(x, y);
					}
				}
			}
		}
		nodeGraph.fromGrid(this.navGrid.getInverted());
		if (this.onGridLoaded != null) this.onGridLoaded();
	}
}
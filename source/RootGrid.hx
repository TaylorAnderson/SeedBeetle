package;

import haxepunk.Entity;
import haxepunk.Graphic;
import haxepunk.HXP;
import haxepunk.Mask;
import haxepunk.ai.path.NodeGraph;
import haxepunk.masks.Grid;

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
	public function new() 
	{
		super(0, 0);		
	}
	
	override public function added() {
		square = new Entity(0, 0);
		scene.add(square);
		square.setHitbox(Global.GS, Global.GS);
		lvl = cast(this.scene, GameScene).level;
		lvlGrid = lvl.grid;
		navGrid = new Grid(lvlGrid.width, lvlGrid.height, Global.GS, Global.GS);
		nodeGraph = new NodeGraph({});
		
		loadGrid();
	}
	public function loadGrid() {
		navGrid.clearRect(0, 0, navGrid.width, navGrid.height);
		for (x in 0...Math.floor(lvlGrid.width / Global.GS)) {
			for (y in 0...Math.floor(lvlGrid.height / Global.GS)) {
				if (lvlGrid.getTile(x, y) && lvl.decoTiles.getTile(x, y) <= 27 ) {
					navGrid.setTile(x, y);
				}
				else {
					var col = square.collide("level", x * Global.GS, y * Global.GS);
					if (col != null && !Std.is(col, ISwitchObject)) {
						trace("setting any tile");
						navGrid.setTile(x, y);
					}
				}
			}
		}
		nodeGraph.fromGrid(this.navGrid.getInverted());
	}
	
}
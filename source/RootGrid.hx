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
	var navGrid:Grid;
	var lvl:LevelChunk;
	var square:Entity;
	var lvlGrid:Grid;
	var nodeGraph:NodeGraph;
	public function new() 
	{
		super(0, 0);
		

		
	}
	
	override public function added() {
		square = new Entity(0, 0);
		scene.add(square);
		square.setHitbox(Global.GS, Global.GS);
		
		navGrid = new Grid(lvl.width, lvl.height, Global.GS, Global.GS);
		lvl = cast(this.scene, GameScene).level;
		
		lvlGrid = lvl.grid;
		
		this.loadGrid();
		
		nodeGraph = new NodeGraph({optimize: SlopeMatch});
	}
	public function loadGrid() {
		navGrid.clearRect(0, 0, navGrid.width, navGrid.height);
		for (x in 0...Math.floor(HXP.width / Global.GS)) {
			for (y in 0...Math.floor(HXP.height / Global.GS)) {
				if (lvlGrid.getTile(x, y)) {
					navGrid.setTile(x, y);
				}
				else {
					if (square.collide("level", x * Global.GS, y * Global.GS) != null) {
						navGrid.setTile(x, y);
					}
				}
			}
		}
		nodeGraph.fromGrid(this.navGrid);
	}
	
}
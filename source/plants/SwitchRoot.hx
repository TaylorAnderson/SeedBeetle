package plants;

import flash.geom.Point;
import haxepunk.Entity;
import haxepunk.Graphic;
import haxepunk.Mask;
import haxepunk.ai.path.PathNode;
import haxepunk.graphics.Image;
import haxepunk.graphics.Spritemap;
import haxepunk.math.MathUtil;
import motion.Actuate;

/**
 * ...
 * @author Taylor
 */
class SwitchRoot extends Entity {
	var path:Array<PathNode> = [];
	var rootGrid:RootGrid;
	var target:ISwitchObject;
	var topLeft = 0;
	var topMid = 1;
	var topRight = 2;
	var midLeft = 3;
	var midCenter = 4;
	var midRight = 5;
	var bottomLeft = 6;
	var bottomMid = 7;
	var bottomRight = 8;
	
	var tiles:Array <RootTile> = [];
	var endPos:Point = new Point();
	public function new(start:Point, target:ISwitchObject, rootGrid:RootGrid) {
		super(start.x, start.y);
		this.rootGrid = rootGrid;
		this.target = target;
	}
	override public function added() {
		
		var entTarget = cast(target, Entity);
		var otherPos = new Point();
		if (this.x > entTarget.x) otherPos.x = entTarget.right;
		else otherPos.x = entTarget.left;
		if (this.y > entTarget.y) otherPos.y = entTarget.bottom;
		else otherPos.y = entTarget.top;
		
		this.endPos = new Point(entTarget.x + entTarget.width/2, entTarget.y + entTarget.height/2);
		
		var thisGridPos = rootGrid.nodeGraph.getClosestNode(this.x/Global.GS, this.y/Global.GS);
		var otherGridPos = rootGrid.nodeGraph.getClosestNode(otherPos.x / Global.GS, otherPos.y / Global.GS);
		path = rootGrid.nodeGraph.search(thisGridPos.x, thisGridPos.y, otherGridPos.x, otherGridPos.y);
		
		if (path != null) {
			if (path[path.length - 1].x == otherGridPos.x && path[path.length - 1].y == otherGridPos.y) {
				//target.activate();
			}
				
			var currentDir = new Point(path[1].x - path[0].x, path[1].y - path[0].y);
			currentDir.normalize(1);
			
			var speed = 0.2;
			var delay:Float = 0;
			for (i in 0...path.length - 1) {
				currentDir = new Point(path[i + 1].x - path[i].x, path[i + 1].y - path[i].y);
				currentDir.normalize(1);
				for (j in 0...Std.int(MathUtil.distance(path[i].x, path[i].y, path[i + 1].x, path[i + 1].y))) {
					delay += speed;
					createRootTile((path[i].x + currentDir.x*j)*Global.GS, (path[i].y + currentDir.y*j)*Global.GS, path[i+1], delay);
				}
			}
			createRootTile(path[path.length - 1].x * Global.GS, path[path.length - 1].y  * Global.GS, path[path.length - 1], delay+speed);
		}
		
		for (i in 0...tiles.length) {
			var tile = tiles[i];
			var index = 0;
			var prevPos = new Point();
			var nextPos = new Point();
			
			if (tiles[i - 1] == null) {
				if (Math.abs(tile.x - this.x) > Math.abs(tile.y - this.y)) prevPos.x = tile.x + MathUtil.sign(this.x - tile.x) * Global.GS;
				else prevPos.y = tile.y + MathUtil.sign(this.y - tile.y) * Global.GS;
			}
			else prevPos = new Point(tiles[i - 1].x, tiles[i - 1].y);
			

			if (tiles[i+1] != null) nextPos = new Point(tiles[i + 1].x, tiles[i + 1].y);
			
			if (prevPos.x == nextPos.x) index = midLeft;
			if (prevPos.y == nextPos.y) index = topMid;
			if (prevPos.x > nextPos.x) {
				if (prevPos.y < nextPos.y) index = bottomRight;
				if (prevPos.y > nextPos.y) index = topRight;
			}
			if (prevPos.x < nextPos.x) {
				if (prevPos.y < nextPos.y) index = bottomLeft;
				if (prevPos.y > nextPos.y) index = bottomRight;
			}
			
			if (tiles[i + 1] == null) {
				//if (Math.abs(tile.x - endPos.x) > Math.abs(tile.y - endPos.y)) nextPos.x = tile.x + MathUtil.sign(endPos.x - tile.x) * Global.GS;
				//else nextPos.y = tile.y + MathUtil.sign(endPos.y - tile.y) * Global.GS;
				
				index = 4;
			}
			
			tile.sprMap.frame = index;
		}
	}
	
	public function createRootTile(x:Float, y:Float, destNode:PathNode, delay:Float) {
		var tile = new RootTile(x, y, destNode);
		Actuate.timer(delay).onComplete(function() {
			this.scene.add(tile); 
			if (tile == tiles[this.tiles.length - 1]) this.target.activate();
			
		});
		
		this.tiles.push(tile);
	}
}

class RootTile extends Entity {
	public var sprMap = new Spritemap("graphics/root-tiles.png", 8, 8);
	public var pathDest:PathNode;
	public function new(x:Float, y:Float, pathDest:PathNode) {
		super(x, y, this.sprMap);
		trace("Getting herE");
		this.pathDest = pathDest;
		this.layer = -1000;
	}
}
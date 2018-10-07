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
	
	var tiles:Array <RootTile> = [];
	var endPos:Point = new Point();
	
	var seedColor:Int;
	public function new(start:Point, target:ISwitchObject, rootGrid:RootGrid, seedColor:Int) {
		super(start.x, start.y);
		this.rootGrid = rootGrid;
		this.target = target;
		this.seedColor = seedColor;
	}
	override public function added() {
		this.scene.add(rootGrid);
		
		rootGrid.onGridLoaded = function() {
			var entTarget = cast(target, Entity);
			
			var positions = [
				new Point(entTarget.left + entTarget.width/2, entTarget.top),
				new Point(entTarget.left + entTarget.width/2, entTarget.bottom),
				new Point(entTarget.left, entTarget.top + entTarget.height/2),
				new Point(entTarget.right, entTarget.top + entTarget.height/2)
			];
			var closestDist = MathUtil.NUMBER_MAX_VALUE;
						
			var thisGridPos = rootGrid.nodeGraph.getClosestNode(this.x/Global.GS, this.y/Global.GS);
			var otherGridPos:PathNode = null;
			for (pos in positions) {
				var closestGridPos = rootGrid.nodeGraph.getClosestNode(pos.x/Global.GS, pos.y/Global.GS);
				var distToGrid = MathUtil.distance(closestGridPos.x*Global.GS, closestGridPos.y*Global.GS, pos.x, pos.y);
				if (distToGrid < closestDist) {
					closestDist = distToGrid;
					otherGridPos = closestGridPos;
				}
			}
			
			//var sq = new Entity(otherGridPos.x * Global.GS, otherGridPos.y * Global.GS, Image.createRect(Global.GS, Global.GS));
			//this.scene.add(sq);
			//sq.layer = -1000;

			
			path = rootGrid.nodeGraph.search(thisGridPos.x, thisGridPos.y, otherGridPos.x, otherGridPos.y);
			
			if (path != null) {
					
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
				var index = -1;
				var prevPos:RootTile = null;
				var nextPos:RootTile = null;
				
				if (tiles[i - 1] == null) {
					prevPos = new RootTile(tile.x, tile.y - Global.GS, null);
				}
				else prevPos = tiles[i - 1];
				
				nextPos = new RootTile(0, 0, null);

				if (tiles[i + 1] != null) nextPos = tiles[i + 1];	
				
				if (prevPos != null) {
					if (prevPos.x == nextPos.x) index = 3;
					if (prevPos.y == nextPos.y) index = 1;
				}

				
				if (tiles[i + 1] == null) {
					   index = 4;
				}
				
				if (index == -1) {
					var curTile = tiles[i];
					var prevLeft = 		prevPos.x < curTile.x;
					var prevRight = 	prevPos.x > curTile.x;
					var prevBelow = 	prevPos.y > curTile.y;
					var prevAbove = 	prevPos.y < curTile.y;


					var nextLeft = 		nextPos.x < curTile.x;
					var nextRight = 	nextPos.x > curTile.x;
					var nextBelow = 	nextPos.y > curTile.y;
					var nextAbove = 	nextPos.y < curTile.y;
					
					var above = 	nextAbove || prevAbove;
					var below = 	nextBelow || prevBelow;
					var left = 		prevLeft || nextLeft;
					var right = 	prevRight || nextRight;
					
					if (below && right) index = 0;
					if (below && left) index = 2;
					if (above && right) index = 6;
					if (above && left) index = 8;
				}
				
					
				
				
				tile.sprMap.frame = index+seedColor*9;
			}
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
		this.pathDest = pathDest;
		this.layer = Layers.LEVEL - 1;
	}
}
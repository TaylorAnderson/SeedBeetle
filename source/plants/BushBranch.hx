package plants;

import haxepunk.Entity;
import haxepunk.Graphic;
import haxepunk.Mask;
import haxepunk.graphics.Image;
import motion.Actuate;
import motion.easing.Back;

/**
 * ...
 * @author Taylor
 */
class BushBranch extends Plant {

	private var img:Image = new Image("graphics/bush-plant.png");
	private var branchLeft:Branch;
	private var branchRight:Branch;
	public function new(x:Float=0, y:Float=0) {
		super(x, y, img);
		setHitbox(32, 16);
		
		this.layer = Layers.ENTITIES;

		
	}
	
	override public function added() {
		branchLeft = new Branch(this.x, this.y, -1);
		branchRight = new Branch(this.x, this.y, 1);
		
		this.scene.add(branchLeft);
		this.scene.add(branchRight);
		
		branchRight.x = branchLeft.x = this.x + this.width / 2;
		branchRight.y = branchLeft.y = this.y + this.height / 2 - this.branchLeft.height / 2 + 1;
	}
	
}

class Branch extends Entity {
	private var img:Image = new Image("graphics/branch.png");
	private var dir:Int;
	public function new(x:Float = 0, y:Float = 0, dir:Int) {
		super(x, y, img);  
		setHitbox(0, 6);
		this.graphic = img;
		this.dir = dir;
		img.scaleX = 0;
		this.layer = Layers.ENTITIES + 1;
		type = "level";
		
		
		
		if (dir == 1) {
			Actuate.tween(img, 0.3, {scaleX: 1})
			.ease(Back.easeOut)
			.onUpdate(onTweenUpdate)
			.onComplete(function() {type = "level"; });
		}
		else {
			img.originX = img.width;
			Actuate.tween(img, 0.3, {scaleX: 1})
			.ease(Back.easeOut)
			.onUpdate(onTweenUpdate)
			.onComplete(function() {type = "level"; });
			
		}
	}
	
	private function onTweenUpdate() {

		var formerWidth = this.width;
		var formerOriginX = this.originX;
		if (dir == 1) {
			setHitbox(cast(img.width*img.scaleX), img.height);
		}
		else {
			setHitbox(cast(img.width * img.scaleX), img.height, cast(img.scaleX * img.width) );
		}
		var collisions:Array<Entity> = [];
		collideInto("level", x, y, collisions);
		for (col in collisions) {
			if (Std.is(col, PhysicsObject)) {
				var closest = dir == 1 ? x + img.width * img.scaleX : x - img.width * img.scaleX - (col.width - col.originX);
				var colX = col.x;
				col.moveBy(closest - col.x + dir, 0, "level");
				
				if (colX == col.x) {
					stopGrowth(col);
				}
			}
			else {
				stopGrowth(col);
			}
		}
	}
	
	private function stopGrowth(e:Entity) {
		Actuate.stop(img);
		var loopSafety = 1000;
		while (collide("level", x, y) != null && loopSafety > 0) {
			loopSafety--;
			width --;
			setHitbox(width, img.height, this.originX);
		}
		img.scaleX = width / img.width;
	}
	override public function update() {
	}
}
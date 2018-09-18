package plants;

import haxepunk.Entity;
import haxepunk.Graphic;
import haxepunk.HXP;
import haxepunk.Mask;
import haxepunk.graphics.Image;

/**
 * ...
 * @author Taylor
 */
class Beanstalk extends Plant {

	private var length:Int = 4;
	private var iter:Int = 0;
	private var building:Bool = true;
	private var spawnDelayCounter:Float = 0;
	private var grow:Int = 1;
	private var blocks:Array<BeanBlock> = [];

	public function new(x:Float=0, y:Float=0) {
		super(x, y);
		type = "level";
		this.climbable = true;
		
		

	}
	override public function added() {
		addBlock();
		var cover = new BeanBlock(x, y);
		scene.add(cover);
		cover.layer = Layers.BG_LEVEL - 1;
	}
	override public function update() {
		if (blocks.length < length) {
			for (b in blocks) {
				b.y--;
			}
		}

		var lastBlock = blocks[blocks.length - 1];
		if (lastBlock.y == lastBlock.originalY-lastBlock.height && blocks.length <= length) {
			addBlock();
		}
		
		
	}
	private function addBlock() {
		var block = new BeanBlock(x, this.y);
		blocks.push(block);
		this.scene.add(block);
		
	}
}
class BeanBlock extends Plant {
	private var img:Image = new Image("graphics/beanstalk.png");
	public var originalY:Float;
	public function new(x:Float = 0, y:Float = 0) {
		super(x, y, img);
		this.originalY = y;
		type = "level";
		this.climbable = true;
		setHitbox(16, 16);
		this.img.x = 18 / 2 - this.img.width / 2;
		this.layer = Layers.BG_LEVEL;
	}
	override public function update() {
		var objectsAbove:Array<Entity> = [];
		collideInto("level", x, y, objectsAbove);
		for (obj in objectsAbove) {
			if (Std.is(obj, PhysicsObject)) {
				obj.y -= 1;
			}
			
			
		}
	}
}
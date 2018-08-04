package plants;

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

	public function new(x:Float=0, y:Float=0) {
		super(x, y);
		

	}
	override public function update() {
		spawnDelayCounter += HXP.elapsed;
		if (spawnDelayCounter > 0.25 && iter < length && building) {
			spawnDelayCounter = 0;
			
			var block = new BeanBlock(this.x, this.y - iter * 15);
			if (block.collide("level", block.x, block.y) != null) {
				building = false;
			}
			this.scene.add(block);
			iter++;
		}

	}
}
class BeanBlock extends Plant {
	private var img:Image = new Image("graphics/beanstalk.png");
	public function new(x:Float = 0, y:Float = 0) {
		super(x, y, img);
		type = "level";
		this.climbable = true;
		setHitbox(14, 15, -1);
		this.img.x = 18 / 2 - this.img.width / 2;
		this.layer = 50;
	}
}
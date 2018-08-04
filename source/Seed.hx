package;

import haxepunk.Graphic;
import haxepunk.HXP;
import haxepunk.Mask;
import haxepunk.graphics.Image;
import plants.Beanstalk;

/**
 * ...
 * @author Taylor
 */
enum SeedType {
	BEANSTALK;
	VINE;
	MUSHROOM;
}
class Seed extends Carryable {

	private var img:Image = new Image("graphics/seed.png");
	private var waterNeeded = 3;
	private var waterDelay:Int = 1;
	private var waterDelayTimer:Float = 0;
	public var seedType:SeedType = SeedType.BEANSTALK; //for testing; we're gonna set this by reading the data coming from ogmo.
	public function new(x:Float=0, y:Float=0) {
		super(x, y, img);
		setHitbox(20, 16);
		type = "level";
		name = "seed";
		
	}
	override public function update() {
		super.update();
		this.waterDelayTimer += HXP.elapsed;
		var water = collide("water", x, y);
		if (water != null && Std.is(water, Water) && (waterDelayTimer > this.waterDelay || !cast(water, Water).isContinuous)) {
			this.waterDelayTimer -= waterDelay;
			cast(water, Water).consume();
			this.waterNeeded--;
			if (this.waterNeeded <= 0) {
				this.sprout();
			}
		}
	}
	public function sprout() {
		
		switch(seedType) {
			case SeedType.VINE: 
				
			case SeedType.BEANSTALK: 
				this.scene.add(new Beanstalk(this.x, this.y));
			case SeedType.MUSHROOM:
				
		}
		scene.remove(this);
	}
}
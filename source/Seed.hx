package;

import haxepunk.Graphic;
import haxepunk.HXP;
import haxepunk.Mask;
import haxepunk.graphics.Image;
import plants.Beanstalk;
import plants.BushBranch;

/**
 * ...
 * @author Taylor
 */
enum SeedType {
	BEANSTALK;
	BUSHPLANT;
	MUSHROOM;
}
class Seed extends Carryable {

	private var img:Image = new Image("graphics/seed.png");
	private var waterNeeded = 3;
	private var waterDelay:Float = 0.5;
	private var waterDelayTimer:Float = 0;
	public var seedType:SeedType = SeedType.BUSHPLANT; //for testing; we're gonna set this by reading the data coming from ogmo.
	public function new(x:Float=0, y:Float=0) {
		super(x, y, img);
		setHitbox(14, 16, -4);
		type = "level";
		name = "seed";
		layer = Layers.ENTITIES + 1;
	}
	override public function update() {
		super.update();
		
		var water = collide("water", x, y);
		
		if (water != null && Std.is(water, IWater)) {
			this.waterDelayTimer += HXP.elapsed;
			
			if ((waterDelayTimer > this.waterDelay || !cast(water, IWater).isContinuous)) {
				this.waterDelayTimer -= waterDelay;
				cast(water, IWater).consume();
				this.waterNeeded--;
				if (this.waterNeeded <= 0) {
					this.sprout();
				}
			}
		}
	}
	public function sprout() {
		
		switch(seedType) {
			case SeedType.BUSHPLANT: 
				this.scene.add(new BushBranch(this.x, this.y));
			case SeedType.BEANSTALK: 
				this.scene.add(new Beanstalk(this.x, this.y));
			case SeedType.MUSHROOM:
				
		}
		scene.remove(this);
	}
}
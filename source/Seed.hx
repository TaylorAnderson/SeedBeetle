package;

import haxepunk.Graphic;
import haxepunk.HXP;
import haxepunk.Mask;
import haxepunk.graphics.Image;
import haxepunk.graphics.Spritemap;
import plants.Beanstalk;
import plants.BushBranch;
import plants.SwitchBlossom;

/**
 * ...
 * @author Taylor
 */
enum SeedType {
	BEANSTALK;
	BUSHPLANT;
	SWITCH;
}
class Seed extends Carryable {

	public static var SeedTypes = [SeedType.BEANSTALK, SeedType.BUSHPLANT, SeedType.SWITCH];
	private var img:Spritemap = new Spritemap("graphics/seed.png", 18, 16);
	private var seed:Spritemap = new Spritemap("graphics/seeds.png", 8, 10);
	private var waterNeeded = 3;
	private var waterDelay:Float = 0.5;
	private var waterDelayTimer:Float = 0;
	
	public var seedType:SeedType;
	public var seedColor:Int;
	public function new(x:Float=0, y:Float=0, seedIndex:Int, seedColor:Int) {
		super(x, y);
		addGraphic(img);
		addGraphic(seed);
		
		this.seedColor = seedColor;
		
		seed.x = 7;
		seed.y = 3;
		setHitbox(16, 16, -2);
		type = "level";
		name = "seed";
		layer = Layers.ENTITIES + 1;
		img.frame = 0;
		
		seed.frame = seedIndex;
		if (Seed.SeedTypes[seedIndex] == SeedType.SWITCH) seed.frame +=seedColor;
		this.seedType = Seed.SeedTypes[seedIndex];
		
	}
	override public function update() {
		super.update();
		
		img.frame = 3 - waterNeeded;
		
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
				this.scene.add(new BushBranch(this.left, this.y));
			case SeedType.BEANSTALK: 
				this.scene.add(new Beanstalk(this.left, this.y));
			case SeedType.SWITCH:
				scene.remove(this); //so we cant count this seed when constructing nav-grid
				this.scene.add(new SwitchBlossom(this.left, this.bottom - 8, this.seedColor));
				
				
		}
		if (scene != null) scene.remove(this);
	}
}
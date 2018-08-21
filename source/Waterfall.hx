package;
import haxepunk.Entity;
import haxepunk.graphics.Image;
import haxepunk.graphics.Spritemap;
import haxepunk.graphics.emitter.Emitter;
import haxepunk.math.Rectangle;


/**
 * ...
 * @author Taylor
 */

typedef SpritemapData = {
	var width:Int;
	var height:Int;
	var path:String;
}
class Waterfall extends Water {

	var waterSpout:Image;
	var waterBG:Image;
	var waterTop:Spritemap;
	var waterWidth:Int;
	
	var fxEmitter:Emitter;
	var small:Bool;
	
	var waterHeight:Int = 0;
	public function new(x:Float=0, y:Float=0, small:Bool = false) {
		super(x, y);
		this.small = small;
		if (small) {
			this.waterSpout = new Image("graphics/water-spout-small.png");
			this.waterTop = new Spritemap("graphics/waterfall-top-small.png", 12, 9);
			waterWidth = 14;
		}
		else {
			this.waterSpout = new Image("graphics/water-spout.png");
			this.waterTop = new Spritemap("graphics/waterfall-top.png", 26, 9);
			waterWidth = 28;
		}
		this.layer = Layers.ENTITIES + 1;
		
	}
	override public function added() {
		
		this.waterTop.add("anim", [0, 1], 10);
		this.waterTop.play("anim");
		
		
		this.waterBG = Image.createRect(waterWidth, 1, 0x419bde);
		
		
		
		this.addGraphic(this.waterSpout);
		this.addGraphic(this.waterBG);
		this.addGraphic(this.waterTop);
		
		
		fxEmitter = new Emitter("graphics/water-particle.png", 8, 8);
		fxEmitter.newType("water", [0, 1, 2]);
		fxEmitter.setGravity("water", 2.5);
		fxEmitter.setMotion("water", 0, 15, 0.5, 180, 5);
		//fxEmitter.setScale("water", 1, 0);
		fxEmitter.setAlpha("water", 1, 0);
		fxEmitter.smooth = false;
		
		fxEmitter.pixelSnapping = true;
		
		var particles = new Entity(0, 0, fxEmitter);
		scene.add(particles);
		
		this.waterBG.x = this.waterSpout.width / 2 - this.waterWidth / 2;
		this.waterBG.y = this.waterSpout.height / 2;
		
		this.waterTop.x = this.waterBG.x + this.waterWidth / 2 - this.waterTop.width / 2;
		this.waterTop.y = this.waterBG.y + 2;
		
	}
	
	override public function update() {
		waterHeight = 0;
		
		var loopSafety = 1000;
		this.setHitbox(waterWidth, 1, - cast(this.waterSpout.width / 2 - this.waterWidth / 2));
		
		while (collide("level", x, y+1) == null && loopSafety > 0) {
			waterHeight += 1;
			this.setHitbox(waterWidth, waterHeight, - cast(this.waterSpout.width / 2 - this.waterWidth / 2));
			loopSafety--;
		}
		
		this.waterBG.scaleY = waterHeight - this.waterBG.y;
		
		if (small) {
			emitParticles(this.x + waterBG.width / 2 + 7, 2 );
		}
		else {
			emitParticles(this.x+10, 1);
			emitParticles(this.x + waterBG.width / 2 + 7, 2);
			emitParticles(this.x + waterBG.width + 2, 1);
		}

	}
	
	private function emitParticles(x:Float, amt:Int = 1) {
		for (i in 0...amt) {
			fxEmitter.emit("water", x, this.y + waterHeight);
		}
	}
}

package;
import haxepunk.Entity;
import haxepunk.HXP;
import haxepunk.graphics.Image;
import haxepunk.graphics.Spritemap;
import haxepunk.graphics.emitter.Emitter;
import haxepunk.math.Random;
import haxepunk.math.Rectangle;
import haxepunk.math.Vector2;


/**
 * ...
 * @author Taylor
 */

typedef SpritemapData = {
	var width:Int;
	var height:Int;
	var path:String;
}
class Waterfall implements IWater extends Entity{

	var waterSpout:Image;
	var waterBG:Image;
	var waterTop:WaterTop;
	var waterWidth:Int;
	
	var fxEmitter:Emitter;
	var small:Bool;
	
	var waterHeight:Int = 0;
	
	public var isContinuous:Bool = true;
	
	private var particleTimer:Float = 0;
	
	private var columns:Array<WaterColumn> = [];
	public function new(x:Float=0, y:Float=0, small:Bool = false) {
		super(x, y);
		this.small = small;
		if (small) {
			this.waterSpout = new Image("graphics/water-spout-small.png");
			waterWidth = 14;
		}
		else {
			this.waterSpout = new Image("graphics/water-spout.png");
			waterWidth = 28;
		}
		this.layer = Layers.ENTITIES + 1;
		this.waterTop = new WaterTop(0, 0);
	}
	override public function added() {
		this.addGraphic(this.waterSpout);
		

		
		for (i in 0...waterWidth) {
			var col = new WaterColumn(this.x + this.waterSpout.width / 2 - this.waterWidth / 2 + i+0.5, this.y + this.waterSpout.height/2);
			scene.add(col);
			this.columns.push(col);
			col.layer = this.layer - 1;
		}
		

		
		scene.add(waterTop);
		waterTop.layer = this.layer - 2;
		trace(this.waterTop.width);
		this.waterTop.x = this.x + this.waterSpout.width / 2 - this.waterTop.width / 2 + 0.5;
		this.waterTop.y = this.y + this.waterSpout.height / 2 + 2;
		
		fxEmitter = new Emitter("graphics/water-particle.png", 8, 8);
		fxEmitter.newType("water", [0, 1, 2]);
		fxEmitter.setGravity("water", 2.5);
		fxEmitter.setMotion("water", 0, 15, 0.5, 180, 5);
		fxEmitter.setAlpha("water", 1, 0);
		fxEmitter.smooth = false;
		fxEmitter.pixelSnapping = true;
		
		var particles = new Entity(0, 0, fxEmitter);
		scene.add(particles);
		
	}
	
	override public function update() {
		
			for (i in Math.round(Random.range(0, 15))...Math.floor(Random.range(columns.length-15, columns.length))) {
				if (i % 1 == 0) {
					var col = columns[i];
					emitParticles(col.x, col.y + col.height, 1);
				}

			}

	}
	
	public function consume() {}
	
	private function emitParticles(x:Float, y:Float, amt:Int = 1) {
		for (i in 0...amt) {
			fxEmitter.emit("water", x, y);
		}
	}
}

class WaterTop extends Entity {
	var img:Spritemap = new Spritemap("graphics/waterfall-top.png", 26, 9);
	
	public function new(x:Float, y:Float) {
		super(x, y, img);
		this.img.add("anim", [0, 1], 10);
		this.img.play("anim");
		setHitbox(26, 9);
	}
}

class WaterColumn extends Entity {
	var waterBG:Image;
	var collisionVec:Vector2 = new Vector2();
	public function new (x:Float, y:Float) {
		super(x, y, waterBG);
	}
	
	override public function added() {	
		this.waterBG = Image.createRect(1, 1, 0x419bde);
		this.addGraphic(this.waterBG);
	}
	override public function update() {
		
		this.setHitbox(1, 1);
		scene.collideLine("level", Math.ceil(x), Math.ceil(y), Math.ceil(x), Math.ceil(y + 1000), 1, collisionVec);
		
		var waterHeight = collisionVec.y - this.y + 1;
		this.setHitbox(1, cast(waterHeight));
		
		this.waterBG.scaleY = waterHeight;
	}
}
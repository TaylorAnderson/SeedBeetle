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
	var waterStrideData:SpritemapData;
	var waterWidth:Int;
	var waterStrideInterval:Float = 0.3;
	var waterStrideCounter:Float = 0;
	
	var fxEmitter:Emitter;
	var small:Bool;
	public function new(x:Float=0, y:Float=0, small:Bool = false) {
		super(x, y);
		this.small = small;
		if (small) {
			this.waterSpout = new Image("graphics/water-spout-small.png");
			this.waterTop = new Spritemap("graphics/waterfall-top-small.png", 12, 9);
			this.waterStrideData = {width: 12, height: 10, path: "graphics/waterfall-stride-small.png"};
			waterWidth = 14;
		}
		else {
			this.waterSpout = new Image("graphics/water-spout.png");
			this.waterTop = new Spritemap("graphics/waterfall-top.png", 26, 9);
			this.waterStrideData = {width: 26, height: 10, path: "graphics/waterfall-stride.png"};
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
		fxEmitter.setMotion("water", 0, 20, 0.5, 180, 5);
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
		var waterHeight:Int = 0;
		
		var loopSafety = 1000;
		this.setHitbox(waterWidth, 1, - cast(this.waterSpout.width / 2 - this.waterWidth / 2));
		
		while (collide("level", x, y+1) == null && loopSafety > 0) {
			waterHeight += 1;
			this.setHitbox(waterWidth, waterHeight, - cast(this.waterSpout.width / 2 - this.waterWidth / 2));
			loopSafety--;
		}
		
		this.waterBG.scaleY = waterHeight - this.waterBG.y;
		
		if (small) {
			fxEmitter.emit("water", this.x + waterBG.width / 2 + 7, this.y + waterHeight);
		}
		else {
			fxEmitter.emit("water", this.x+11, this.y + waterHeight);
			fxEmitter.emit("water", this.x + waterBG.width / 2 + 7, this.y + waterHeight);
			fxEmitter.emit("water", this.x + waterBG.width + 1, this.y + waterHeight);
		}

		this.waterStrideCounter++;
		if (this.waterStrideCounter/60 > this.waterStrideInterval) {
			waterStrideCounter = 0;
			var waterStride = new WaterStride(this.x + this.waterTop.x + 0.6, this.waterTop.y + this.y, this.waterStrideData, waterHeight);
			waterStride.graphic.clipRect = new Rectangle(0, 0, this.width, waterHeight);
			this.scene.add(waterStride);
			waterStride.layer = this.layer - 1;
		}
	}
}

class WaterStride extends Entity {
	private var img:Spritemap;
	private var waterHeight:Float;
	private var oy:Float;
	private var waterRect:Rectangle;
	public function new(x:Float, y:Float, data:SpritemapData, waterFlowRect:Rectangle) {
		super(x, y);
		this.img = new Spritemap(data.path, data.width, data.height);
		this.waterRect = waterFlowRect
		this.graphic = img;
		
		img.add("anim", [1, 1], 15);
		img.play("anim");
		oy = y;
		this.collidable = false;
	}
	override public function update() {
		this.y += 0.75;
		if (this.y > oy + this.waterHeight) {
			scene.remove(this);
			trace("removing");
		}
	}
}

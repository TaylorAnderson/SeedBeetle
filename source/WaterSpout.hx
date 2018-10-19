package;

import haxepunk.Entity;
import haxepunk.Graphic;
import haxepunk.HXP;
import haxepunk.Mask;
import haxepunk.graphics.Image;
import haxepunk.graphics.Spritemap;
import haxepunk.math.MathUtil;
import haxepunk.math.Random;
import haxepunk.math.Vector2;

/**
 * ...
 * @author Taylor
 */
class WaterSpout extends Entity implements ISwitchObject {

	private var spawnInterval = 1 / 60;
	private var spawnTimer:Float = 0;
	private var angle:Float = 0;
	
	private var img:Spritemap = new Spritemap("graphics/waterspout.png", 12, 12);
	private var bg:Image = new Image("graphics/spoutbg.png");
	public var color:Int = 0;
	public var activated:Bool = true;
	public function new(x:Float = 0, y:Float = 0, angle:Float = 90, color:Int ) {
		super(x, y);
		
		setHitbox(14, 14, 7, 7);
		if (color == -1) activated = true;
		else {
			img.frame = color;
			activated = false;
		}
		this.color = color;
		this.addGraphic(bg);
		this.addGraphic(img);
		
		this.angle = angle;
		img.centerOO();
		img.x += this.img.width / 2;
		img.y += this.img.height / 2;
		bg.x -= this.bg.width / 2;
		bg.y -= this.bg.height / 2;
		img.angle = angle;
	}
	override public function added() {
		if (this.collide("level" , x, y) != null) {
			bg.visible = false;
		}
	}
	public function activate() {
		this.activated = !this.activated;
	}
	override public function update() {
		if (!activated) return;  //the lazy way to disable a behaviour
		spawnTimer += HXP.elapsed;
		if (spawnTimer > spawnInterval) {
			for (i in 0...2) {
				var altAngle = this.angle + Random.range( -10, 10);
				altAngle %= 360;
				var newVec = new Vector2(Math.cos(altAngle * MathUtil.RAD), Math.sin(altAngle * MathUtil.RAD));
				newVec.normalize(Random.range(4, 6));
				var droplet = new WaterDroplet(this.x - 4, this.y - 4, newVec);
				scene.add(droplet);
				scene.add(droplet);
			}

		}
	}
}

class WaterDroplet extends PhysicsObject implements IWater {
	private var img:Spritemap = new Spritemap("graphics/water-droplet.png", 8, 8);
	
	public var isContinuous:Bool = false;
	public function new(x:Float = 0, y:Float = 0, v:Vector2) {
		super(x, y, img);
		img.add("anim", [0, 1, 2, 3], 9, false)
		.onComplete.bind(function() {
			this.scene.remove(this);
		});
		img.add("out", [3, 4], 9, false)
		.onComplete.bind(function() {
			this.scene.remove(this);
		});

		
		this.gravity /= 15;
		this.friction = 0.97;

		img.play("anim");
		this.v = v;
		
		
		type = "water";

	}
	override public function update() {
		super.update();
		
		this.v.x *= friction;
		
		switch img.frame {
			case 0: setHitbox(8, 8);
			case 1: setHitbox(6, 6, -1, -1);
			case 2: setHitbox(4, 4, -2, -2);
			case 3: setHitbox(2, 2, -3, -3);
			case 4: setHitbox(1, 1, -3, -4);
		}
		img.alpha -= 0.03 ;
		
		
		if (collide("level", x, y) != null) {
			this.img.play("out");
			this.v.x = 0;
			this.v.y = 0;
		}
		else {
			img.frame = Math.round(MathUtil.scale(v.x, 0, 6, 3, 0));
		}
	}
	public function consume() {
		scene.remove(this);
	}
}
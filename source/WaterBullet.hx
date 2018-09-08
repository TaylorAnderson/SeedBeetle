package;

import haxepunk.Entity;
import haxepunk.Graphic;
import haxepunk.HXP;
import haxepunk.Mask;
import haxepunk.graphics.Image;
import haxepunk.math.MathUtil;
import haxepunk.math.Vector2;

/**
 * ...
 * @author Taylor
 */
class WaterBullet implements IWater extends Entity {

	private var img:Image = new Image("graphics/droplet.png");
	private var v:Vector2;
	private var friction:Float = 0.995;
	private var gravity:Float = 0.3;
	private var gravResistTimer:Float = 1;
	
	public var isContinuous:Bool = false;
	public function new(x:Float=0, y:Float=0, v:Vector2) {
		super(x, y, img);
		this.setHitbox(img.width, img.height);
		this.v = v.clone();
		type = "water";
		this.img.centerOrigin();
		this.img.x += this.img.width / 2;
		this.img.y += this.img.height / 2;
		
	}
	override public function update() {
		this.img.angle = (MathUtil.angle(0, 0, v.x, v.y)) + 180;
		this.v.x *= friction;
		gravResistTimer -= HXP.elapsed;
		if (gravResistTimer < 0) {
			this.v.y += gravity;
		}
		
		this.x += this.v.x;
		this.y += this.v.y;
		var level = collide("level", x, y);
		//if its a seed, we let the seed handle that collision.
		if (level != null && level != Global.PLAYER && !Std.is(level, Seed)) {
			this.scene.remove(this);
			trace("dying here");
		}
	}
	
	public function consume() {
		scene.remove(this);
	}
	
}
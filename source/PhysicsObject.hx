package;

import haxepunk.Entity;
import haxepunk.Graphic;
import haxepunk.HXP;
import haxepunk.Mask;
import haxepunk.masks.Imagemask;
import haxepunk.masks.Pixelmask;
import haxepunk.math.MathUtil;
import haxepunk.math.Vector2;

/**
 * ...
 * @author Taylor
 */
class PhysicsObject extends Entity {

	private var gravity:Float = 1;
	private var friction:Float = 0.8;
	public var v:Vector2 = new Vector2();

	public var forcesPaused:Bool = false;
	public function new(x:Float=0, y:Float=0, ?graphic:Graphic, ?mask:Mask) {
		super(x, y, graphic, mask);

	}
	override public function update() {
		if (!forcesPaused) {
			v.y += gravity;
			v.x *= friction;
		}
		

		moveBy(v.x, v.y, "level", true);
		
		

	}
	
	override public function moveCollideY(e:Entity):Bool {
		v.y = 0;
		return true;
	}

	override public function moveCollideX(e:Entity):Bool
	{
		v.x = 0;
		return true;
	}
	public function canUseCollision(collisionObj:Entity, useX:Bool) {
		return true;

	}
	public function resolveCollisions(type:String, useX:Bool, useY:Bool, bounce:Bool = false, xOffset:Float = 0, yOffset:Float = 0):Void {

		var collisionObj = collide(type, x + xOffset, y + yOffset);
		if (collisionObj != null) {
			if (useX) {
				if (Math.abs(v.x) > 0) {
					x -= v.x;
					v.x = 0;

				}
			}
			if (useY) {
				if (Math.abs(v.y) > 0) {

					y -= v.y;

					v.y = 0;
				}
			}
		}
	}

	
}
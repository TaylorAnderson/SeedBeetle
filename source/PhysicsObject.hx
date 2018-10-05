package;

import flash.geom.Point;
import haxepunk.Entity;
import haxepunk.Graphic;
import haxepunk.HXP;
import haxepunk.Mask;
import haxepunk.masks.Grid;
import haxepunk.masks.Imagemask;
import haxepunk.masks.Pixelmask;
import haxepunk.math.MathUtil;
import haxepunk.math.Rectangle;
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
	public var collisionsPaused:Bool = false;
	public function new(x:Float = 0, y:Float = 0, ?graphic:Graphic, ?mask:Mask) {
		super(x, y, graphic, mask);
		
	}

	override public function update() {
		if (!forcesPaused) {
			v.y += gravity;
			v.x *= friction;
		}
		this.x += getMovement();
		moveBy(v.x, v.y, "level", true);
		
		if (!collisionsPaused) {
			var cols:Array<Entity> = [];
			this.collideInto("level", x, y, cols);
			for (colObj in cols) {
				var colBounds = this.getBounds(colObj);
				var thisBounds = this.getBounds(this);
				if (Std.is(colObj, PhysicsObject)) {
					//cast(colObj, PhysicsObject).v.add(this.v);
				}
				if (Math.abs(thisBounds.x - colBounds.x) > Math.abs(thisBounds.y - colBounds.y)) {
					if (colBounds.x > thisBounds.x) this.x = colBounds.x - thisBounds.width;
					else this.x = colBounds.right;
				}
				else {
					if (colBounds.y > this.top) this.y = colBounds.top - thisBounds.height;
					else this.y = colBounds.bottom;
				}
			}
		}
	}

	override public function moveCollideY(e:Entity):Bool {
		v.y = 0;
		return true;
	}

	override public function moveCollideX(e:Entity):Bool {
		v.x = 0;
		return true;
	}

	public function canUseCollision(collisionObj:Entity, useX:Bool) {
		return true;
	}
	
	public function resolveCollisions(type:String, useX:Bool, useY:Bool, xOffset:Float = 0, yOffset:Float = 0):Void {
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
	
	public function getMovement(objAbove:Entity = null):Float {
		var below = collide("level", x, y + 1);
		if (below != null) {
			if (Std.is(below, PhysicsObject) && below != objAbove) {
				return cast(below, PhysicsObject).getMovement();
			}
			if (Std.is(below, Mover)) {
				return cast(below, Mover).movement;
			}
		}
		return 0;
	}
	private function getBounds(col:Entity) {
		if (col.mask == null) return new Rectangle(col.left, col.top, col.right - col.x, col.bottom - col.y)
		else {
			if (Std.is(col.mask, Grid)) {
				var grid = cast(col.mask, Grid);
				
				var _rect:Rectangle = new Rectangle();
				var rectX:Int, rectY:Int, pointX:Int, pointY:Int;
				_rect.x = this.x - this.originX - grid.parent.x + grid.x;
				_rect.y = this.y - this.originY - grid.parent.y + grid.y;
				pointX = Std.int((_rect.x + this.width  - 1) / Global.GS) + 1;
				pointY = Std.int((_rect.y + this.height - 1) / Global.GS) + 1;
				rectX  = Std.int(_rect.x / Global.GS);
				rectY  = Std.int(_rect.y / Global.GS);

				for (dy in rectY...pointY) {
					for (dx in rectX...pointX) {
						if (grid.getTile(dx, dy)) {
							return new Rectangle(dx*Global.GS, dy*Global.GS, Global.GS, Global.GS);
						}
					}
				}
			}
			
		}
		return new Rectangle();
	}
}

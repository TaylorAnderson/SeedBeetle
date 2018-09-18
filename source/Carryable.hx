package;

import haxepunk.Entity;
import haxepunk.Graphic;
import haxepunk.Mask;

/**
 * ...
 * @author Taylor
 */
class Carryable extends PhysicsObject {

	public var beingCarried:Bool = false;
	public function new(x:Float=0, y:Float=0, ?graphic:Graphic, ?mask:Mask) {
		super(x, y, graphic, mask);
		this.friction = Global.PLAYER.friction;
		this.gravity = Global.PLAYER.fallingGravity;
		
	}
	
}
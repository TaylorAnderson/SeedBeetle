package;

import haxepunk.Entity;
import haxepunk.Graphic;
import haxepunk.Mask;

/**
 * ...
 * @author Taylor
 */
class Mover extends Entity {

	public var movement:Float = 0;
	private var oldX:Float = 0;
	public function new(x:Float=0, y:Float=0, ?graphic:Graphic, ?mask:Mask) {
		super(x, y, graphic, mask);
		
	}
	
	override public function update() {
		this.movement = this.x - oldX;
		this.oldX = this.x;
	}
	
}
package;

import haxepunk.Entity;
import haxepunk.Graphic;
import haxepunk.Mask;

/**
 * ...
 * @author Taylor
 */
class Water extends Entity {

	public var isContinuous:Bool = false;
	public function new(x:Float=0, y:Float=0, ?graphic:Graphic, ?mask:Mask) {
		super(x, y, graphic, mask);
		
	}
	
	public function consume() {
		this.scene.remove(this);
	}
	
}
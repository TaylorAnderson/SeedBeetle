package plants;

import haxepunk.Entity;
import haxepunk.Graphic;
import haxepunk.Mask;

/**
 * ...
 * @author Taylor
 */
class Plant extends Entity {

	public var climbable:Bool = false;
	public function new(x:Float=0, y:Float=0, ?graphic:Graphic, ?mask:Mask) {
		super(x, y, graphic, mask);
		
	}
	
}
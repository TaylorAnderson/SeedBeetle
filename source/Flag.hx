package;

import haxepunk.Entity;
import haxepunk.Graphic;
import haxepunk.Mask;
import haxepunk.graphics.Spritemap;

/**
 * ...
 * @author Taylor
 */
class Flag extends Entity {

	private var img:Spritemap = new Spritemap("graphics/flag.png", 16, 16);
	public function new(x:Float=0, y:Float=0) {
		super(x, y, img);
		setHitbox(16, 16);
		img.add("wave", [0, 1, 2, 3, 4, 5], 12);
		img.play("wave");
		type = "flag";
		
	}
	
}
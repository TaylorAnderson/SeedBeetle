package;

import haxepunk.Entity;
import haxepunk.Graphic;
import haxepunk.Mask;
import haxepunk.graphics.Spritemap;

/**
 * ...
 * @author Taylor
 */
class Button extends Entity {

	private var img:Spritemap("graphics/button.png",  16, 4);
	public function new(x:Float=0, y:Float=0) {
		super(x, y);
		
		img.add("up", [0])
		img.add("down", [1]);
		
		img.play("up");
		
	}
	
	override public function update() {
		
	}
	
}
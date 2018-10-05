package;

import haxepunk.math.Rectangle;
import haxepunk.Entity;
import haxepunk.Graphic;
import haxepunk.Mask;
import haxepunk.graphics.Image;
import motion.Actuate;
import motion.easing.Expo;

/**
 * ...
 * @author Taylor
 */
class GateHorizontal extends Entity implements ISwitchObject {

	public function new(x:Float=0, y:Float=0, width:Int, seedColor:Int) {
		super(x, y);
		for (i in 0...Std.int(width / 8)) {
			var img = new Image("graphics/gatehoriz.png", new Rectangle(seedColor*8,0, 8, 8));
			img.x = i * 8;
			addGraphic(img);
		}
		setHitbox(width, 8);
		type = "level";
		this.color = seedColor;
		this.layer = Layers.ENTITIES;
		
	}
	
	
	/* INTERFACE ISwitchObject */
	
	public var color:Int;
	
	public function activate():Void {
		Actuate.tween(this, 1, {x: this.x - this.width}).ease(Expo.easeOut);
	}
	
}
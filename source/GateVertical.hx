package;


import haxepunk.Entity;
import haxepunk.Graphic;
import haxepunk.Mask;
import haxepunk.graphics.Image;
import haxepunk.math.Rectangle;
import motion.Actuate;
import motion.easing.Bounce;

/**
 * ...
 * @author Taylor
 */
class GateVertical extends Entity implements ISwitchObject {

	
	public function new(x:Float=0, y:Float=0, height:Int, seedColor:Int) {
		super(x, y);
		for (i in 0...Std.int(height / 8)) {
			var img = new Image("graphics/gatevert.png", new Rectangle(seedColor*8,0, 8, 8));
			img.y = i * 8;
			addGraphic(img);
		}
		setHitbox(8, height);
		type = "level";
		this.color = seedColor;
		this.layer = Layers.ENTITIES;
		
	}
	
	
	/* INTERFACE ISwitchObject */
	
	public var color:Int;
	
	public function activate():Void {
		Actuate.tween(this, 1, {y: this.y + this.height}).ease(Bounce.easeOut);
	}
	
}
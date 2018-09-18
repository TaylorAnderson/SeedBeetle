package;

import flash.display.Sprite;
import haxepunk.Camera;
import haxepunk.Entity;
import haxepunk.Graphic;
import haxepunk.HXP;
import haxepunk.Mask;
import haxepunk.graphics.Image;
import haxepunk.graphics.Spritemap;
import haxepunk.graphics.shader.TextureShader;
import haxepunk.math.Vector2;
import haxepunk.utils.Color;
import haxepunk.utils.Draw;

/**
 * ...
 * @author Taylor
 */

typedef WavePoint = {
	x:Float,
	y:Float,
	spd:Vector2,
	mass:Float
}
class WaterPool extends Entity implements IWater {
	public var isContinuous:Bool;
	private var img:Image;
	private var waves:Array<Spritemap> = [];
	
	public function new(x:Float = 0, y:Float = 0, width:Int = 0, height:Int = 0) {
		
		super(x, y);
		
		type = "water";
			
		for (i in 0...Math.floor(width / 16)) {
			var waves:Spritemap = new Spritemap("graphics/pool-top.png", 16, 3);
			waves.add("waves", [0, 1, 2, 3, 4, 5, 6, 7], 12);
			waves.play("waves");
			this.addGraphic(waves);
			waves.x = i * 16;
			waves.alpha = 0.4;
			this.waves.push(waves);
			
		}

		isContinuous = true;
		
		this.setHitbox(width, height);
		
		img = Image.createRect(width, height, 0x3cacff, 0.4);
		addGraphic(img);
		img.y = 3;
		this.layer = Layers.LEVEL;
	}
	
	public function consume():Void {
		
	}
	
	override public function update():Void {
	}
}


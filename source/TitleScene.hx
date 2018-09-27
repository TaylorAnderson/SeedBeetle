package;

import haxepunk.Entity;
import haxepunk.HXP;
import haxepunk.Scene;
import haxepunk.graphics.Image;
import haxepunk.graphics.text.BitmapText;
import haxepunk.graphics.text.Text;
import haxepunk.input.Input;
import haxepunk.input.Key;
import openfl.Assets;

/**
 * ...
 * @author Taylor
 */
class TitleScene extends Scene {

	private var logo:Entity = new Entity(0, 0, new Image("graphics/mudwell-logo.png"));
	
	private var instruction:Entity = new Entity(0, 0);
	private var txt:Text;
	private var bmt:BitmapText = new BitmapText("Press the numbers 1-9\n to go to that level.", 0, 0, 0, 0, {font: "font/m3x6.fnt", size: 12} );
	
	public function new() {
		super();
		
		
		this.add(logo);
		
		logo.setHitbox(49, 25);
		logo.x = HXP.halfWidth - logo.width/2;
		logo.y = HXP.halfHeight - logo.height;
		
		this.add(instruction);
		
		bmt.smooth = false;
		
		
		instruction.graphic = bmt;
		instruction.x = Math.round(HXP.halfWidth - bmt.textWidth / 2);
		instruction.y = Math.round(HXP.halfHeight + bmt.textHeight);
		
		Key.define("1", [Key.DIGIT_1]);
		Key.define("2", [Key.DIGIT_2]);
		Key.define("3", [Key.DIGIT_3]);
		Key.define("4", [Key.DIGIT_4]);
		Key.define("5", [Key.DIGIT_5]);
		Key.define("6", [Key.DIGIT_6]);
		Key.define("7", [Key.DIGIT_7]);
		Key.define("8", [Key.DIGIT_8]);
		Key.define("9", [Key.DIGIT_9]);
		Key.define("0", [Key.DIGIT_0]);
	}
	
	override public function update() {
		for (i in 0...10) {
			if (Input.pressed(Std.string(i))) HXP.scene = new GameScene(i);
		}
	}
		
		
	
	
}
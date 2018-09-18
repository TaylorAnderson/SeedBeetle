package;

import haxepunk.Entity;
import haxepunk.Graphic;
import haxepunk.HXP;
import haxepunk.Mask;
import haxepunk.graphics.Image;
import haxepunk.graphics.Spritemap;
import haxepunk.math.Rectangle;

/**
 * ...
 * @author Taylor
 */
class WaterMeter extends Entity {

	private var img:Spritemap = new Spritemap("graphics/watercan-ui.png", 24, 24);
	private var bg:Image = new Image("graphics/watercan-ui-bg.png", new Rectangle(41, 0, 41, 41));
	public function new() {
		super();
		img.scrollX = img.scrollY = 0;
		bg.scrollX = bg.scrollY = 0;
		bg.x = HXP.width - bg.width - 8;
		bg.y = 8;
		img.x = bg.x + bg.width / 2 - img.width / 2 - 2;
		img.y = bg.y + bg.height / 2 - img.height / 2 - 1;
		
		bg.centerOrigin();
		bg.x += bg.width / 2;
		bg.y += bg.height / 2;
		
		this.addGraphic(bg);
		this.addGraphic(img);
		this.layer = Layers.UI;
	}
	override public function update() {
		this.img.frame = Global.PLAYER.waterLeft;
	}
	
}
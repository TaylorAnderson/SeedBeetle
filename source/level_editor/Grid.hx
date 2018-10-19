package level_editor;

import flash.display.Sprite;

/**
 * ...
 * @author Taylor
 */
class Grid extends Sprite {

	public function new() {
		super();
		
	}
	
	public function draw(width:Float, height:Float, tileSize:Int, color:Int, alpha:Float=1) {
		var g = this.graphics;
		g.beginFill(color, alpha);
		for (x in 0...Math.floor(width / tileSize)) {
			g.drawRect(x*tileSize, 0, 0.2, height);
		}
		for (y in 0...Math.floor(height / tileSize)) {
			g.drawRect(0, y*tileSize, width, 0.2);
		}
		g.endFill();
	}
	
}
package;

import flash.display.Sprite;

/**
 * ...
 * @author Taylor
 */
class Grid extends Sprite {

	public function new() {
		super();
		
	}
	
	public function draw(width:Float, height:Float, tileSize:Int, color:Int) {
		var g = this.graphics;
		g.beginFill(color);
		for (x in 0...Math.floor(width / tileSize)) {
			g.drawRect(x*tileSize, 0, 1, height);
		}
		for (y in 0...Math.floor(height / tileSize)) {
			g.drawRect(0, y*tileSize, width, 1);
		}
		g.endFill();
	}
	
}
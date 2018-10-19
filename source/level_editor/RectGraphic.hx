package level_editor;

import flash.display.Sprite;

/**
 * ...
 * @author Taylor
 */
class RectGraphic extends Sprite {

	
	public function new() {
		super();
		
	}
	public function draw(w:Float, h:Float, color:Int=0, alpha:Float=1) {
		var g = graphics;
		g.clear();
		g.beginFill(color, alpha);
		g.drawRect(0, 0, w, h);
		g.endFill();
	}
	
}
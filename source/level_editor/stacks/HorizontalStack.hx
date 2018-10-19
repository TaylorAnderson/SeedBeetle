package level_editor.stacks;

import flash.display.Sprite;

/**
 * ...
 * @author Taylor
 */
class HorizontalStack extends LayoutStack {

	
	public function new(elements:Array<Sprite>) {
		super(elements);
	}
	override public function positionElements () {
		for (i in 0...elements.length) {
			var element = elements[i];
			element.y = this.height / 2 - element.height / 2;
			if (elements[i - 1] != null) {
				var prev = elements[i - 1];
				elements[i].x = prev.x + prev.width;
			}
		}
	}
	
}
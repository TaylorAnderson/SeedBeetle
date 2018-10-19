package level_editor.stacks;
import flash.display.Sprite;

/**
 * ...
 * @author Taylor
 */
class VerticalStack extends LayoutStack {

	public function new(elements:Array<Sprite>) {
		super(elements);
		
		
	}
	override public function positionElements() {
		for (i in 0...elements.length) {
			var element = elements[i];
			if (elements[i - 1] != null) {
				var prev = elements[i - 1];
				element.y = prev.y + prev.height + padding;
			}
		}
	}
	
}
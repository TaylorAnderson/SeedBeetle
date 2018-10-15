package level_editor.stacks;

import flash.display.Sprite;
import haxepunk.Entity;

/**
 * ...
 * @author Taylor
 */
class LayoutStack extends Sprite {

	public var elements:Array<Sprite> = [];
	public var padding:Float = 5;
	public function new(elements:Array<Sprite>) {
		super();
		this.elements = elements;
		for (element in elements) {
			this.addChild(element);
		}
		this.positionElements();
	}
	public function positionElements() {
		//override this
	}
	
}
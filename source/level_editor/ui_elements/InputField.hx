package level_editor.ui_elements;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldType;

/**
 * ...
 * @author Taylor
 */
class InputField extends Sprite {

	private var input:TextField = new TextField();
	private var bg:Sprite = new Sprite();
	public function new() {
		super();
		input.type = TextFieldType.INPUT;
		this.addChild(input);
	}
	
}
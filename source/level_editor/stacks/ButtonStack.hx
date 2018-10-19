package level_editor.stacks;
import flash.display.Sprite;
import level_editor.ui_elements.Button;
import level_editor.ui_elements.TextButton;

/**
 * ...
 * @author Taylor
 */

// There's several different places where we need stacks of buttons where we need to keep only one button active in the stack, and know the state of the stack when a button is clicked.
class ButtonStack extends VerticalStack {

	public function new(elements:Array<TextButton>) {
		super(cast(elements));
		for (element in elements) {
			cast(element, TextButton).onClickedSignal.add(this.onButtonClicked);
		}
		
	}
	
	private function onButtonClicked(btn:Button) {
		for (element in elements) {
			if (element != btn) {
				cast(element, TextButton).toggle(false);
			}
		}
	}
	
}
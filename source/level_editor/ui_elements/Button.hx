package level_editor.ui_elements;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import msignal.Signal.Signal1;
import openfl.text.TextField;

/**
 * ...
 * @author Taylor
 */
class Button extends Sprite {


	public var onClickedSignal:Signal1<Button> = new Signal1(Button);

	
	private var btnWidth:Float;
	private var btnHeight:Float;
	
	public var toggled:Bool = false;
	public function new() {
		super();
		
		this.buttonMode = true;
		this.addEventListener(MouseEvent.MOUSE_DOWN, function(e) {
			this.onClicked();
		});
		
	}
	
	private function onClicked() {
		this.onClickedSignal.dispatch(this);
		this.toggle(true);
	}
	
	public function toggle(t:Bool ) {
		this.toggled = t;
		//override this
	}
	
}
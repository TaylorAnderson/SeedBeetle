package level_editor.ui_elements;
import flash.display.CapsStyle;
import flash.display.LineScaleMode;
import flash.display.Sprite;
import level_editor.Rectangle;

/**
 * ...
 * @author Taylor
 */
class Toggle extends Button {

	private var bg:Rectangle = new Rectangle();
	private var check:Sprite = new Sprite();
	
	public function new() {
		super();
		btnWidth = btnHeight = 20;
		bg.draw(btnWidth, btnHeight, 0xFFFFFF);
		
		var cg = check.graphics;
		cg.lineStyle(3, 0x255ea5, 1, null, LineScaleMode.NORMAL, CapsStyle.SQUARE);
		cg.moveTo(0, 4);
		cg.lineTo(6, 9);
		cg.lineTo(13, 0);
		
		this.addChild(bg);
		this.addChild(check);
		
		check.x = bg.width / 2 - check.width / 2 + 2;
		check.y = bg.height / 2 - check.height / 2 + 2;
		
		this.check.visible = false;
	}
	
	override public function onClicked() {
		this.onClickedSignal.dispatch(this);
		this.toggle(!toggled);
	}
	
	override public function toggle(t:Bool) {
		super.toggle(t);
		this.check.visible = t;
	}
	
}
package level_editor.ui_elements;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

/**
 * ...
 * @author Taylor
 */
class TextButton extends Button {

	private var offColor = 0x255ea5;
	private var onColor = 0xe4722b;
	private var txtColor = 0xf7deaf;
	
	private var txt:TextField = new TextField();
	private var bg:RectGraphic = new RectGraphic();
	private var padding:Float = 5;
	
	public var text:String;
	
	
	public function new(txt:String) {
		super();
		this.text = txt;
		btnWidth = 120;
		btnHeight = 20;
		var format = new TextFormat();
		format.size = 14;
		format.color = 0xffffff;
		
		this.txt.text = txt;
		this.txt.defaultTextFormat = format;
		this.txt.autoSize = TextFieldAutoSize.LEFT;
		this.txt.selectable = false;
		
		this.bg.draw(btnWidth, btnHeight, offColor);
		this.addChild(bg);
		this.addChild(this.txt);
		
		this.txt.x = this.padding;
		this.txt.y = bg.height / 2 - this.txt.height / 2;
		
		
	}
	
	override public function toggle (t:Bool) {
		super.toggle(t);
		this.bg.draw(bg.width, bg.height, t ? onColor : offColor);
	}
}
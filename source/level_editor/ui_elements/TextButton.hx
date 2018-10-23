package level_editor.ui_elements;
import flash.display.Bitmap;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import openfl.Assets;

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
	
	private var icon:Bitmap;
	
	public var text:String;
	
	
	public function new(txt:String, icon:Bitmap) {
		super();
		this.text = txt;
		this.icon = icon;
		btnWidth = 120;
		btnHeight = 32;
		var format = new TextFormat();
		format.size = 14;
		format.color = 0xffffff;
		format.font = Assets.getFont("font/SourceSansPro-Regular.ttf").fontName;
		
		this.txt.text = txt;
		this.txt.defaultTextFormat = format;
		this.txt.autoSize = TextFieldAutoSize.LEFT;
		this.txt.selectable = false;
		
		this.icon.width = this.icon.height = 32;
		
		this.bg.draw(btnWidth, btnHeight, offColor);
		
		
		this.addChild(bg);
		this.addChild(this.txt);
		this.addChild(this.icon);
		
		this.bg.x = this.icon.width + 5;
		this.txt.x = this.bg.x + this.padding;
		this.txt.y = bg.height / 2 - this.txt.height / 2;
		
		
		
	}
	
	override public function toggle (t:Bool) {
		super.toggle(t);
		this.bg.draw(bg.width, bg.height, t ? onColor : offColor);
	}
}
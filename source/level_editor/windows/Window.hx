package level_editor.windows;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import level_editor.RectGraphic;
import openfl.Assets;

/**
 * ...
 * @author Taylor
 */
class Window extends Sprite {

	public var title:String = "";
	
	
	private var bg:RectGraphic = new RectGraphic();
	private var topBar:RectGraphic = new RectGraphic();
	private var topBarInteractive:RectGraphic = new RectGraphic();
	private var shadow:RectGraphic = new RectGraphic();
	private var outline:RectGraphic = new RectGraphic();
	private var content:Sprite = new Sprite();
	private var titleText:TextField = new TextField();
	private var outerPadding:Float = 6;
	private var barHeight:Float = 20;
	private var outlinePadding = 2;
	private var caption:String;
	
	
	public function new(caption:String) {
		super();

		this.scaleX = this.scaleY = 0.25;
		
		this.caption = caption;
		
		//drawing
		setupContent();
		
		var format = new TextFormat();
		format.color = 0xFFFFFF;
		format.size = 14;
		format.font = Assets.getFont("font/SourceSansPro-Regular.ttf").fontName;
		
		titleText.text = caption;
		titleText.defaultTextFormat = format;
		titleText.autoSize = TextFieldAutoSize.LEFT;
		titleText.selectable = false;
		bg.draw(content.width + outerPadding * 2, content.height + outerPadding * 2, 0x1f3c61);
		
		topBar				.draw(bg.width, this.barHeight, 0x255ea5);
		topBarInteractive	.draw(bg.width, this.barHeight, 0x255ea5, 0);
		
		shadow.draw(bg.width, outlinePadding*2, 0x181e32);
		
		outline.draw(bg.width + outlinePadding * 2, bg.height + barHeight + shadow.height + outlinePadding * 2, 0xFFFFFF);
		
		//adding kids
		this.addChild(this.outline);
		this.addChild(this.topBar);
		this.addChild(this.shadow);
		this.addChild(this.titleText);
		this.addChild(this.bg);
		this.addChild(this.content);
		this.addChild(this.topBarInteractive);
		
		
		//positioning
		topBar.x = outlinePadding;
		topBar.y = outlinePadding;
		topBarInteractive.x = outlinePadding;
		topBarInteractive.y = outlinePadding;
		
		bg.x = outlinePadding;
		bg.y = topBar.y + barHeight + shadow.height;
		
		shadow.x = topBar.x;
		shadow.y = topBar.y + barHeight;
		
		content.x = bg.x + outerPadding;
		content.y = bg.y + outerPadding;
		
		//not a real calculation just felt like outerPadding was too much
		titleText.x = topBar.x + outerPadding / 2;
		
		titleText.y = topBar.y + barHeight / 2 - titleText.height / 2;
		
		//listeners
		this.topBarInteractive.buttonMode = true;
		this.topBarInteractive.addEventListener(MouseEvent.MOUSE_DOWN, function(e) {this.startDrag(); });
		this.topBarInteractive.addEventListener(MouseEvent.MOUSE_UP, function(e) {this.stopDrag(); });
	}
	public function setupContent() {
		//override this
	}
	
}
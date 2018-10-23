package level_editor.ui_elements;
import flash.display.Bitmap;
import flash.display.Sprite;
import level_editor.RectGraphic;
import openfl.Assets;

/**
 * ...
 * @author Taylor
 */
class IconButton extends Button {

	private var icon:Bitmap;
	private var bg:RectGraphic = new RectGraphic();
	private var padding:Float = 2;
	
	private var offColor = 0x8bd3f1;
	private var onColor = 0xe4722b;
	public function new(imgPath:String) {
		super();
		this.icon = new Bitmap(Assets.getBitmapData(imgPath));
		
		//this.icon.scaleX = this.icon.scaleY = 2;
		
		this.bg.draw(icon.width+padding*2, icon.height+padding*2, this.offColor);
		
		this.icon.x = this.icon.y = padding;
		
		this.addChild(bg);
		this.addChild(icon);
	}
	
	override public function toggle (t:Bool) {
		super.toggle(t);
		this.bg.draw(bg.width, bg.height, t ? onColor : offColor);
	}
	
}
package level_editor.ui_elements;
import flash.display.Bitmap;
import flash.display.Sprite;
import openfl.Assets;

/**
 * ...
 * @author Taylor
 */
class IconButton extends Button {

	private var icon:Bitmap;
	private var bg:Sprite;
	private var padding:Float = 5;
	public function new(imgPath:String) {
		super();
		this.icon = new Bitmap(Assets.getBitmapData(imgPath));
		
		var g = this.bg.graphics;
		g.beginFill(0xFFFFFF);
		g.drawRect(0, 0, icon.width + padding * 2, icon.height + padding * 2)
		g.endFill();
		
		this.icon.x = this.icon.y = padding;
		
	}
	
}
package level_editor.windows;

import level_editor.ui_elements.TilemapUI;
import level_editor.windows.Window;

/**
 * ...
 * @author Taylor
 */
class TilemapWindow extends Window {

	private var tilesetPath:String;
	public function new(tilesetPath:String) {
		super("Tile Palette");
		this.tilesetPath = tilesetPath;
		
	}
	override public function setupContent() {
		var tilemapUI = new TilemapUI(this.tilesetPath);
	}
	
}
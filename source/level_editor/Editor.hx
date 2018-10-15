package level_editor;

import flash.display.Sprite;
import haxe.Json;
import level_editor.ui_elements.InputField;
import level_editor.windows.LayersWindow;
import level_editor.windows.Window;
import openfl.Assets;

/**
 * ...
 * @author Taylor
 */
class Editor extends Sprite {

	private var dataManager:DataManager;
	public function new(levelPath:String) {
		super();
		
		dataManager = new DataManager(Json.parse(Assets.getText(levelPath)));
		var levelData = dataManager.getData();
		this.addChild(new Background());
		this.addChild(new Level(levelData));
		

		this.addChild(new LayersWindow());
		
	}
	
}
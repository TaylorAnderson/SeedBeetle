package level_editor;

import level_editor.DataManager.LevelData;
import flash.display.Sprite;
import haxepunk.HXP;

/**
 * ...
 * @author Taylor
 */
class Level extends Sprite {

	private var bg:Rectangle = new Rectangle();
	private var grid:Grid = new Grid();

	private var levelWidth:Float;
	private var levelHeight:Float;

	public var layers:Array<Layer> = [];
	public function new(levelData:LevelData) {
		super();
		this.levelWidth = levelData.width*Global.GS;
		this.levelHeight = levelData.height*Global.GS;
		bg.draw(levelWidth, levelHeight, 0x181e32);
		grid.draw(levelWidth, levelHeight, Global.GS*2, 0x1f3c61);
		this.addChild(bg);
		this.addChild(grid);
		
	}
	
}
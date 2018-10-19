package level_editor.layers;

import level_editor.DataManager.LayerProjectData;
import level_editor.DataManager.LayerFileData;
/**
 * ...
 * @author Taylor
 */
 typedef GridTile = {
	 current:Bool,
	 preview:Bool,
	 isPreview:Bool
 }
class GridLayer extends Layer {

	static inline var tileColor:Int = 0x846b50;
	static inline var tileSize = Global.GS; //*2 because we scaled up...at some point we're probably gonna have to scale up the whole deal and don't worry about this everywhere
	private var gridData:Array<Array<GridTile>> = [];
	public function new(layerData:LayerFileData) {
		super();
		
		loadFromString(layerData.data);
		
	}
	public function loadFromString(str:String) {
		var strArr = str.split("\n");
		gridData = [for (x in 0...strArr[0].length) [for (y in 0...strArr.length) {current: false, preview: false, isPreview: false}]];
		for (y in 0...strArr.length) {
			for (x in 0...strArr[y].length) {
				setTile(x, y, strArr[y].charAt(x) == "1", false);
			}
		}
	}
	
	public function setTile(x:Int, y:Int, collidable:Bool, isPreview:Bool) {
		gridData[x][y] = {current: collidable, preview: false, isPreview: false};
		this.draw();
	}
	public function setRect(x:Int, y:Int, width:Int, height:Int, collidable:Bool, isPreview:Bool) {
		for (xPos in x...width) {
			for (yPos in y...height) {
				setTile(xPos, yPos, collidable, isPreview);
			}
		}
	}
	private function draw() {
		this.graphics.clear();
		this.graphics.beginFill(tileColor);
		for (x in 0...gridData.length) {
			for (y in 0...gridData[x].length) {
				if (gridData[x][y].current) {
					this.graphics.drawRect(x*tileSize, y*tileSize, tileSize, tileSize);
				}
				
			}
		}
	}
	
}
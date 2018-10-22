package level_editor.stacks;
import flash.display.Sprite;

/**
 * ...
 * @author Taylor
 */
class GridStack extends LayoutStack {

	private var gridWidth:Int,
	private var gridHeight:Int
	public function new(elements:Array<Sprite>, gridWidth:Int, gridHeight:Int) {
		this.gridWidth = gridWidth;
		this.gridHeight = gridHeight;
		super(elements);

		
	}
	
	override public function positionElements() {
		var gridElements:Array<Array<Sprite>> = [for (i in 0...this.gridHeight) [for (j in 0...width) null]];
		var curX = 0;
		var curY = 0;
		for (e in elements) {
			gridElements[curY][curX] = e;
			curX++;
			if (curX > this.gridWidth) {
				curY++;
			}
		}
		for (y in 0...gridElements.length) {
			for (x in 0...gridElements[y].length) {
				var element = gridElements[y][x];
				var left = gridElements[y][x - 1];
				var above = gridElements[y - 1][x];
				element.x = left ? left.x + left.width : 0
				element.y = top ? top.y + top.height : 0;
			}
		}
	}
	
}
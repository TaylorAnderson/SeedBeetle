package level_editor.stacks;
import flash.display.Sprite;

/**
 * ...
 * @author Taylor
 */
class GridStack extends LayoutStack {

	private var gridWidth:Int;
	private var gridHeight:Int;
	public function new(elements:Array<Sprite>, gridWidth:Int) {
		this.gridWidth = gridWidth;
		this.gridHeight = Math.ceil(elements.length / gridWidth);
		super(elements);

		
	}
	
	override public function positionElements() {
		var gridElements:Array<Array<Sprite>> = [for (i in 0...this.gridHeight) [for (j in 0...this.gridWidth) null]];
		var curX = 0;
		var curY = 0;
		for (e in elements) {
			gridElements[curY][curX] = e;
			curX++;
			if (curX >= this.gridWidth) {
				curY++;
				curX = 0;
			}
		}
		for (y in 0...gridElements.length) {
			for (x in 0...gridElements[y].length) {
				
				var element = gridElements[y][x];
				if (element != null) {
					var left = gridElements[y][x - 1];
				
					var top = null;
					if (y > 0) top = gridElements[y - 1][x];
					
					element.x = left != null ? left.x + left.width+padding : 0;
					element.y = top != null ? top.y + top.height + padding : 0;
				}

			}
		}
	}
	
}
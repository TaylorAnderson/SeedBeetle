package plants;

import haxepunk.Entity;
import haxepunk.Graphic;
import haxepunk.HXP;
import haxepunk.Mask;
import haxepunk.masks.Grid;

/**
 * ...
 * @author ...
 */

class SwitchColors {
	public static inline var ORANGE:Int = 1;
 }
class SwitchBlossom extends Plant 
{


	private var rootGrid:RootGrid = new RootGrid();
	public function new(x:Float=0, y:Float=0, ?graphic:Graphic, ?mask:Mask) 
	{
		super(x, y, graphic, mask);
		
		

	}
	
	override public function added() {
		this.rootGrid.loadGrid();
		this.scene.add(rootGrid);
	}

	
}
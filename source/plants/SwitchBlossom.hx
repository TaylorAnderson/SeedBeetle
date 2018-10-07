package plants;

import flash.geom.Point;
import haxepunk.Entity;
import haxepunk.Graphic;
import haxepunk.HXP;
import haxepunk.Mask;
import haxepunk.ai.path.PathNode;
import haxepunk.graphics.Image;
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
	private var color:Int;
	
	private var target:ISwitchObject;
	public function new(x:Float=0, y:Float=0, color:Int) 
	{
		super(x, y);
		this.color = color;
		setHitbox(8, 8);
		type = "";

	}
	
	override public function added() {
		this.scene.add(rootGrid);
		
		this.target = cast(scene, GameScene).getEntityWithSeedColor(this.color);
		
		this.scene.add(new SwitchRoot(new Point(this.x, this.y + Global.GS), target, this.rootGrid, this.color));
	}

	
}



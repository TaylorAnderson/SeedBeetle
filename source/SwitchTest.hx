package;

import flash.geom.Point;
import haxepunk.Entity;
import haxepunk.Graphic;
import haxepunk.Mask;
import haxepunk.graphics.Image;

/**
 * ...
 * @author ...
 */
class SwitchTest extends Entity implements ISwitchObject 
{

	
	public function new(x:Float=0, y:Float=0, ?graphic:Graphic, ?mask:Mask) 
	{
		super(x, y, Image.createRect(16, 16, 0xFF0000));
		
	}
	
	
	/* INTERFACE ISwitchObject */
	
	public function activate():Void  {
		this.graphic = Image.createRect(16, 16, 0);
	}
	
	public function getAttachments():Array<Point> 
	{
		
	}
	
}
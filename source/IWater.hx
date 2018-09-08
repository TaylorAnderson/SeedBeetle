package;

import haxepunk.Entity;
import haxepunk.Graphic;
import haxepunk.Mask;

/**
 * ...
 * @author Taylor
 */
interface IWater {

	public var isContinuous:Bool = false;
	
	public function consume():Void;
	
}
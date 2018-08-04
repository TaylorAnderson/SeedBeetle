import com.haxepunk.Engine;
import com.haxepunk.HXP;
import haxepunk.Graphic;
import haxepunk.debug.Console;
import haxepunk.pixel.PixelArtScaler;


class Main extends Engine
{
	public function new() {
		super(240, 160,60, false);
		
	}
	override public function init()
	{

#if debug
		Console.enable();
#end
		
		Graphic.smoothDefault = false;
		Graphic.pixelSnappingDefault = true;
		//PixelArtScaler.globalActivate();
		
		//HXP.resize(960, 640);
		HXP.scene = new GameScene();
	}

	public static function main() { new Main(); }
	

}
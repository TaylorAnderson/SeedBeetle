import com.haxepunk.Engine;
import com.haxepunk.HXP;
import haxepunk.Graphic;
import haxepunk.debug.Console;
import haxepunk.pixel.PixelArtScaler;
// import haxepunk.pixel.PixelArtScaler;
import openfl.Lib;
import openfl.display.FPS;

class Main extends Engine {
	public function new() {
		super(240, 160, 60, false);
	}

	override public function init() {
		#if debug
		Console.enable();
		#end

		Graphic.smoothDefault = false;
		Graphic.pixelSnappingDefault = true;
		// PixelArtScaler.globalActivate();

		HXP.resize(960, 640);
		HXP.scene = new TitleScene();

		var fps:FPS = new FPS(10, 10, 0);
		var format = fps.defaultTextFormat;
		format.size = 20;
		fps.defaultTextFormat = format;
		// Lib.current.stage.addChild(fps);
	}

	public static function main() {
		new Main();
	}
}

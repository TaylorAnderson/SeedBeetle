import com.haxepunk.Scene;
import haxepunk.Entity;
import haxepunk.Graphic;
import haxepunk.HXP;
import haxepunk.graphics.Image;
import haxepunk.input.Input;
import haxepunk.input.InputType;
import haxepunk.input.Key;
import haxepunk.math.MathUtil;
import haxepunk.math.Vector2;
import level_editor.Editor;
import motion.Actuate;
import motion.easing.Back;
import openfl.Assets;
import openfl.Lib;

class GameScene extends Scene {
	private var player:Player;
	public var level:LevelChunk;
	private var snappedCamera:Bool = false;
	public var isLevelComplete:Bool = false;
	private var levelCompleteLogo:Entity;
	private var levelCompleteBG:Entity;
	private var levelIndex:Int;
	
	private var allEntities:Array<Entity> = [];
	
	private var camX:Float = 0;
	private var camY:Float = 0;
	public var paused:Bool = false;
	public var entitiesToUpdateDuringPause:Array<Entity> = [];
	
	public var inEditorMode = false;
	
	public var editor:Editor;
	public function new(levelIndex:Int ) {
		super();
		this.levelIndex = levelIndex;
		this.editor = new Editor("levels/level-editor-init.json");
	
	}

	public override function begin() {
		this.player = new Player();

		Global.PLAYER = player;

		this.add(player);
		var levelPath = "levels/level" + this.levelIndex + ".oel";
		this.add(level = new LevelChunk(0, 0, levelPath, player));
		this.add(new WaterMeter());

		Key.define("RESET", [Key.R]);
		Key.define("EDITOR", [Key.ESCAPE]);

		HXP.camera.pixelSnapping = true;
		
		levelCompleteBG = new Entity(0, 0, Image.createRect(HXP.width, HXP.height, 0));
		levelCompleteLogo = new Entity(0, 0, new Image("graphics/levelcomplete.png"));
		
		levelCompleteBG.followCamera = HXP.camera;
		levelCompleteLogo.followCamera = HXP.camera;
		levelCompleteLogo.setHitbox(52, 26);
		this.add(levelCompleteLogo);
		this.add(levelCompleteBG);
		
		this.levelCompleteLogo.layer = Layers.UI - 2;
		this.levelCompleteBG.layer = Layers.UI - 1;
		
		levelCompleteBG.graphic.alpha = 0;
		this.levelCompleteLogo.y = HXP.height;
		
		

	}

	public function reset() {
		HXP.scene = new GameScene(this.levelIndex);
	}
	
	public function getEntityWithSeedColor(color:Int) {
		var all:Array<Entity> = [];
		this.getAll(all);
		for (e in all) {
			if (Std.is(e, ISwitchObject) && cast(e, ISwitchObject).color == color) {
				return cast(e, ISwitchObject);
			}
		}
		return null;
	}

	public override function update() {
		allEntities = [];
		this.getAll(allEntities);
		

		if (!isLevelComplete && !paused) {
			super.update();
		}
		if (isLevelComplete) {
			this.updateEntity(levelCompleteBG);
			this.updateEntity(levelCompleteLogo);
		}
		if (paused) {
			for (entity in entitiesToUpdateDuringPause) {
				this.updateEntity(entity);
			}
		}
		
		
		

		if (Input.pressed("RESET")) {
			reset();
		}
		if (Input.pressed("EDITOR")) {
			inEditorMode = !inEditorMode;
			
			if (inEditorMode) {
				this.paused = true;
				//we'll want to give this data to actually load the level we're in but....later
				Lib.current.stage.addChild(this.editor);
			}
			else {
				this.paused = false;
				Lib.current.stage.removeChild(this.editor);
			}

		}

		if (!snappedCamera) {
			var playerPosInfluence = new Vector2(player.x - HXP.halfWidth + player.halfWidth, player.y - HXP.halfHeight + player.halfHeight);
			HXP.camera.x = playerPosInfluence.x + 30;
			HXP.camera.y = playerPosInfluence.y;

			snappedCamera = true;
		}
		var offset = player.inputVector.clone();
		offset.normalize(40);
		var playerPosInfluence = new Vector2(player.x - HXP.halfWidth + player.halfWidth, player.y - HXP.halfHeight + player.halfHeight);
		var playerLookInfluence = new Vector2(offset.x, offset.y);
		MathUtil.clampInRect(playerPosInfluence, 0, 0, this.level.width - HXP.width, this.level.height - HXP.height);
		MathUtil.clampInRect(playerLookInfluence, 0, 0, this.level.width - HXP.width, this.level.height - HXP.height);

		HXP.camera.x = (MathUtil.lerp((HXP.camera.x), (playerPosInfluence.x), 0.25 ));
		HXP.camera.y = (MathUtil.lerp((HXP.camera.y), (playerPosInfluence.y), 0.25));
	}
	
	public function completeLevel() {
		if (isLevelComplete) return;
		this.isLevelComplete = true;
		
		var duration = 0.7;
		this.levelCompleteLogo.x = HXP.halfWidth - levelCompleteLogo.width / 2;
		Actuate.tween(this.levelCompleteLogo, duration, {y: HXP.halfHeight - this.levelCompleteLogo.height / 2}).ease(Back.easeOut).delay(duration);
		Actuate.tween(this.levelCompleteBG.graphic, duration, {alpha: 0.5});
		Actuate.timer(duration*4).onComplete(function() {HXP.scene = new TitleScene(); });
	}
}

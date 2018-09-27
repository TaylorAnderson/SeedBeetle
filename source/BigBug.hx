package;

import flash.geom.Point;
import haxepunk.Entity;
import haxepunk.Graphic;
import haxepunk.HXP;
import haxepunk.Mask;
import haxepunk.graphics.Image;
import haxepunk.graphics.hardware.Texture;
import haxepunk.masks.Imagemask;
import haxepunk.masks.Pixelmask;
import haxepunk.math.MathUtil;

/**
 * ...
 * @author Taylor
 */

 enum BigBugState {
	 WALKING;
	 WINDING_UP;
	 STRIKING;
 }
class BigBug extends PhysicsObject {

	private var img:Image = new Image("graphics/big-bug.png");
	private var fsm:StateMachine<BigBugState> = new StateMachine(BigBugState);
	private var speed = 0.25;
	
	private var footingCheck:Entity = new Entity();
	
	private var positionToHeadbutt:Float;
	
	private var windupTimer:Float = 0;
	private var windupTime:Float = 0.3;
	
	private var headbuttDir:Float = 0;
	
	private var branch:BugBranch = new BugBranch(0, 0);
	
	private var interval:Float;
	private var counter = 0;
	public function new(x:Float=0, y:Float=0) {
		super(x, y, img);
		
		interval = 1 / speed;
		setHitbox(50, 30, 0, -6);
		
		fsm.bind(BigBugState.WALKING, onWalkEnter, onWalkUpdate, onWalkExit);
		fsm.bind(BigBugState.WINDING_UP, onWindupEnter, onWindupUpdate, onWindupExit);
		fsm.bind(BigBugState.STRIKING, onStrikeEnter, onStrikeUpdate, onStrikeExit);
		
		fsm.changeState(BigBugState.WALKING);
		this.friction = 1;
		
		
		footingCheck.setHitbox(cast(this.width / 4), 2);
		

		this.collisionsPaused = true;
		
		this.layer = Layers.ENTITIES;
		
		
	}
	
	override public function added() {
		this.scene.add(footingCheck);
		this.scene.add(branch);
	}
	
	override public function update() {
		this.branch.x = this.x+1;
		this.branch.y = this.y;
		super.update();
		fsm.update();
		
		

	}
	
	private function onWalkEnter() {
		this.v.x = this.speed;
	}
	private function onWalkUpdate() {
		img.flipped = v.x > 0;
		var inFront = collide("level", x + MathUtil.sign(v.x), y);
		if (inFront == branch) inFront = null;
		if (inFront != null) {
			if (Std.is(inFront, PhysicsObject)) {
				positionToHeadbutt = inFront.x;
				fsm.changeState(BigBugState.WINDING_UP);
			}
			else {
				v.x *= -1;
			}
		}
		
		
		this.footingCheck.x = this.x + MathUtil.sign(v.x) * this.footingCheck.width;
		if (v.x > 0) this.footingCheck.x = this.x + this.width;
		this.footingCheck.y = this.bottom;
		
		if (footingCheck.collide("level", footingCheck.x, footingCheck.y) == null) {
			v.x *= -1;
		}
	}
	private function onWalkExit() {
		
	}
	
	private function onWindupEnter() {
		
	}
	private function onWindupUpdate() {
		var back = MathUtil.sign(this.positionToHeadbutt - this.x) * -1;
		v.x = back * 0.5;
		windupTimer+= HXP.elapsed;
		if (windupTimer > windupTime) {
			fsm.changeState(BigBugState.STRIKING);
			windupTimer = 0;
		}
		
	}
	private function onWindupExit() {
		
	}
	
	private function onStrikeEnter() {
		headbuttDir = MathUtil.sign(this.positionToHeadbutt - this.x);
		
	}
	private function onStrikeUpdate() {
		this.v.x = headbuttDir * 8;
		var inFront = collide("level", x + MathUtil.sign(v.x), y);
		if (inFront != null) {
			//probably need another state for recovery
			
			if (Std.is(inFront, PhysicsObject)) {
				var obj = cast(inFront, PhysicsObject);
				obj.v.x = this.v.x;
				obj.v.y = -2;
			}
			fsm.changeState(BigBugState.WALKING);
		}
	}
	private function onStrikeExit() {
		
	}
	
	override public function moveCollideX(e:Entity) {
		if (e == branch) return true;
		else return super.moveCollideX(e);
	}
		override public function moveCollideY(e:Entity) {
		if (e == branch) return true;
		else return super.moveCollideY(e);
	}
	
}

class BugBranch extends Mover {
	
	public function new(x:Float=0, y:Float=0) {
		super(x, y, new Image("graphics/big-branch.png"));
		setHitbox(42, 6);
		type = "level";
		
	}
}
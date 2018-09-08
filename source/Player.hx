package;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.math.Vector2;
import haxepunk.Entity;
import haxepunk.HXP;
import haxepunk.graphics.Graphiclist;
import haxepunk.graphics.Image;
import haxepunk.graphics.Spritemap.Animation;
import haxepunk.masks.Imagemask;
import haxepunk.masks.Pixelmask;
import plants.Plant;

//import com.haxepunk.Sfx;
import com.haxepunk.input.Input;
import com.haxepunk.input.Key;
import haxepunk.math.MathUtil;

/**
 * ...
 * @author Taylor Anderson
*/
enum PlayerState {
	GROUND;
	AIR;
	CLIMBING;
	CARRYING;
}
class PInput {
	public static inline var LEFT = "left";
	public static inline var RIGHT = "right";
	public static inline var UP = "up";
	public static inline var DOWN = "down";
	public static inline var JUMP = "jump";
	public static inline var GRAB = "grab";
	public static inline var SHOOT = "shoot";

}
class PAnim {
	public static inline var WALK = "walk";
	public static inline var JUMP = "jump";
	public static inline var IDLE = "idle";
	public static inline var CLIMB = "climb";
}
class Player extends PhysicsObject {
	private var img:Spritemap = new Spritemap("graphics/player.png", 16, 16);
	private var groundFriction:Float = 0.8;
	private var grappleFriction:Float = 1;
	private var airFriction:Float = 0.95;
	private var accel:Float = 0.5;
	
	private var speed:Float = 1;
	private var normalSpeed:Float = 1;
	private var carryingSpeed:Float = 0.6;
	private var jumpCount:Int = 0;
	private var jumpStrength:Float = 3;
	private var hoverTime:Float = 0.6;
	private var hoverCounter:Float = 0;
	private var hasJumped:Bool = false;
	
	private var risingGravity:Float = 0.1;
	private var fallingGravity:Float = 0.15;
	
	private var fsm:StateMachine<PlayerState>;
	private var addedVelocity:Bool = false;
	public var inputVector:Vector2 = new Vector2();
	public var carrying:Carryable;
	
	private var liftedOff:Bool = false;
	private var carryOriginalX:Float = 0;
	
	private var climbing:Entity;
	private var climbingPos:Float;
	
	public function new() {
		super(0, 0, new Graphiclist([img]));
		
		
		fsm = new StateMachine(PlayerState);
		
		
		fsm.bind(PlayerState.GROUND, this.onGroundEnter, this.onGroundUpdate, this.onGroundExit);
		fsm.bind(PlayerState.AIR, this.onAirEnter, this.onAirUpdate, this.onAirExit);
		fsm.bind(PlayerState.CARRYING, this.onCarryEnter, this.onCarryUpdate, this.onCarryExit);
		fsm.bind(PlayerState.CLIMBING, this.onClimbEnter, this.onClimbUpdate, this.onClimbExit);
		setHitbox(20, 16);
		
		fsm.changeState(PlayerState.GROUND);
		
		
		Input.define(PInput.LEFT, [Key.LEFT, Key.A]);
		Input.define(PInput.RIGHT, [Key.RIGHT, Key.D]);
		Input.define(PInput.UP, [Key.UP, Key.W]);
		Input.define(PInput.DOWN, [Key.DOWN, Key.S]);
		Input.define(PInput.JUMP, [Key.SPACE]);
		
		Input.define(PInput.GRAB, [Key.Z, Key.SHIFT, Key.R]);
		Input.define(PInput.SHOOT, [Key.E, Key.X]);
		
		var walkAnim = img.add(PAnim.WALK, [0], 15, true);
		var idleAnim = img.add(PAnim.IDLE, [0]);
		var jumpAnim = img.add(PAnim.JUMP, [1]);
		var climbAnim = img.add(PAnim.CLIMB, [2]);
		
		type = "level";    
		name = "player";
		
		this.layer = Layers.ENTITIES;
		
		
		this.fsm.onChangeState.bind(function() {
		});
	}
	public function onGroundEnter():Void {
		friction = groundFriction;
		hoverCounter = 0;
		hasJumped = false;
		v.y = 0;
		setHitbox(16, 14, 0, -2);
	
	}
	private function onGroundUpdate():Void {
		
		if (Input.pressed(PInput.JUMP)) {
			v.y = -jumpStrength;
		}
		
		if (Input.pressed(PInput.SHOOT)) {
			var bullet = new WaterBullet(x + (img.flipped ? 13 : -2), y + 7, img.flipped ? new Vector2(4, 0) : new Vector2( -4, 0));
			scene.add(bullet);
		}
		
		if (collide("level", x, y + 1) == null) {
			fsm.changeState(PlayerState.AIR);
		}	
		
		if (isClimbing()) {
			fsm.changeState(PlayerState.CLIMBING);
		}
		
		if (Math.abs(v.x) > 0.5) {
			img.play(PAnim.WALK);
		}
		else img.play(PAnim.IDLE);
		
		handleMovement();
		this.speed = normalSpeed;
		this.carrying = null;
		if (Input.check(PInput.GRAB)) {
			var left = 	collide("level", x - 3, y);
			var right = 	collide("level", x + 3, y);
			var bottom = 	collide("level", x, y + 1);
			
			if (left != null || right != null || bottom != null) this.speed = this.carryingSpeed;
			
			if (left != null && Std.is(left, Carryable)) {
				this.carrying = cast(left, Carryable);
			}
			else if (right != null && Std.is(right, Carryable)) {
				this.carrying = cast(right, Carryable);
			}
			else if (bottom != null && Std.is(bottom, Carryable)) {
				this.carrying = cast(bottom, Carryable);
				fsm.changeState(PlayerState.CARRYING);
			}
			
			resolveCollisions("level", true, false);
			resolveCollisions("level", false, true);
			
			if (this.carrying != null) {
				this.carrying.v.x = this.v.x;
				this.v.x = this.carrying.v.x;
			}
		}
	}
	private function onGroundExit():Void {
		
	}
	
	private function onAirEnter():Void {
		this.friction = airFriction;
		setHitbox(img.width, 12, 0, -4);
	}
	private function onAirUpdate():Void {
		img.play("jump");
		
		if (collide("level", x, y+1) != null) {
			fsm.changeState(PlayerState.GROUND);
		}	
		if (Input.check(PInput.JUMP) && hoverCounter <= hoverTime && hasJumped) {
			v.y -= 0.2;
			hoverCounter+=HXP.elapsed;
		}
		if (Input.released(PInput.JUMP) && hoverCounter == 0) {
			v.y *= 0.5;
			hasJumped = true;
			
		}
		
		if (isClimbing()) {
			fsm.changeState(PlayerState.CLIMBING);
		}
		
		handleMovement();
		
	}
	private function onAirExit():Void {
		
	}
	
	private function onCarryEnter():Void {
		this.carrying.gravity = this.gravity;
		liftedOff = false;
		setHitbox(20, 10, 2, -6);
		
		//carrying.forcesPaused = true;
		v.y = -gravity - 2;
		this.carrying.v.y = -gravity - 2;
		this.x = this.carrying.x + carrying.width / 2 - this.width / 2;
		
		if (Std.is(carrying, Seed)) {
			this.x += 4; // to match seed offset
		}
		
	}
	private function onCarryUpdate():Void {
		img.play(PAnim.JUMP);
		
		handleMovement();
		
		v.y = -gravity;
		
		this.carrying.v.x = this.v.x;
		
		//i hate how i had to do this and will figure out how to get it into a nice function later.
		this.carrying.x += this.carrying.v.x;
		this.carrying.resolveCollisions("level", true, false);
		this.carrying.x -= this.carrying.v.x;
		
		this.v.x = this.carrying.v.x;
		
		this.carrying.v.y = -gravity;
		
		
		
		this.carrying.gravity = this.gravity;
		
		
		
		if (!Input.check(PInput.GRAB)) {
			fsm.changeState(PlayerState.AIR);
		}

	}
	private function onCarryExit():Void {
		carrying.forcesPaused = false;
		carrying = null;
	}
	
	private function onClimbEnter():Void {
		this.forcesPaused = true;
				
		if (collide("level", x + 1, y) != null) {
			this.climbing = collide("level", x + 1, y);
			climbingPos = 1;
		}
		else {
			this.climbing = collide("level", x - 1, y);
			climbingPos = -1;
		}
		this.img.flipX = climbingPos > 0;
		
		if (this.img.flipX) {
			setHitbox(11, 16, -5, 0);
		}
		else {
			setHitbox(11, 16);
		}
		
		
	}
	private function onClimbUpdate():Void {
		
		img.play(PAnim.CLIMB);
		v.y = 0;
		if (Input.check(PInput.UP)) {
			v.y = -1;
			this.img.flipY = false;
		}
		if (Input.check(PInput.DOWN)) {
			v.y = 1;
			this.img.flipY = true;
		}
		
		
		
		if (collide("level", x + climbingPos, y) == null) {
			v.x += climbingPos;
			this.fsm.changeState(PlayerState.AIR);
		}
		if (Input.released(PInput.GRAB)) {
			this.fsm.changeState(PlayerState.AIR);
		}
		if (Input.pressed(PInput.JUMP)) {
			v.x = -climbingPos*2;
			v.y = -1;
			this.fsm.changeState(PlayerState.AIR);
		}
		
	}
	private function onClimbExit():Void {
		this.forcesPaused = false;
		img.flipY = false;  
	}
	
	private function isClimbing():Bool {
		var leftLevel = collide("level", x - 1, y);
		var rightLevel = collide("level", x + 1, y);
		
		var canClimbLeft = leftLevel != null && Std.is(leftLevel, Plant) && cast(leftLevel, Plant).climbable;
		var canClimbRight = rightLevel != null && Std.is(rightLevel, Plant) && cast(rightLevel, Plant).climbable;
		return  (canClimbLeft || canClimbRight) && Input.check(PInput.GRAB);
	}
	private function handleMovement() {
		 //this sorta weird setup  means that the player can still MOVE really fast (if propelled by external forces)
        //its just that he cant go super fast just by player input alone
		var inputForce = accel * inputVector.x;
		
        //force should be clamped so it doesnt let velocity extend past currentSpeed
        inputForce = MathUtil.clamp(inputForce + v.x, -this.speed, this.speed) - v.x;

        //basically making sure the adjusted force of the input doesn't act against the input itself
        if (MathUtil.sign(inputForce) == MathUtil.sign(inputVector.x)) v.x += inputForce;

        if (Math.abs(this.v.x) > this.speed) v.x *= 0.96;

        if (inputVector.x == 0) this.v.x *= friction;
		var dir = inputVector.normalize();
		img.flipX = dir.length > 0 ? dir.x > 0 : img.flipX;
		
	}
	
	override public function update():Void {
		
		fsm.update();
		
		this.gravity = v.y > 0 ? fallingGravity : risingGravity;
		inputVector.x = inputVector.y = 0;
		if (Input.check(PInput.LEFT)) inputVector.x = -1;
		if (Input.check(PInput.RIGHT)) inputVector.x = 1;
		
		
		super.update();
		
		
	}


}
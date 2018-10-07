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
	DEAD;
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
	public static inline var CLIMB_TIRED = "climb_tired";
	public static inline var CARRY_TIRED = "carry_tired";
	public static inline var DEAD = "dead";
	public static inline var GRAB = "grab";
}
class Player extends PhysicsObject {
	private var img:Spritemap = new Spritemap("graphics/player.png", 16, 16);
	private var groundFriction:Float = 0.85;
	private var airFriction:Float = 0.95;
	private var accel:Float = 0.5;
	
	private var speed:Float = 1;
	private var normalSpeed:Float = 1;
	private var carryingSpeed:Float = 0.4;
	private var pushingSpeed:Float = 0.6;
	private var jumpCount:Int = 0;
	private var jumpStrength:Float = 2;
	private var hoverTime:Float = 0.3;
	private var hoverCounter:Float = 0;
	private var hasJumped:Bool = false;
	
	public var risingGravity:Float = 0.1;
	public var fallingGravity:Float = 0.15;
	
	private var fsm:StateMachine<PlayerState>;
	private var addedVelocity:Bool = false;
	public var inputVector:Vector2 = new Vector2();
	public var carrying:Carryable;
	private var carryOriginalX:Float = 0;
	
	private var climbing:Entity;
	private var climbingPos:Float;
	
	public var waterLeft:Int = 6;
	public var waterMax:Int = 6;
	
	public var stamina:Float = 3;
	public var staminaMax:Float = 3;
	public var staminaShowPeriod:Float = 1;
	private var staminaRefreshDelay:Float = 0.2;
	private var staminaRefreshCounter:Float = 0;
	
	private var resetWait:Float = 1;
	private var resetTimer:Float = 0;
	
	private var deathCheated:Bool = false;
	
	private var flipLock:Bool = false;
	
	private var usedWingForce:Bool = false;
	
	public function new() {
		super(0, 0, new Graphiclist([img]));
		
		
		
		fsm = new StateMachine(PlayerState);
		
		
		fsm.bind(PlayerState.GROUND, this.onGroundEnter, this.onGroundUpdate, this.onGroundExit);
		fsm.bind(PlayerState.AIR, this.onAirEnter, this.onAirUpdate, this.onAirExit);
		fsm.bind(PlayerState.CARRYING, this.onCarryEnter, this.onCarryUpdate, this.onCarryExit);
		fsm.bind(PlayerState.CLIMBING, this.onClimbEnter, this.onClimbUpdate, this.onClimbExit);
		fsm.bind(PlayerState.DEAD, onDeadEnter, onDeadUpdate);
		setHitbox(20, 16);
		
		fsm.changeState(PlayerState.GROUND);
		
		
		Input.define(PInput.LEFT, [Key.LEFT, Key.A]);
		Input.define(PInput.RIGHT, [Key.RIGHT, Key.D]);
		Input.define(PInput.UP, [Key.UP, Key.W]);
		Input.define(PInput.DOWN, [Key.DOWN, Key.S]);
		Input.define(PInput.JUMP, [Key.SPACE]);
		
		Input.define(PInput.GRAB, [Key.Z, Key.SHIFT, Key.R]);
		Input.define(PInput.SHOOT, [Key.E, Key.X]);
		
		img.add(PAnim.WALK, [0], 15, true);
		img.add(PAnim.IDLE, [0]);
		img.add(PAnim.JUMP, [1]);
		img.add(PAnim.CLIMB, [2]);
		img.add(PAnim.CARRY_TIRED, [3]);
		img.add(PAnim.CLIMB_TIRED, [4]);
		img.add(PAnim.DEAD, [5]);
		img.add(PAnim.GRAB, [6]);
		
		
		
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
		setHitbox(12, 14, -3, -2);
		staminaRefreshCounter = 0;

			
	}
	
	private function onGroundUpdate():Void {
		
		staminaRefreshCounter += HXP.elapsed;
		if (staminaRefreshCounter > staminaRefreshDelay && !Input.check(PInput.GRAB)) {
			stamina = staminaMax;
		}
		
		if (Input.pressed(PInput.JUMP)) {
			v.y = -jumpStrength;
		}
		
		if (Input.pressed(PInput.SHOOT) && waterLeft > 0) {
			var bullet = new WaterBullet(x + (img.flipped ? 13 : -2), y + 7, img.flipped ? new Vector2(4, 0) : new Vector2( -4, 0));
			scene.add(bullet);
			waterLeft--;
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
			
			if (left != null || right != null || bottom != null) this.speed = this.pushingSpeed;
			
			
			if (left != null && Std.is(left, Carryable)) {
				this.carrying = cast(left, Carryable);
				this.img.play(PAnim.GRAB);
				this.flipLock = true;
			}
			else if (right != null && Std.is(right, Carryable)) {
				this.carrying = cast(right, Carryable);
				this.img.play(PAnim.GRAB);
				this.flipLock = true;
			}
			else if (bottom != null && Std.is(bottom, Carryable) && stamina == staminaMax) {
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
		else {
			flipLock = false;
		}
	}
	private function onGroundExit():Void {
		this.flipLock = false;
	}
	
	private function onAirEnter():Void {
		this.friction = airFriction;
		this.speed = this.normalSpeed;
		setHitbox(12, 12, -3, -4);
	}
	private function onAirUpdate():Void {
		
		this.gravity = v.y > 0 ? fallingGravity : risingGravity;
		
		img.play("jump");
		
		if (collide("level", x, y+1) != null) {
			fsm.changeState(PlayerState.GROUND);
		}	
		if (Input.pressed(PInput.JUMP) && hasJumped) {
			v.y = 0;
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
		
		this.gravity = fallingGravity;
		
		this.speed = carryingSpeed;
		
		setHitbox(20, 12, 2, -4);
		
		
		this.x = this.carrying.x + carrying.width / 2 - this.width / 2;
		
		
		if (Std.is(carrying, Seed)) {
			this.x += 4; // to match seed offset
		}
		
		this.v.y = this.carrying.v.y = -this.gravity-1;
		this.carrying.y = this.y + this.height;
		
	}
	private function onCarryUpdate():Void {
		handleMovement();
		
		if (v.y > -gravity && !usedWingForce) v.y = -gravity;
		
		if (carrying.collide("level", carrying.x + MathUtil.sign(v.x), carrying.y) != null) {
			carrying.v.x = 0;
		}
		else {
			carrying.v.x = this.v.x;
		}
		
		this.v.x = this.carrying.v.x;
		
		
		
		if (Input.check(PInput.JUMP)) {
			usedWingForce = true;
			v.y -= 0.16;
			stamina -= 0.05;
		}
		
		this.carrying.v.y = this.v.y;
		
		if (!Input.check(PInput.GRAB)) {
			fsm.changeState(PlayerState.AIR);
		}
		
		if (stamina > staminaShowPeriod) {
			img.play(PAnim.JUMP);
		}
		else {
			img.play(PAnim.CARRY_TIRED);
		}
		
		if (stamina < 0) {
			fsm.changeState(PlayerState.AIR);
		}
		
		

	}
	private function onCarryExit():Void {
		usedWingForce = false;
		carrying.forcesPaused = false;
		carrying.y += 2;
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
			setHitbox(12, 16, -4, 0);
		}
		else {
			setHitbox(12, 16);
		}
		
		if (climbingPos == 1) {
			this.x = climbing.x - this.width + this.originX;
		}
		else {
			this.x = climbing.x + climbing.width + this.originX;
		}
		
		
		
		
	}
	private function onClimbUpdate():Void {
		
		if (stamina > staminaShowPeriod) {
			img.play(PAnim.CLIMB);
		}
		else {
			img.play(PAnim.CLIMB_TIRED);
		}
		
		if (stamina < 0) fsm.changeState(PlayerState.AIR);
		
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
	
	private function onDeadEnter():Void {
		img.play(PAnim.DEAD);
		resetTimer = 0;
		this.collisionsPaused = true;
		this.type = "";
	}
	private function onDeadUpdate():Void {
		resetTimer += HXP.elapsed;
		if (resetTimer > resetWait) {
			cast(this.scene, GameScene).reset();
		}
	}
	private function isClimbing():Bool {
		var leftLevel = collide("level", x - 1, y);
		var rightLevel = collide("level", x + 1, y);
		
		var canClimbLeft = leftLevel != null && Std.is(leftLevel, Plant) && cast(leftLevel, Plant).climbable;
		var canClimbRight = rightLevel != null && Std.is(rightLevel, Plant) && cast(rightLevel, Plant).climbable;
		return  (canClimbLeft || canClimbRight) && Input.check(PInput.GRAB) && stamina == staminaMax;
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
		if (!flipLock) {
			img.flipX = dir.length > 0 ? dir.x > 0 : img.flipX;
		}
		
	}
	
	override public function update():Void {
		
		fsm.update();
		
		if (fsm.currentState == PlayerState.CARRYING || fsm.currentState == PlayerState.CLIMBING) {
			stamina -= HXP.elapsed;
		}
		
		
		inputVector.x = inputVector.y = 0;
		if (Input.check(PInput.LEFT)) inputVector.x = -1;
		if (Input.check(PInput.RIGHT)) inputVector.x = 1;
		
		var water = collide("water", x, y);
		if (water != null && !Std.is(water, WaterBullet) && Std.is(water, IWater)) {
			waterLeft++;
			if (waterLeft > waterMax) waterLeft = waterMax;
			cast(water, IWater).consume();
		}
		
		
		
		if (collide("level", x, y - 1) != null && collide("level", x, y + 1) != null && fsm.currentState != PlayerState.DEAD && !deathCheated) {
			 fsm.changeState(PlayerState.DEAD);
		 }
		 else {
			 deathCheated = true;
		 }
		 
		 if (collide("flag", x, y) != null && fsm.currentState != PlayerState.DEAD) {
			 cast(scene, GameScene).completeLevel();
		 }
		 
		 super.update();
	}

	
}
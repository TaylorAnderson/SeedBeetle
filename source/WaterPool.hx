package;

import haxepunk.Camera;
import haxepunk.Entity;
import haxepunk.Graphic;
import haxepunk.HXP;
import haxepunk.Mask;
import haxepunk.graphics.Image;
import haxepunk.graphics.Spritemap;
import haxepunk.graphics.shader.TextureShader;
import haxepunk.math.Vector2;
import haxepunk.utils.Color;
import haxepunk.utils.Draw;

/**
 * ...
 * @author Taylor
 */

typedef WavePoint = {
	x:Float,
	y:Float,
	spd:Vector2,
	mass:Float
}
class WaterPool extends Entity implements IWater {
	public var isContinuous:Bool;
	public var img:Image;
	
	
	
	// Resolution of simulation
	var NUM_POINTS = 80;
	// Width of simulation
	var WIDTH = 600;
	// Spring constant for forces applied by adjacent points
	var SPRING_CONSTANT = 0.005;
	// Sprint constant for force applied to baseline
	var SPRING_CONSTANT_BASELINE = 0.005;
	// Vertical draw offset of simulation
	var Y_OFFSET = 5;
	// Damping to apply to speed changes
	var  DAMPING = 0.99;
	// Number of iterations of point-influences-point to do on wave per step
	// (this makes the waves animate faster)
	var ITERATIONS = 20;
	
	// A phase difference to apply to each sine
	var offset = 0;

	var NUM_BACKGROUND_WAVES = 7;
	var BACKGROUND_WAVE_MAX_HEIGHT = 6;
	var BACKGROUND_WAVE_COMPRESSION = 1 / 10;
	
		// Amounts by which a particular sine is offset
	var sineOffsets = [];
	// Amounts by which a particular sine is amplified
	var sineAmplitudes = [];
	// Amounts by which a particular sine is stretched
	var sineStretches = [];
	// Amounts by which a particular sine's offset is multiplied
	var offsetStretches = [];
	// Set each sine's values to a reasonable random value
	var tableContent = "";
	
	var wavePoints:Array<WavePoint>;
	
	private var canSplash:Bool = true;
	
	public function new(x:Float = 0, y:Float = 0, width:Int = 0, height:Int = 0) {
		
		super(x, y, graphic, mask);
		
		this.setHitbox(width, height);
		WIDTH = width;
		for (i in 0...NUM_BACKGROUND_WAVES) {
			var sineOffset = -Math.PI + 2 * Math.PI * Math.random();
			sineOffsets.push(sineOffset);
			var sineAmplitude = Math.random() * BACKGROUND_WAVE_MAX_HEIGHT;
			sineAmplitudes.push(sineAmplitude);
			var sineStretch = Math.random() * BACKGROUND_WAVE_COMPRESSION;
			sineStretches.push(sineStretch);
			var offsetStretch = Math.random() * BACKGROUND_WAVE_COMPRESSION;
			offsetStretches.push(offsetStretch);
		}
		
		

		//this.img = Image.createRect(width, height, 0x3cacff, 0.5);
		
		//this.graphic = img;
		
		wavePoints = makeWavePoints(NUM_POINTS);
		
		this.layer = -20;
		
		this.update();
	}
	
	public function consume():Void {
		
	}
	
	override public function update():Void {
		offset++;
		// Update positions of points
		//updateWavePoints(wavePoints);
		
		var collided = collide("level", x, y);
		if (collided != null && canSplash) {
			//canSplash = false;
			this.splash(collided.x - this.x);
		}
	}
	
	override public function render(camera:Camera):Void {
		super.render(camera);
		

		
		Draw.setColor(0x3cacff, 0.5);
		
		for (n in 0...wavePoints.length) {
			var p = wavePoints[n];  
			var px = this.x - camera.x + p.x;
			var py = this.y - camera.y + (p.y + overlapSines(p.x));
			Draw.rectFilled(px, py, WIDTH / NUM_POINTS, this.height- (py - this.y));
		}
	}
	
	// Make points to go on the wave
	function makeWavePoints(numPoints) {
		var t = [];
		for (n in 0...numPoints) {
			// This represents a point on the wave
			var newPoint:WavePoint = {
				x: n / numPoints * WIDTH,
				y: Y_OFFSET,
				spd: new Vector2(0, 0), // speed with vertical component zero
				mass: 1
			}
			t.push(newPoint);
		}
		return t;
	}
	
	// This function sums together the sines generated above,
	// given an input value x
	function overlapSines(x:Float) {
		var result:Float = 0;
		for (i in 0...NUM_BACKGROUND_WAVES) {
			result += sineOffsets[i] + sineAmplitudes[i] * Math.sin(x * sineStretches[i] + offset * offsetStretches[i]);
		}
		return result;
	}
	
	// Update the positions of each wave point
	function updateWavePoints(points:Array<WavePoint>) {
		for (i in 0...ITERATIONS) {
			for (n in 0...points.length) {
				var p = points[n];
				// force to apply to this point
				var force:Float = 0;

				// forces caused by the point immediately to the left or the right
				var forceFromLeft:Float = 0; 
				var forceFromRight:Float = 0;

				if (n == 0) { // wrap to left-to-right
					forceFromLeft = SPRING_CONSTANT * SPRING_CONSTANT_BASELINE;
				} else { // normally
					var dy = points[n - 1].y - p.y;
					forceFromLeft = SPRING_CONSTANT * dy;
				}
				if (n == points.length - 1) { // wrap to right-to-left
					
					forceFromRight = SPRING_CONSTANT * SPRING_CONSTANT_BASELINE;
				} else { // normally
					var dy = points[n + 1].y - p.y;
					forceFromRight = SPRING_CONSTANT * dy;
				}

				// Also apply force toward the baseline
				var dy = Y_OFFSET - p.y;
				var forceToBaseline = SPRING_CONSTANT_BASELINE * dy;

				// Sum up forces
				force = force + forceFromLeft;
				force = force + forceFromRight;
				force = force + forceToBaseline;

				// Calculate acceleration
				var acceleration = force / p.mass;
		 

				// Apply speed
				p.y += DAMPING * p.spd.y + acceleration;
			}
		}
	}

	function splash(x:Float) {
		var closestPoint:WavePoint = null;
		var closestDistance:Float = -1;
		for (n in 0...wavePoints.length) {
			var p = wavePoints[n];
			var distance = Math.abs(x - p.x);
			if (closestDistance == -1) {
			  closestPoint = p;
			  closestDistance = distance;
			} else if (distance <= closestDistance) {
			  closestPoint = p;
			  closestDistance = distance;
			}
		 
		}
		if (closestPoint != null) {
			closestPoint.y = closestPoint.y + 20;  
		}
		
		
	}
}


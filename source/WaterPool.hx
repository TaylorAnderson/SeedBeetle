package;

import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;
import haxepunk.Camera;
import haxepunk.Entity;
import haxepunk.Graphic;
import haxepunk.HXP;
import haxepunk.Mask;
import haxepunk.graphics.Image;
import haxepunk.graphics.Spritemap;
import haxepunk.graphics.shader.TextureShader;
import haxepunk.masks.Polygon;
import haxepunk.math.Vector2;
import haxepunk.utils.Color;
import haxepunk.utils.Draw;
import openfl.display.BitmapData;
import openfl.display.Sprite;

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
	
	
	
	// Resolution of simulation
	var NUM_POINTS = 40;
	// Width of simulation
	var WIDTH = 0;
	// Spring constant for forces applied by adjacent points
	var SPRING_CONSTANT = 0.005;
	// Sprint constant for force applied to baseline
	var SPRING_CONSTANT_BASELINE = 0.001;
	// Vertical draw offset of simulation
	var Y_OFFSET = 3;
	// Damping to apply to speed changes
	var  DAMPING = 0.99;
	// Number of iterations of point-influences-point to do on wave per step
	// (this makes the waves animate faster)
	var ITERATIONS = 5;
	
	// A phase difference to apply to each sine
	var offset = 0;

	var NUM_BACKGROUND_WAVES = 20;
	var BACKGROUND_WAVE_MAX_HEIGHT = 1;
	var BACKGROUND_WAVE_COMPRESSION = 1 / 7;
	
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
	
	var spr:Sprite = new Sprite();
	
	var img:Image;
	
	var data:BitmapData;
	public function new(x:Float = 0, y:Float = 0, width:Int = 0, height:Int = 0) {
		
		super(x, y);
		
		this.data = new BitmapData(width, height, true, 0x00000000);
		data.draw(spr);
		
		img = new Image(data);
		this.graphic = img;
		
		
		
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
		
		this.layer = Layers.BG - 2;
		
		this.update();
	}
	
	public function consume():Void {
		
	}
	
	override public function update():Void {

	}
	
	override public function render(camera:Camera):Void {
		super.render(camera);
		
		offset++;
		// Update positions of points
		updateWavePoints(wavePoints);
		
		
		var adjustX = 0;
		var adjustY = 0;
		var g = spr.graphics;
		
		g.clear();
		g.beginFill(0x3cacff, 0.5);
		g.moveTo(0, height);
		for (n in 0...wavePoints.length) {
			var p = wavePoints[n];  
			var px = adjustX + p.x;
			var py = adjustY + p.y + overlapSines(p.x);
			g.lineTo(px, py);
		}
		g.lineTo(width, height);
		g.lineTo(0, height);
		g.endFill();
		data.fillRect(new Rectangle(0, 0, data.width, data.height), 0x00000000);
		data.draw(spr);
		
		
		
		
		
		
		
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

				if (n == 0) { // end left
					forceFromLeft = SPRING_CONSTANT * SPRING_CONSTANT_BASELINE;
				} else { // normally
					var dy = points[n - 1].y - p.y;
					forceFromLeft = SPRING_CONSTANT * dy;
				}
				if (n == points.length - 1) { // end right
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

	function onDrop() {
		/*
		var closestPoint = {};
		var closestDistance = -1;
		for (n in 0...wavePoints.length) {
			var p = wavePoints[n];
			var distance = Math.abs(pjs.mouseX - p.x);
			if (closestDistance == -1) {
			  closestPoint = p;
			  closestDistance = distance;
			} else if (distance <= closestDistance) {
			  closestPoint = p;
			  closestDistance = distance;
			}
		 
		}
		closestPoint.y = pjs.mouseY;
		*/
	}
}


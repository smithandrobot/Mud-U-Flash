package com.smithandrobot.mud_u
{

	import flash.display.*;
	import flash.filters.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.Point;
	
	import com.greensock.*;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	
	import com.smithandrobot.utils.*;
	
	public class MudUChart extends Sprite 
	{
		
		private var _data;
		
		private var _deerBlinkTimer :Timer;
		private var _deerFlickerLeftTimer :Timer;
		private var _deerFlickerRightTimer :Timer;
		private var _deerRotateTimer :Timer;
		
		private var _sasplotchBlinkTimer :Timer;
		private var _sasplotchEyeMoverTimer : Timer;
		private var _sasplotchRotateTimer : Timer;
		
		private var _bearBlinkTimer :Timer;
		private var _bearRotateTimer : Timer;
		
		private var _squirrelBlinkTimer :Timer;
		private var _squirrelWinceTimer :Timer;
		private var _squirrelTailTimer :Timer;
		private var _squirrelRotateTimer : Timer;
		
		private var _eyeMoverTimer : Timer;
		private var _points : Array;
		private var _perlin : BitmapData;
		private var _seed: Number;
		private var _filter : Array;
		
		public function MudUChart()
		{
			bearBar.scaleY 		= 0;
			deerBar.scaleY 		= 0;
			squirrelBar.scaleY 	= 0;
			sasplotchBar.scaleY = 0;
			
			_deerBlinkTimer = new Timer(RobotMath.randRange(1000, 3000), 1);
			_deerBlinkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, deerBlink);
			_deerBlinkTimer.start();
			
			_deerFlickerRightTimer = new Timer(RobotMath.randRange(1000, 3000), 1);
			_deerFlickerRightTimer.addEventListener(TimerEvent.TIMER_COMPLETE, deerFlickerRight);
			_deerFlickerRightTimer.start();
			
			_deerFlickerLeftTimer = new Timer(RobotMath.randRange(1000, 3000), 1);
			_deerFlickerLeftTimer.addEventListener(TimerEvent.TIMER_COMPLETE, deerFlickerLeft);
			_deerFlickerLeftTimer.start();
			
			_deerRotateTimer = new Timer(RobotMath.randRange(2000, 3000), 1);
			_deerRotateTimer.addEventListener(TimerEvent.TIMER_COMPLETE, deerRotate);
			_deerRotateTimer.start();
			
			_sasplotchBlinkTimer = new Timer(RobotMath.randRange(1000, 3000), 1);
			_sasplotchBlinkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, sasplotchBlink);
			_sasplotchBlinkTimer.start();
			
			_sasplotchEyeMoverTimer = new Timer(RobotMath.randRange(1000, 3000), 1);
			_sasplotchEyeMoverTimer.addEventListener(TimerEvent.TIMER_COMPLETE, sasplotchMoveEyes);
			_sasplotchEyeMoverTimer.start();
			
			_sasplotchRotateTimer = new Timer(RobotMath.randRange(1000, 3000), 1);
			_sasplotchRotateTimer.addEventListener(TimerEvent.TIMER_COMPLETE, sasplotchRotate);
			_sasplotchRotateTimer.start();
			
			_bearBlinkTimer = new Timer(RobotMath.randRange(1000, 3000), 1);
			_bearBlinkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, bearBlink);
			_bearBlinkTimer.start();
			
			_bearRotateTimer = new Timer(RobotMath.randRange(1000, 3000), 1);
			_bearRotateTimer.addEventListener(TimerEvent.TIMER_COMPLETE, bearRotate);
			_bearRotateTimer.start();
			
			_squirrelBlinkTimer = new Timer(RobotMath.randRange(1000, 3000), 1);
			
			_squirrelWinceTimer = new Timer(RobotMath.randRange(3000, 5000), 1);
			_squirrelWinceTimer.addEventListener(TimerEvent.TIMER_COMPLETE, squirrelWince);
			_squirrelWinceTimer.start();
			
			_squirrelTailTimer = new Timer(RobotMath.randRange(1000, 3000), 1);
			_squirrelTailTimer.addEventListener(TimerEvent.TIMER_COMPLETE, shakeTail);
			_squirrelTailTimer.start();
			
			_squirrelRotateTimer = new Timer(RobotMath.randRange(1000, 3000), 1);
			_squirrelRotateTimer.addEventListener(TimerEvent.TIMER_COMPLETE, squirrelRotate);
			_squirrelRotateTimer.start();
			
			_eyeMoverTimer = new Timer(RobotMath.randRange(1000, 3000), 1);
			_eyeMoverTimer.addEventListener(TimerEvent.TIMER_COMPLETE, moveSquirrelEyes);
			_eyeMoverTimer.start();
			
			_seed = RobotMath.randRange(100, 200);
			_points = new Array();
			_points.push( new Point());
			_points.push( new Point());
			_perlin = new BitmapData(285, 115, false, 0x999999);
			_perlin.perlinNoise(280, 103, 6, _seed, true, false, 7, true, _points);
			
			_filter = new Array();
			
			/*var b = addChild(new Bitmap(_perlin));
			b.alpha = .2;*/
			addEventListener(Event.ENTER_FRAME, loop);
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function onAdded(e:Event) : void
		{
			introAnimation();
		}
		
		private function loop(e:Event = null) : void
		{
			_points[0].x += 10;
			/*_points[1].x += 6;*/
			_perlin.perlinNoise(280, 103, 1, _seed, true, true, 7, true, _points);
			_filter[0] = getBitmapFilter();
			ribbon.filters = _filter;
			
		}
		
		
		private function deerBlink(e) : void
		{
			deerP.head.eye.gotoAndPlay("blink");
			_deerBlinkTimer.reset();
			_deerBlinkTimer.delay = RobotMath.randRange(1000, 3000);
			_deerBlinkTimer.start()
		}
		
		
		private function deerFlickerRight(e) : void
		{
			deerP.head.earRight.gotoAndPlay("flicker");
			_deerFlickerRightTimer.reset();
			_deerFlickerRightTimer.delay = RobotMath.randRange(1000, 3000);
			_deerFlickerRightTimer.start()
		}
		
		private function deerFlickerLeft(e) : void
		{
			deerP.head.earLeft.gotoAndPlay("flicker");
			_deerFlickerLeftTimer.reset();
			_deerFlickerLeftTimer.delay = RobotMath.randRange(1000, 3000);
			_deerFlickerLeftTimer.start()
		}
		
		
		private function deerRotate(e) : void
		{
			deerP.head.scaleX *= getDir();
			var r = RobotMath.randRange(0, 20);
			if(deerP.head.scaleX<0) r*=-1;
			TweenMax.to(deerP.head, .2, {rotation:r});
			_deerRotateTimer.reset();
			_deerRotateTimer.delay = RobotMath.randRange(2000, 3000);
			_deerRotateTimer.start()
		}
		
		
		private function bearBlink(e) : void
		{
			bearP.head.eyes.gotoAndPlay("blink");
			_bearBlinkTimer.reset();
			_bearBlinkTimer.delay = RobotMath.randRange(1000, 3000);
			_bearBlinkTimer.start()
		}
		
		
		private function bearRotate(e) : void
		{
			bearP.head.scaleX  *= getDir();
			var r = RobotMath.randRange(0, 20);
			if(bearP.head.scaleX<0) r*=-1;
			TweenMax.to(bearP.head, .2, {rotation:r});
			_bearRotateTimer.reset();
			_bearRotateTimer.delay = RobotMath.randRange(2000, 3000);
			_bearRotateTimer.start()
		}
		
		
		private function moveSquirrelEyes(e:TimerEvent = null) : void
		{
			var space = 28;
			var left = RobotMath.randRange(-16, -13);
			TweenMax.to(squirrelP.body.eyes.eyeLeft, .1, {x:left});
			TweenMax.to(squirrelP.body.eyes.eyeRight, .1, {x:left+space});
			
			_eyeMoverTimer.reset();
			_eyeMoverTimer.delay = RobotMath.randRange(1000, 3000);
			_eyeMoverTimer.start()
		}
		
		
		private function squirrelRotate(e) : void
		{
			var r = RobotMath.randRange(0, 20);
			TweenMax.to(squirrelP.body, .2, {rotation:r});
			_squirrelRotateTimer.reset();
			_squirrelRotateTimer.delay = RobotMath.randRange(2000, 3000);
			_squirrelRotateTimer.start()
		}
		
		
		private function squirrelWince(e:TimerEvent = null) : void
		{
			squirrelP.body.nose.gotoAndPlay("wince");
			_squirrelWinceTimer.reset();
			_squirrelWinceTimer.delay = RobotMath.randRange(3000, 5000);
			_squirrelWinceTimer.start()
		}
		
		private function shakeTail(e:TimerEvent = null) : void
		{
			squirrelP.body.tail.gotoAndPlay("shake");
			squirrelP.body.tail.filters = [new BlurFilter(15,0)];
			_squirrelTailTimer.reset();
			_squirrelTailTimer.delay = RobotMath.randRange(3000, 5000);
			_squirrelTailTimer.start()
		}
		
		
		private function sasplotchBlink(e:TimerEvent = null) : void
		{
			sasplotchP.head.eyes.eyeLeft.gotoAndPlay("blink");
			sasplotchP.head.eyes.eyeRight.gotoAndPlay("blink");
			_sasplotchBlinkTimer.reset();
			_sasplotchBlinkTimer.delay = RobotMath.randRange(1000, 3000);
			_sasplotchBlinkTimer.start()
		}
		
		
		private function sasplotchMoveEyes(e:TimerEvent = null) : void
		{
			var space = 24;
			var left = RobotMath.randRange(-14, -10);
			TweenMax.to(sasplotchP.head.eyes.eyeLeft, .1, {x:left});
			TweenMax.to(sasplotchP.head.eyes.eyeRight, .1, {x:left+space});
			
			_sasplotchEyeMoverTimer.reset();
			_sasplotchEyeMoverTimer.delay = RobotMath.randRange(1000, 3000);
			_sasplotchEyeMoverTimer.start()
		}
		
		
		private function sasplotchRotate(e) : void
		{
			var r = RobotMath.randRange(-25, 25);
			TweenMax.to(sasplotchP.head, .2, {rotation:r});
			_sasplotchRotateTimer.reset();
			_sasplotchRotateTimer.delay = RobotMath.randRange(2000, 3000);
			_sasplotchRotateTimer.start()
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function introAnimation() : void
		{
			TweenMax.from(bkg, .25, {scaleX:.3, scaleY:.3, ease:Back.easeOut});
			TweenMax.allFrom([bearP, deerP, squirrelP, sasplotchP], .2, {delay:.2, alpha:0, scaleX:.3, scaleY:.3, ease:Back.easeOut}, .08);
			TweenMax.from(ribbon, .2, {delay:.4, x:"-5", alpha:0});
			TweenMax.from(headline, .2, {delay:.5, y:"+5", alpha:0, onComplete:getData});
		}
		
		
		private function getData() : void
		{
			var data;
			
			if( loaderInfo.parameters.mudpie )
			{
				data = null;
			}else{
				data = {mudpie:1000, buck_wild:200, squirrel:50, sasplotch:2};	
			}
			
			_data = data;
			handleData(_data)
		}
		
		private function getMostMuds(obj) : Number
		{
			var most = 0;
			var i;
			
			for(i in obj)
			{
				if(obj[i] > most) most = obj[i];
			}
			
			return most;
		}
		
		private function handleData(obj) : void
		{
			var i = 0;
			var highest = getMostMuds(obj);
			var bar;
			var delay = .08;
			var iterator = 0;
			var scale  = 0
			var min = .6;
			var h;
			
			var bars = [
					  	{bar:bearBar, data:obj.mudpie}, 
					  	{bar:deerBar, data:obj.buck_wild},
					  	{bar:squirrelBar, data:obj.squirrel}, 
					  	{bar:sasplotchBar, data:obj.sasplotch}
					  ];
			var total = bars.length-1;
			var minHeight = 148*min;
			var remainder = 148*(1-min);
			
			for(i; i<=total; i++)
			{
				bar = bars[i];
				scale = bar.data/highest;
				//scale = min;
				h = minHeight+(remainder*scale);
				trace("scale: "+scale+" h: "+h)
				TweenMax.to(bar.bar, .2 ,{delay:i*delay, height:h, ease:Back.easeOut});
			
			}
		}
		
		private function getDir() : Number
		{
			var dirs = [-1, 1];
			var dir = dirs[RobotMath.randRange(0, 1)];
			return dir;
		}
		
     private function getBitmapFilter():BitmapFilter {
            var mapPoint:Point       = new Point(0, 0);
            var channels:uint        = BitmapDataChannel.RED;
            var componentX:uint      = channels;
            var componentY:uint      = channels;
            var scaleX:Number        = 2;
            var scaleY:Number        = -15;
            var mode:String          = DisplacementMapFilterMode.CLAMP;
            var color:uint           = 0;
            var alpha:Number         = 0;
            return new DisplacementMapFilter(_perlin,
                                             mapPoint,
                                             componentX,
                                             componentY,
                                             scaleX,
                                             scaleY,
                                             mode,
                                             color,
                                             alpha);
        }

	}

}
package com.smithandrobot.mud_u.views.ui.characters 
{

	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.Point;
	import flash.filters.*;
	
	import com.greensock.*;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;

	import com.smithandrobot.utils.*;
	
	public class Squirrel extends Sprite 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		
		/**
		 *	@constructor
		 */
				
		private var _blinkTimer : Timer;
		private var _tailFlickerTimer : Timer;
		private var _eyeMoverTimer : Timer;
		private var _winceTimer : Timer;
		private var _wringHandsTimer : Timer;
		private var _tailTimer : Timer;
		
		public function Squirrel()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onDisplayChange);
			addEventListener(Event.REMOVED_FROM_STAGE, onDisplayChange);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function start() : void
		{			
			_blinkTimer = new Timer(RobotMath.randRange(100, 1000), 1);
			_blinkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, blink)
			_blinkTimer.start()
			
			_eyeMoverTimer = new Timer(RobotMath.randRange(100, 1000), 1);
			_eyeMoverTimer.addEventListener(TimerEvent.TIMER_COMPLETE, moveEyes)
			_eyeMoverTimer.start()
			
			_winceTimer = new Timer(RobotMath.randRange(100, 1000), 1);
			_winceTimer.addEventListener(TimerEvent.TIMER_COMPLETE, wince)
			_winceTimer.start()
			
			_tailFlickerTimer = new Timer(RobotMath.randRange(100, 1000), 1);
			_tailFlickerTimer.addEventListener(TimerEvent.TIMER_COMPLETE, leftFlicker)
			_tailFlickerTimer.start()
			
			_wringHandsTimer = new Timer(RobotMath.randRange(100, 1000), 1);
			_wringHandsTimer.addEventListener(TimerEvent.TIMER_COMPLETE, wringHands)
			_wringHandsTimer.start()
			
			_tailTimer = new Timer(RobotMath.randRange(100, 1000), 1);
			_tailTimer.addEventListener(TimerEvent.TIMER_COMPLETE, shakeTail)
			_tailTimer.start()
		}
		
		
		public function stop() : void
		{
			_blinkTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, blink)
			_blinkTimer.reset()
			
			_eyeMoverTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, moveEyes)
			_eyeMoverTimer.reset()
			
			_winceTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, wince)
			_winceTimer.reset()
			
			_tailFlickerTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, leftFlicker)
			_tailFlickerTimer.reset()
			
			_wringHandsTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, wringHands)
			_wringHandsTimer.reset()
			
			_tailTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, shakeTail)
			_tailTimer.reset()
		}

		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		private function onDisplayChange(e:Event) : void
		{
			if(e.type == Event.ADDED_TO_STAGE) start();
			if(e.type == Event.REMOVED_FROM_STAGE) stop();
		}
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		
		private function blink(e:TimerEvent = null) : void
		{
			eyes.eyeLeft.gotoAndPlay("blink");
			eyes.eyeRight.gotoAndPlay("blink");
			_blinkTimer = new Timer(RobotMath.randRange(1000, 3000), 1);
			_blinkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, blink)
			_blinkTimer.start()
		}
		
		private function leftFlicker(e:TimerEvent = null) : void
		{
			//head.earLeft.gotoAndPlay("flicker");
			_tailFlickerTimer = new Timer(RobotMath.randRange(100, 10000), 1);
			_tailFlickerTimer.addEventListener(TimerEvent.TIMER_COMPLETE, leftFlicker)
			_tailFlickerTimer.start()
		}
		
		
		private function moveEyes(e:TimerEvent = null) : void
		{
			var space = 28;
			var left = RobotMath.randRange(-16, -13);
			TweenMax.to(eyes.eyeLeft, .1, {x:left});
			TweenMax.to(eyes.eyeRight, .1, {x:left+space});
			
			_eyeMoverTimer.reset();
			_eyeMoverTimer.delay = RobotMath.randRange(1000, 3000);
			_eyeMoverTimer.start()
		}
		
		
		private function wince(e:TimerEvent = null) : void
		{
			nose.gotoAndPlay("wince");
			_winceTimer.reset();
			_winceTimer.delay = RobotMath.randRange(3000, 5000);
			_winceTimer.start()
		}
		
		
		private function wringHands(e:TimerEvent = null) : void
		{
			hands.gotoAndPlay("wringHands");
			_wringHandsTimer.reset();
			_wringHandsTimer.delay = RobotMath.randRange(3000, 5000);
			_wringHandsTimer.start()
		}
		
		
		private function shakeTail(e:TimerEvent = null) : void
		{
			tail.gotoAndPlay("shake");
			tail.filters = [new BlurFilter(15,0)];
			_tailTimer.reset();
			_tailTimer.delay = RobotMath.randRange(3000, 5000);
			_tailTimer.start()
		}

		
	}

}


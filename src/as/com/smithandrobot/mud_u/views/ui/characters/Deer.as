package com.smithandrobot.mud_u.views.ui.characters 
{

	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.Point;
	
	import com.greensock.*;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;

	import com.smithandrobot.utils.*;
	
	public class Deer extends MovieClip 
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
		private var _leftFlickerTimer : Timer;
		private var _rightFlickerTimer : Timer;
		private var _snapTimer : Timer;
		private var _gameMode : Boolean = false;
		
		public function Deer()
		{
			super();
			TweenPlugin.activate([ShortRotationPlugin]);
			
			addEventListener(Event.ADDED_TO_STAGE, onDisplayChange);
			addEventListener(Event.REMOVED_FROM_STAGE, onDisplayChange);
			
			stop();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		
		public function set gameMode(g:Boolean) : void 
		{ 
			_gameMode = g;
			if(_gameMode) _snapTimer.stop();
			if(!_gameMode) 
			{
				_snapTimer.reset();
				_snapTimer.start();
				
			}
		};
		
		public function get gameMode() : Boolean { return _gameMode; };
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function start() : void
		{			
			_blinkTimer = new Timer(RobotMath.randRange(1000, 3000), 1);
			_blinkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, blink)
			_blinkTimer.start()
			
			_leftFlickerTimer = new Timer(RobotMath.randRange(1000, 3000), 1);
			_leftFlickerTimer.addEventListener(TimerEvent.TIMER_COMPLETE, leftFlicker)
			_leftFlickerTimer.start()
			
			_rightFlickerTimer = new Timer(RobotMath.randRange(1000, 3000), 1);
			_rightFlickerTimer.addEventListener(TimerEvent.TIMER_COMPLETE, rightFlicker)
			_rightFlickerTimer.start()
			
			_snapTimer = new Timer(RobotMath.randRange(5000, 8000), 1);
			_snapTimer.addEventListener(TimerEvent.TIMER_COMPLETE, snapUnderwear);
			_snapTimer.start()
		}
		
		
		public function stopMvmnt() : void
		{			
			_blinkTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, blink)
			_blinkTimer.reset()
			
			_rightFlickerTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, rightFlicker)
			_rightFlickerTimer.reset()
			
			_leftFlickerTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, leftFlicker)
			_leftFlickerTimer.reset()
			
			_snapTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, snapUnderwear);
			_snapTimer.reset();
		}
		
		
		public function toggleUnderwear(state:String = "off") : void
		{
			if(state == "off") pullOff();
			if(state == "on") putOn();
		}
		
		
		public function snap() : void
		{
			gotoAndPlay("snap");
		}
		
		
		public function pullOff() : void
		{
			gotoAndPlay("pullOffUnderwear");			
		}
		
		
		public function putOn() : void
		{
			gotoAndPlay("putOnUnderwear");			
		}
		
		
		public function reset() : void
		{
			gotoAndStop(1);
		}
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		private function onDisplayChange(e:Event) : void
		{
			if(e.type == Event.ADDED_TO_STAGE) start();
			if(e.type == Event.REMOVED_FROM_STAGE) stopMvmnt();
		}
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		
		private function blink(e:TimerEvent = null) : void
		{
			head.eye.gotoAndPlay("blink");
			_blinkTimer.reset();
			_blinkTimer.start()
		}
		
		private function leftFlicker(e:TimerEvent = null) : void
		{
			head.earLeft.gotoAndPlay("flicker");
			_leftFlickerTimer.reset();
			_leftFlickerTimer.start()
		}
		
		private function rightFlicker(e:TimerEvent = null) : void
		{
			head.earRight.gotoAndPlay("flicker");
			_rightFlickerTimer.reset()
			_rightFlickerTimer.start()
		}
		
		
		private function snapUnderwear(e:TimerEvent = null) : void
		{
			if(_gameMode) return;
			
			gotoAndPlay("snap");
			_snapTimer.reset();
			_snapTimer.start();
		}
		
	}

}


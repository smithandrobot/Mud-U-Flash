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
	
	public class Frog extends Sprite 
	{
		
		private var _angle : Number = 0;
		private var _speed : Number = .25;
		private var _breathTimer : Timer;		
		private var _blinkTimer : Timer;
		private var _pupilTimer : Timer;
				
		public function Frog()
		{
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
			_breathTimer = new Timer(100, 0);
			_breathTimer.addEventListener(TimerEvent.TIMER, breath);
			_breathTimer.start();
			
			_blinkTimer = new Timer(RobotMath.randRange(100, 1000), 1);
			_blinkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, blink)
			_blinkTimer.start();
			
			_pupilTimer = new Timer(RobotMath.randRange(100, 1000), 1);
			_pupilTimer.addEventListener(TimerEvent.TIMER_COMPLETE, movePupils)
			_pupilTimer.start();
		}
		
		
		public function stop() : void
		{
			_breathTimer.removeEventListener(TimerEvent.TIMER, breath);
			_breathTimer.reset();
			
			_blinkTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, blink);
			_blinkTimer.reset();
			
			_pupilTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, movePupils);
			_pupilTimer.reset();
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
		
		
		private function breath(event:TimerEvent):void 
		{
			body.scaleY=1+Math.sin(_angle)*.05;
			body.scaleX = body.scaleY;
			_angle+=_speed;
		}
		
		private function blink(e:TimerEvent = null) : void
		{
			eyes.gotoAndPlay("blink");
			_blinkTimer.reset();
			_blinkTimer.delay = RobotMath.randRange(1000, 3000);
			_blinkTimer.start();
		}
		
		
		private function movePupils(e:TimerEvent = null) : void
		{
			var destY = RobotMath.randRange(1, 5);
			var destX = RobotMath.randRange(1,9);
			
			TweenMax.to(eyes.pupils, .2, {y:destY,x:destX});
			
			_pupilTimer.reset();
			_pupilTimer.delay = RobotMath.randRange(1000, 3000);
			_pupilTimer.start()
		}
		
	}

}


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
	
	public class Bear extends Sprite 
	{
		
		private var _angle : Number = 0;
		private var _speed : Number = 15;
		private var _breathTimer : Timer;		
		private var _blinkTimer : Timer;
		private var _rspeed : Number = 0;
		private var _rMax : Number = -60;
		private var _bf : BlurFilter = new BlurFilter(0,0,1);
		
		public function Bear()
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
			rightArm.filter = [_bf];
			leftArm.filter = [_bf];
		}
		
		
		public function stop() : void
		{
			_breathTimer.removeEventListener(TimerEvent.TIMER, breath);
			_breathTimer.reset();
				
			_blinkTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, blink);
			_blinkTimer.reset();
		}
		
		
		public function toggleSpin(b:Boolean) : void
		{
			if(b) addEventListener(Event.ENTER_FRAME, onFrame);
			if(!b)
			{
				removeEventListener(Event.ENTER_FRAME, onFrame);
				TweenMax.to(leftArm,.2, {rotation:0});
				TweenMax.to(rightArm,.2, {rotation:0});
				_bf.blurX = 0;
				_bf.blurY = 0;
				_rspeed = 0;
				leftArm.filters = [_bf];
				rightArm.filters = [_bf];
			}
		}
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		private function onFrame(e:Event = null) : void
		{
			_rspeed 			= (_rspeed > _rMax) ? _rspeed-=2 : _rspeed;
			var bMax 			= 15;
			var bAmount 	  	= bMax * (_rspeed/_rMax);
			_bf.blurY 		  	= bAmount;
			_bf.blurX 		  	= bAmount;
			leftArm.filters   	= [_bf];
			rightArm.filters  	= [_bf];
			leftArm.rotation  	-= _rspeed;
			rightArm.rotation 	-= _rspeed;
		}
		
		
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
			_angle = (_angle > 360) ? 0 : _angle;
			var rad = _angle*(Math.PI/180);
			belly.scaleY=1+Math.sin(rad)*.009;
			belly.scaleX = belly.scaleY;
			head.y = (belly.y - belly.height)+3;
			_angle+=_speed;
			
		}
		
		
		private function blink(e:TimerEvent = null) : void
		{
			head.eyes.gotoAndPlay("blink");
			_blinkTimer.reset();
			_blinkTimer.delay = RobotMath.randRange(1000, 3000);
			_blinkTimer.start()
		}
		
	}

}


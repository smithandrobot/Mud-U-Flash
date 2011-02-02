package com.smithandrobot.mud_u.views.ui.characterpanels 
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
	
	public class SasplotchGame extends Sprite 
	{
		private var _squirrels : Array = new Array();
		private var _popUpTimer : Timer;
		private var _lastSquirrel;
		private var _stopped : Boolean = true;
		
		public function SasplotchGame()
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
			var t = RobotMath.randRange(200, 600);
			_popUpTimer = new Timer(t, 1);
			_popUpTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onPopUp);
			initSquirrels();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		
		public function start() : void
		{
			_popUpTimer.reset();
			_popUpTimer.delay = RobotMath.randRange(200, 600);
			_popUpTimer.start()
			_stopped = false;
		}
		
		public function stop() : void
		{
			_popUpTimer.stop();
			
			for(var i  in _squirrels)
			{
				close(_squirrels[i]);
			}
			
			_lastSquirrel = null;
			_stopped = true;
		}
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function close(s)
		{
			TweenMax.to(s.squirrel, .15, {y:54});
			if(s.alpha > 0) TweenMax.to(s, .2, {autoAlpha : 0});
		}
		
		
		private function open(s) : void
		{
			TweenMax.to(s, .2, {autoAlpha : 1});
			TweenMax.to(s.squirrel, .2, {y:0, ease:Back.easeOut, easeParama:[3]});
		}
		
		
		private function squirrelClicked(e:MouseEvent) : void
		{
			_popUpTimer.stop();
			onPopUp();
			dispatchEvent(new Event("onThrow", true));
		}
		
		
		private function onPopUp(e:TimerEvent = null) : void
		{
			if(_lastSquirrel) close(_lastSquirrel);
			
			var sIndex = RobotMath.randRange(0, _squirrels.length-1);
			var newSquirrel = _squirrels[sIndex];
			open(newSquirrel);
			_lastSquirrel = newSquirrel;
			
			_popUpTimer.reset();
			_popUpTimer.delay = RobotMath.randRange(1000, 2000);
			if(!_stopped)_popUpTimer.start();
		}
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		
		private function initSquirrels() : void
		{
			var total = numChildren-1;
			var i = 0;
			
			for (i; i<= total; i++)
			{
				_squirrels.push(getChildAt(i) as MovieClip);
				initBehavior(_squirrels[i]);
			}
		}
		
		private function initBehavior(s) : void
		{
			s.addEventListener(MouseEvent.CLICK, squirrelClicked);
			s.squirrel.y = 54;
			s.visible = false;
			s.alpha = 0;
		}
	}

}


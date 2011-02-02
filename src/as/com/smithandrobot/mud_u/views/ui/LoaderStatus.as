package com.smithandrobot.mud_u.views.ui
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	
	import com.greensock.*;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	
	import com.smithandrobot.utils.RobotMath;
	
	public class LoaderStatus extends Sprite 
	{
		private var _posArr 	: Array;
		protected var _scope 		: Sprite;
		private var _piece 		: MovieClip;
		private var _pace 		: Number;
		protected var _aniTimer	: Timer;
		protected var _bounceTimer: Timer;
		private var _onDisplay	: Boolean;
		private var _pos		: int;
		private var _center		: Point;
		private var _container	: MovieClip;
		
		public function LoaderStatus()
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
			
			_container	= getChildByName("container") as MovieClip;
			_piece		= _container.getChildByName("piece") as MovieClip;
			_posArr  	= new Array(-32, -22, -13, -4, 6, 15 ,24);
			_pace		= 100;
			_aniTimer 	= new Timer(_pace, 0);
			_onDisplay	= false;
			_pos		= 0;
			_bounceTimer= new Timer(5, 0);
            
			_bounceTimer.addEventListener(TimerEvent.TIMER, moveLoader);
			_aniTimer.addEventListener(TimerEvent.TIMER, animateGrill);
			
			_aniTimer.start();
			_bounceTimer.start();
			
			visible = false;
		}
		
		
		public function toggleVisible(show:Boolean = false, animate:Boolean = false) : void
		{
			var a = (show) ? 1 : 0;
			if(animate) TweenMax.to(this, .2, {autoAlpha:a});
			if(!animate) TweenMax.to(this, .001, {autoAlpha:a});
		}
		
		private function animateGrill(e:TimerEvent) : void
		{
			++_pos;
			_pos = (_pos > _posArr.length - 1) ? 0 : _pos;
			_piece.x = _posArr[_pos];
		}
		
		
		private function moveLoader(e:TimerEvent) : void
		{
			var xOff = 1;
			var yOff = 1;
			_container.x = RobotMath.randRange(- xOff, xOff );
			_container.y = RobotMath.randRange(- yOff, yOff );
			_container.rotation = RobotMath.randRange( -xOff, xOff );
		}
		
		
		public function stop() : void
		{
			_bounceTimer.removeEventListener(TimerEvent.TIMER, moveLoader);
			_aniTimer.removeEventListener(TimerEvent.TIMER, animateGrill);
		}
		
	}

}


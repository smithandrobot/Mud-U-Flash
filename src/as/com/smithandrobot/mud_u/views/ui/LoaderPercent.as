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
	
	import com.greensock.TweenMax;
	
	import com.smithandrobot.utils.RobotMath;
	
	public class LoaderPercent extends Sprite 
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
		
		public function LoaderPercent(scope)
		{
			_scope		= scope;
			_container	= getChildByName("container") as MovieClip;
			_piece		= _container.getChildByName("piece") as MovieClip;
			_posArr  	= new Array(-32, -22, -13, -4, 6, 15 ,24);
			_pace		= 100;
			_aniTimer 	= new Timer(_pace, 0);
			_onDisplay	= false;
			_pos		= 0;
			_bounceTimer= new Timer(5, 0);
            
			_bounceTimer.addEventListener(TimerEvent.TIMER, moveLoader);
			addEventListener(Event.ADDED_TO_STAGE, onDisplayListChange)
			addEventListener(Event.REMOVED_FROM_STAGE, onDisplayListChange);
			_container.getChildByName("grillMask").width = 0;
		}
		
		
		public function start()
		{
			if(!_onDisplay)
			{
				alpha = 0;
				_scope.addChild(this);
				TweenMax.to(this, .5, {alpha:1});
				_aniTimer.start();
				_bounceTimer.start();
			} 
		}
		
		
		public function close()
		{
			if(_onDisplay) 
			{
				TweenMax.to(_container, .55, {alpha:0, scaleX: 1.1, scaleY:1.1, onComplete:remove});
			}else{
				remove();
			}
		}
		
		
		public function set percent(p:Number) : void
		{
			var gMask = _container.getChildByName("grillMask");
			TweenMax.to(gMask, .2, {width: 64*p});
		}
		
		
		public function remove()
		{
			_bounceTimer.stop();
			if(this.parent) _scope.removeChild(this);	
			dispatchEvent(new Event("loaderRemoved"));
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
		
		
		private function onDisplayListChange(e:Event) : void
		{
			if(e.type == Event.ADDED_TO_STAGE) 		_onDisplay = true;
			if(e.type == Event.REMOVED_FROM_STAGE)	_onDisplay = false;
		}
		
	}

}


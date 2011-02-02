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
	import com.smithandrobot.mud_u.views.ui.characterpanels.*;
	
	public class DeerMudClot2 extends Sprite 
	{

		private var _xVelocity;
		private var _yVelocity;
		private var _z = 0;
		private var _frameZ = 25;
		private var _gravity = .9;
		private var _velocity = -50;
		private var _maxY : Number = 230;
		private var _maxX : Number = 215;
		private const GRAVITY	   :Number = 0.6;
		private const FRICTION	   :Number = 0.007;
		private const RUBBER_FORCE :Number = 0.2; // used to tone down the force applied to the ball, based on the pull applied to the elastic
		private var _rotationSpeed : int;
		private var _xTension : Number;
		private var _yTension : Number;
		
		private static var RADIAN_MULTIPLIER = (180 / Math.PI);
		public function DeerMudClot2()
		{
			y = -240;
			x = 170;
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		
		public function get clotZ() : Number { return _z; };

		public function set clotZ(i:Number) : void
		{
			_z = i;
			if(_z >= _frameZ )
			{
				initBehavior(false);
				dispatchEvent(new Event("onDeerMudImpact", true));
				parent.removeChild(this);
			}
		}
		
		
		public function set enable(b:Boolean) : void
		{
			initBehavior(b);
		}
		
		public function get xTension() : Number
		{
			return (isNaN(_xTension)) ? 0 : _xTension;
		}
		
		public function get yTension() : Number
		{
			return (isNaN(_yTension)) ? 0 : _yTension;
		}
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------

		
		private function onAdded(e:Event = null) : void
		{
			initBehavior(true);
			var func = function(){dispatchEvent(new Event("onClotPosChange", true));};
			TweenMax.from(this, .2, {scaleX:.1, scaleY:.1, x:"+50", onUpdate:func, ease:Back.easeOut, easeParams:[2.5]});
			dispatchEvent(new Event("onClotLoaded", true));
		}
		
		
		private function onMouseDown(e:MouseEvent) : void
		{
			startDrag();
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(Event.ENTER_FRAME, updatePos);
		}
		
		
		private function onMouseUp(e:MouseEvent) : void
		{
			initBehavior(false);
			//TweenMax.to(this, .65, { clotZ:_frameZ });
			var p = DeerPanel(parent).getClotDest(); 
			dispatchEvent(new Event("onDeerClotReleased", true));
			_rotationSpeed = RobotMath.randRange(3, 10);
			TweenMax.to(this, .2, { x:p.x, y:p.y, onComplete:impact});
			stopDrag();
			removeEventListener(Event.ENTER_FRAME, updatePos);
			//addEventListener(Event.ENTER_FRAME, slingMud);
			if(hasOwnProperty("stage")) stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		
		private function updatePos(e:Event = null) : void
		{
			var angle = getAngle();
			
			var distanceX : Number = x - parent.getChildByName("deer").x;
			var distanceY : Number = y - (-240);
			
			_xVelocity = (distanceX/_maxX) * _velocity;
			_yVelocity = (distanceY/_maxY) * _velocity;
			
			_xTension = 1- distanceX/_maxX;
			_yTension = 1- (distanceY/_maxY);
			
			if(_xTension < 0) _xTension = 0;
			if(_yTension < 0) _yTension = 0;
			
			if(_xTension > 1) _xTension = 1;
			if(_yTension > 1) _yTension = 1;
			
			dispatchEvent(new Event("onClotPosChange", true));
		}
		
		
		private function slingMud(e:Event = null)
		{
			x+=_xVelocity;
			y+=_yVelocity;
			rotation += _rotationSpeed;
			/*_xVelocity += FRICTION;
			_yVelocity += GRAVITY;*/

		}
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		
		private function initBehavior(b:Boolean) : void
		{
			if(b)
			{
				addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				if(hasOwnProperty("stage")) stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}else{
				removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				if(hasOwnProperty("stage")) stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
		}
		
		
		private function getAngle() : Number
		{
			var distanceX : Number = x - parent.getChildByName("deer").x;
			var distanceY : Number = y - (-240);
			var angleInRadians : Number = Math.atan2(distanceY, distanceX);
			var angleInDegrees : Number = angleInRadians * RADIAN_MULTIPLIER;
			return angleInRadians;
		} 
		
		
		private function impact() : void
		{
			initBehavior(false);
			dispatchEvent(new Event("onDeerMudImpact", true));
			parent.removeChild(this);    
		} 

	}

}


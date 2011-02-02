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
	
	public class DeerMudClot extends Sprite 
	{
		
		private var _velocity = 0;
		private var _angle = 0;
		private var _z = 0;
		private var _frameZ = 25;
		private static var RADIAN_MULTIPLIER:Number = 180 / Math.PI;
		
		public function DeerMudClot()
		{
			TweenPlugin.activate([Physics2DPlugin]);
			initBehavior(true);
			y = -240;
			x = 170;
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function set velocity(v:Number) : void
		{
			_velocity = v;
			stopDrag();
			TweenMax.to(this, 2.5, {physics2D:{velocity:_velocity, angle:_angle, gravity:500}, onUpdate: checkZ, onComplete: onComplete});
		}
		
		
		public function set angle(a:Number) : void
		{
			_angle = a;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function onAdded(e:Event) : void
		{
			var func = function(){dispatchEvent(new Event("onClotPosChange", true));};
			TweenMax.from(this, .2, {scaleX:.1, scaleY:.1, x:"+50", onUpdate:func, ease:Back.easeOut, easeParams:[2.5]});
			dispatchEvent(new Event("onClotPosChange", true));
		}
		
		
		private function onMouseDown(e:MouseEvent) : void
		{
			startDrag();
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(Event.ENTER_FRAME, updatePos);
		}
		
		
		private function onMouseUp(e:MouseEvent) : void
		{
			stopDrag();
			removeEventListener(Event.ENTER_FRAME, updatePos);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			initBehavior(false);

			TweenMax.to(this, 2.5, {physics2D:{velocity:_velocity, angle:_angle, gravity:500}, onUpdate: checkZ, onComplete: onComplete});
			dispatchEvent(new Event("onDeerClotReleased", true));
		}
		
		
		private function onComplete() : void
		{
			dispatchEvent(new Event("onDeerMudImpact", true));
			parent.removeChild(this);
		}
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------

		private function updatePos(e:Event = null) : void
		{
			var cX = (x>408) ? 408 : x;
			_velocity = -1000*(x/408)-100;
			_angle = getAngle();
			dispatchEvent(new Event("onClotPosChange", true));
		}
		
		
		private function initBehavior(b:Boolean) : void
		{
			if(b)
			{
				addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}else{
				removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
		}

		
		private function checkZ() : void
		{
			_z += 1;
			if(_z >= _frameZ) 
			{
				TweenMax.killTweensOf(this);
				dispatchEvent(new Event("onDeerMudImpact", true));
				parent.removeChild(this);
			}
		}
		
		
		private function getAngle() : Number
		{
			var distanceX : Number = x - parent.getChildByName("deer").x;
			var distanceY : Number = y - (-240);
			var angleInRadians : Number = Math.atan2(distanceY, distanceX);
			var angleInDegrees : Number = angleInRadians * (180 / Math.PI)//RADIAN_MULTIPLIER;
			return angleInDegrees;
		}
	}

}


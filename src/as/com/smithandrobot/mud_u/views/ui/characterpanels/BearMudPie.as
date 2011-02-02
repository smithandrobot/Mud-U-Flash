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
	
	public class BearMudPie extends Sprite 
	{

		private var _xVelocity;
		private var _yVelocity;
		private var _z = 0;
		private var _frameZ = 25;
		private var _gravity = .95;
		
		public function BearMudPie()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded)
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		public function get pieZ() : Number { return _z; };
				
		public function set pieZ(i:Number) : void
		{
			_z = i;
			if(_z >= _frameZ )
			{
				dispatchEvent(new Event("onBearMudImpact", true));
				parent.removeChild(this);
			}
		}
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		
		public function setVelocity(xv, yv) : void
		{
			_xVelocity = xv + RobotMath.randRange(-2, 2);
			_yVelocity = yv + RobotMath.randRange(-2, 2);
			addEventListener(Event.ENTER_FRAME, update);
			TweenMax.to(this, .65, { pieZ:_frameZ });
		}
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		private function update(e:Event = null) : void
		{
			x+=_xVelocity;
			y+=_yVelocity*=_gravity;
			rotation+=_yVelocity;
		}
		
		
		private function onAdded(e:Event = null) : void
		{

		}
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}

}


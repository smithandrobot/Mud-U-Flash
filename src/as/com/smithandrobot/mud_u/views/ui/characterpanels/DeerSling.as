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
	
	public class DeerSling extends Sprite 
	{
		
		private var _shape 		= new Shape();
		private var _startPoint : Point;
		private var _endPoint : Point;
		private var _midPoint	: Point = new Point();
		private var _offset	: int = 0;
		private var _color 		= 0x00AAE7;
		
		public function DeerSling()
		{
			super();
			addChild(_shape);
			mouseEnabled = false;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function set color(c) : void { _color = c; }
		
		public function set startPoint(p:Point) : void { _startPoint = p; }
		
		public function set endPoint(p:Point) : void { _endPoint = p; }
		
		public function set offset(o:int) : void { _offset = o; }
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		
		public function update(p:Point) : void
		{
			drawBand(p);
		}
		
		
		public function release() : void
		{
			//var func = function(){drawBand(_midPoint)}
			//TweenMax.to(_midPoint, .2, {x:_startPoint.x, y:_startPoint.y, onUpdate:func, ease:Back.easeOut})
		}
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		
		private function drawBand(p:Point) : void
		{
			var g = _shape.graphics;
			g.clear();
			_midPoint.x = p.x;
			_midPoint.y = p.y;
			/*g.moveTo(128.7, -249.4);*/
			g.moveTo(_startPoint.x, _startPoint.y);
			g.beginFill(_color);
			g.lineTo(_midPoint.x+_offset, _midPoint.y);
			g.lineTo(_midPoint.x+_offset, _midPoint.y+5);
			g.lineTo(_endPoint.x, _endPoint.y);
			g.lineTo(_startPoint.x, _startPoint.y);
		}
	}

}


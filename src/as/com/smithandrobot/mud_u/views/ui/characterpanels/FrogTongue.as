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
	
	public class FrogTongue extends Sprite 
	{
		
		private var _shape : Shape = new Shape();
		
		public function FrogTongue()
		{
			addChildAt(_shape,0)
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function expand(p) : void
		{
			var tp = this.globalToLocal(p);
			
			TweenMax.to(tip, .1, {x:tp.x, y:tp.y, onComplete: retract, onUpdate:update, ease:Back.easeOut, easeParams:[1.2], ovewrite:1});
		}
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function update() : void
		{

			var g = _shape.graphics;
			g.clear();
			g.beginFill(0xEC1C23, 1);
			g.moveTo(-2,0);
			g.lineTo(tip.x-2,tip.y);
			g.lineTo(tip.x+2,tip.y);
			g.lineTo(2,0);
			g.lineTo(-2,0);
		}
		
		private function retract() : void
		{
			TweenMax.to(tip, .1, {x:0, y:0, onUpdate:update, ease:Linear.easeNone, ovewrite:1});
		}
		
	}

}


package com.smithandrobot.mud_u.views.ui 
{

	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.*;
	
	import com.greensock.*;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	
	import com.smithandrobot.mud_u.interfaces.IScreen;

	public class EditPhotoScreenMaskEditor extends Sprite 
	{		
		
		private var _shape : Shape;
		private var _maskShape : Shape;
		
		public function EditPhotoScreenMaskEditor()
		{
			initHandles();
			_shape = new Shape();
			_maskShape = new Shape();
			
			_maskShape.x = 200;
			
			addChildAt(_shape, 0);
			addChildAt( _maskShape, 1);
			draw();
			mouseEnabled = false;
		}
		


		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function set data(d) : void {};
		

		public function get photoMask() : Sprite
		{
			var s = new Sprite();
			s.name="photoMask";
			
			s.graphics.beginFill(0xFF00FF);
			s.graphics.moveTo((d6.x + d1.x)/2, (d6.y+d1.y)/2);
			s.graphics.curveTo(d1.x, d1.y, (d1.x+d2.x)/2, ((d1.y+d2.y)/2));
			s.graphics.curveTo(d2.x, d2.y, ((d2.x+d3.x)/2), (d2.y+d3.y)/2);
			s.graphics.curveTo(d3.x, d3.y, ((d3.x+d4.x)/2), ((d3.y+d4.y)/2));
			s.graphics.curveTo(d4.x, d4.y, ((d4.x+d5.x)/2), ((d4.y+d5.y)/2));
			s.graphics.curveTo(d5.x, d5.y, ((d5.x+d6.x)/2), ((d5.y+d6.y)/2));			
			s.graphics.curveTo(d6.x, d6.y, ((d6.x + d1.x)/2), (d6.y+d1.y)/2);
			s.graphics.endFill();
			
			return s;
		}

		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		public function animateIn() : void
		{
			TweenMax.from(this, .25, {alpha:0});	
		}
		
		public function animateOut() : void
		{
			TweenMax.to(this, .25, {alpha:0});	
		}
		

		public function remove() : void
		{
			parent.removeChild(this);
			alpha = 1;
		}


		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		private function onMouseDownHandler(e : Event = null) : void
		{
			var point = e.target;
			enable(true, point);
		}
		
		
		private function onMouseUpHandler(e : Event = null) : void
		{
			var point = e.target;
			enable(false, point);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function draw(e : Event = null)
		{
			_shape.graphics.clear();
			
			_shape.graphics.beginFill(0xFFFFFF, .7);
			_shape.graphics.drawRect(0,0, 289,250);
			_shape.graphics.moveTo((d6.x + d1.x)/2, (d6.y+d1.y)/2);
			_shape.graphics.curveTo(d1.x, d1.y, (d1.x+d2.x)/2, ((d1.y+d2.y)/2));
			_shape.graphics.curveTo(d2.x, d2.y, ((d2.x+d3.x)/2), (d2.y+d3.y)/2);
			_shape.graphics.curveTo(d3.x, d3.y, ((d3.x+d4.x)/2), ((d3.y+d4.y)/2));
			_shape.graphics.curveTo(d4.x, d4.y, ((d4.x+d5.x)/2), ((d4.y+d5.y)/2));
			_shape.graphics.curveTo(d5.x, d5.y, ((d5.x+d6.x)/2), ((d5.y+d6.y)/2));			
			_shape.graphics.curveTo(d6.x, d6.y, ((d6.x + d1.x)/2), (d6.y+d1.y)/2);
			_shape.graphics.endFill();
		}
		
		private function initHandles() : void
		{
			/*d1.addEventListener(MouseEvent.MOUSE_MOVE, omMouseMove)*/
			d1.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			d2.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			d3.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			d4.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			d5.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			d6.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			
			d1.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			d2.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			d3.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			d4.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			d5.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			d6.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			
			d1.buttonMode = d2.buttonMode = d3.buttonMode = d4.buttonMode =  d5.buttonMode =  d6.buttonMode = true;
		}
		
		
		private function enable(b:Boolean, mc) : void
		{
			if(mc == Stage && b) return;
			if(mc == Stage && !b) removeEventListener(Event.ENTER_FRAME, draw);
			
			if(b) 
			{
				mc.startDrag(false, new Rectangle(-30,-30, 353, 324));
				mc.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
				if(!hasEventListener(Event.ENTER_FRAME)) addEventListener(Event.ENTER_FRAME, draw);
			}
			if(!b) 
			{
				d1.stopDrag();
				d2.stopDrag();
				d3.stopDrag();
				d4.stopDrag();
				if(hasEventListener(Event.ENTER_FRAME)) removeEventListener(Event.ENTER_FRAME, draw);
			}
		}
	}

}


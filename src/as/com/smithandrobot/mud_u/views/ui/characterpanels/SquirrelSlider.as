package com.smithandrobot.mud_u.views.ui.characterpanels
{

	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.*;
	
	import com.greensock.*;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	
	public class SquirrelSlider extends Sprite 
	{
		
		private var _rect = new Rectangle(0,13.5, 107, 0)
		private var _percent : Number = 0;
		
		public function SquirrelSlider()
		{
			addEventListener(Event.ADDED_TO_STAGE, onDisplayStateChange);
			addEventListener(Event.REMOVED_FROM_STAGE, onDisplayStateChange);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get percent() : Number { return _percent; };
		public function set percent(p:Number) : void 
		{ 
			_percent = p;
			btn.x = 107*_percent;
		};
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		private function onDisplayStateChange(e:Event) : void
		{
			if(e.type == Event.ADDED_TO_STAGE) init();
			if(e.type == Event.REMOVED_FROM_STAGE) disable();
		}
		
		
		private function init() : void
		{
			btn.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			btn.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			btn.buttonMode = true;
		}
		
		
		private function disable() : void
		{
			mouseUp();
			btn.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			btn.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			btn.buttonMode = false;
		}
		
		
		private function mouseDown(e: Event = null) : void
		{
			btn.startDrag(true, _rect);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			addEventListener(Event.ENTER_FRAME, updateSlider);
		}
		
		private function mouseUp(e: Event = null) : void
		{
			btn.stopDrag();
			removeEventListener(Event.ENTER_FRAME, updateSlider);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		
		
		private function updateSlider(e:Event = null) : void
		{
			_percent = btn.x/107;
			//trace(_percent);
			dispatchEvent(new Event("onSliderChange", true));
		}
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}

}


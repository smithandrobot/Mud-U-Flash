package com.smithandrobot.utils 
{

	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	
	public class HorizontalSlider extends EventDispatcher 
	{
		private var _track 		: MovieClip;
		private var _handle 	: MovieClip;
		private var _rect		: Rectangle;
		private var _range		: Number;
		private var _percent 	: Number;
		private var _dragging	: Boolean;
		
		public function HorizontalSlider(scope)
		{
			_track 	= scope.getChildByName("track");
			_handle = scope.getChildByName("handle");
			_dragging = false;
			
			if(_track && _handle)
			{
				initBehaviors();
				setLimits();
			}else{
				trace("need to have an mc named handle and track");
			}
		}

		
		public function set percent(p:Number) : void 
		{ 
			_percent = p;
			if(isNaN(_percent)) _percent = 0;
			if(!_dragging) _handle.x = ((_track.width-_handle.width)*_percent)+_track.x;
		};
		
		public function get percent() : Number { return _percent; };
		
		
		private function initBehaviors()
		{
			_handle.buttonMode = true;
			_handle.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		
		private function setLimits() : void
		{
			_rect 		= new Rectangle( _track.x, _handle.y, _track.width-_handle.width, 0  );
			_range 		= _track.width - _handle.width;
		}
		
		
		private function onMouseDown(e:MouseEvent) : void
		{
			_dragging = true;
			_handle.addEventListener( MouseEvent.MOUSE_UP, releaseDrag);
			_handle.stage.addEventListener( MouseEvent.MOUSE_UP, releaseDrag);
			_handle.startDrag( false, _rect );
			_handle.addEventListener( Event.ENTER_FRAME, drag );
		}
		
		
		private function drag( event:Event ):void 
		{
 			percent = ( _handle.x - _track.x ) / _range;

			dispatchEvent(new Event("onDrag"));
		}
		
		private function releaseDrag( event:MouseEvent ):void {
			
			_dragging = false;
			_handle.removeEventListener( Event.ENTER_FRAME, drag );
			_handle.removeEventListener( MouseEvent.MOUSE_UP, releaseDrag );
			_handle.stage.removeEventListener( MouseEvent.MOUSE_UP, releaseDrag );
			_handle.stopDrag();
			dispatchEvent(new Event("onEndDrag"));
		}
		
	}

}


package com.smithandrobot.mud_u.views.ui {

	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.Point;
	
	import com.greensock.*;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	
	public class DialogLogin extends Sprite 
	{
		
		private var _mediator;
		private var _confirm;
		
		public function DialogLogin(m = null)
		{
			_mediator = m;
			_confirm = dialog.startBtn;
			_confirm.addEventListener(MouseEvent.CLICK, onLogin)
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		public function open() : void
		{
			overlay.alpha = dialog.alpha = 0;
			dialog.scaleX = dialog.scaleY = 0;
			
			TweenMax.to(overlay, .2, {alpha:1});
			TweenMax.to(dialog, .2, {scaleX:1, scaleY:1, alpha:1, ease:Back.easeOut});
		}
		
		
		public function close(e:MouseEvent = null) : void
		{
			TweenMax.to(dialog, .2, {scaleX:0, scaleY:0, alpha:0, ease:Back.easeIn});
			TweenMax.to(overlay, .2, {delay:.1, alpha:0, onComplete:remove });
		}
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function onLogin(e: MouseEvent) : void
		{
			dispatchEvent(new Event("onLoging"));
		}
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		public function remove() : void
		{
			dispatchEvent(new Event("onDialogOut"));
			parent.removeChild(this);
			overlay.alpha = dialog.alpha = 0;
			dialog.scaleX = dialog.scaleY = 0;
		}
	}

}


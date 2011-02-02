package com.smithandrobot.mud_u.views.ui 
{

	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.Point;
	
	import com.greensock.*;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	
	public class DialogError extends Sprite 
	{
		
		private var _mediator;
		private var _confirm;
		private var _defaultText = "We’re having trouble talking\rto Facebook. This may be a \rtemporary problem.";
		private var _rockwell = new RockwellBold();
		
		public function DialogError(m = null)
		{
			_mediator = m;
			_confirm = tryAgainBtn;
			_confirm.addEventListener(MouseEvent.CLICK, onConfirm)
			_confirm.buttonMode = true;
			win.errorCopy.defaultTextFormat = getTextFormat()
			win.errorCopy.defaultTextFormat.bold = true;
			trace("bold: "+win.errorCopy.defaultTextFormat.bold)
			message = _defaultText;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function set message(t:String) : void
		{

			win.errorCopy.text = t;
		}
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		public function open() : void
		{
			overlay.alpha = win.alpha = 0;
			win.scaleX = win.scaleY = 0;
			deer.scaleX = deer.scaleY = deer.alpha = 0;
			
			TweenMax.to(overlay, .2, {alpha:1});
			TweenMax.to(deer, .2, {scaleX:1, scaleY:1, alpha:1, ease:Back.easeOut});
			TweenMax.to(win, .2, {scaleX:1, scaleY:1, alpha:1, ease:Back.easeOut});
		}
		
		
		public function close(e:MouseEvent = null) : void
		{
			TweenMax.to(deer, .2, {scaleX:0, scaleY:0, alpha:0, ease:Back.easeIn});
			TweenMax.to(win, .2, {scaleX:0, scaleY:0, alpha:0, ease:Back.easeIn});
			TweenMax.to(overlay, .2, {delay:.1, alpha:0, onComplete:remove });

		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function onConfirm(e: MouseEvent) : void
		{
			close();
		}
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		public function remove() : void
		{
			dispatchEvent(new Event("onDialogOut"));
			parent.removeChild(this);
			message = _defaultText;
			
			overlay.alpha = win.alpha = 0;
			win.scaleX = win.scaleY = 0;
			deer.scaleX = deer.scaleY = deer.alpha = 0;
		}
		
		private function getTextFormat() : TextFormat
		{
			var tf:TextFormat = new TextFormat();
			tf.font = _rockwell.fontName;
			tf.color = 0x4c4135;
			tf.letterSpacing = -0.5;
			tf.bold =true;
			tf.size = 14;
			return tf;
		}
	}

}


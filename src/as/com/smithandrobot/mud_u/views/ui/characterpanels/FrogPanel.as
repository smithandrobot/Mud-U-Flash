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
	
	import com.smithandrobot.mud_u.interfaces.*;
	import com.smithandrobot.mud_u.views.ui.characterpanels.*;
	
	public class FrogPanel extends Sprite implements ICharacterPanel
	{

		private var _clickedPoint : Point;
		private var _tongue : FrogTongue;
		
		public function FrogPanel()
		{
			alpha 		  	= 0;
			_clickedPoint 	= new Point();
			_tongue		  	= addChildAt(new FrogTongue(), numChildren-1) as FrogTongue;
			_tongue.alpha 	= 0;
			_tongue.x 		= -16;
			_tongue.y 		= -40;
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			instructionPanel.scaleX=0;
			instructionPanel.scaleY=0; 
			instructionPanel.alpha=0;
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		
		public function get type() : String
		{
			return "frog";
		}
		
		
		public function get clickedPoint() : Point
		{
			return _clickedPoint;
		}
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		
		public function open(e=null) : void
		{
			dispatchEvent(new Event("characterPanelOpened", true));
			TweenMax.to(instructionPanel, .2, {scaleX:1, scaleY:1, alpha:1, ease:Back.easeOut});
			enable(false);
		}
		
		
		public function close(e=null) : void
		{
			dispatchEvent(new Event("characterPanelClosed", true));
			TweenMax.to(instructionPanel, .2, {scaleX:0, scaleY:0, alpha:0, ease:Back.easeOut});
			enable(true);
		}
		
		
		public function openCTA(animate:Boolean) : void
		{
			if(animate)
			{
				//ctaPanel.x = -55;
				//TweenMax.to(ctaPanel, .25, {alpha:1, x:-45.05, ease:Back.easeIn});
			}else{
				//alpha = 1;
			}
		}
		
		
		public function closeCTA(animate:Boolean) : void
		{
			if(animate)
			{
				//TweenMax.to(ctaPanel, .25, {alpha:0});	
			}else{
				//ctaPanel.alpha = 0;
			}
		}
		
		
		public function animateIn(d:Number) : void
		{
			TweenMax.from( frog, .15, {delay:d, scaleX:0, scaleY:0, ease:Back.easeOut});
			TweenMax.from( ctaPanel, .2, {delay:d+.1, x:"+20", alpha:0, ease:Back.easeOut});
			TweenMax.to( _tongue, .1, {delay:d+.3, alpha:1} );
			alpha = 1;
		}
		
		public function animateOut(d:Number) : void
		{
			TweenMax.to( frog, .15, {delay:d, scaleX:0, scaleY:0, ease:Back.easeIn});
			TweenMax.to( ctaPanel, .2, {delay:d+.1, x:"-20", alpha:0, ease:Back.easeIn, onComplete:onAnimationFinished});
			_tongue.alpha = 0;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function onAdded(e:Event = null) : void
		{
			enable(true);
		}
		
		
		private function onAnimationFinished() : void
		{
			alpha = 0;
			frog.scaleY = frog.scaleX = 1;
			ctaPanel.alpha = 1;
			ctaPanel.x = 2.25;
		}
		
		
		private function mouseHandler(e:MouseEvent = null) : void
		{
			trace("frog screen: "+e.target.name);
			
			if(e.target.name == "overlay" || e.target.name == "closeBtn") 
			{ 
				removeEventListener(Event.ENTER_FRAME, onFrame);
				close(); 
				return;
			};
			
			if(e.type == MouseEvent.MOUSE_DOWN) { addEventListener(Event.ENTER_FRAME, onFrame) };
			if(e.type == MouseEvent.MOUSE_UP) { removeEventListener(Event.ENTER_FRAME, onFrame) };
		}
		
		private function onFrame(e:Event) : void
		{
			var gp = new Point(mouseX, mouseY);;
			_tongue.expand(this.localToGlobal(gp));
			_clickedPoint.x = mouseX;
			_clickedPoint.y = mouseY;
			dispatchEvent(new Event("onFrogErase", true));
		}
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		
		private function enable(b:Boolean) : void
		{
			if(b)
			{
				frog.addEventListener(MouseEvent.CLICK, open);
				ctaPanel.addEventListener(MouseEvent.CLICK, open);
				/*stage.removeEventListener(MouseEvent.CLICK, mouseHandler);*/
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP, mouseHandler);
				frog.buttonMode = ctaPanel.buttonMode = true;
				instructionPanel.closeBtn.removeEventListener(MouseEvent.CLICK, close);
				instructionPanel.buttonMode = false;
			}else{
				frog.removeEventListener(MouseEvent.CLICK, open);
				stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
				stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
				frog.buttonMode = ctaPanel.buttonMode = false;
				instructionPanel.closeBtn.addEventListener(MouseEvent.CLICK, close);
				instructionPanel.buttonMode = true;
			}
		}
		
	}

}


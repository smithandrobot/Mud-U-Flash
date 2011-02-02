package com.smithandrobot.mud_u.views.ui.characterpanels {

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
	import com.smithandrobot.utils.*;
	
	public class DeerPanel extends Sprite implements ICharacterPanel
	{
		
		private var _clot : DeerMudClot2;
		private var _clotAngle : Number;
		private var _velocity : Number = 0;
		private var _frameZ	: int = 30;
		private var _clotZ = 0;
		private var _slingBack : DeerSling;
		private var _slingFront : DeerSling;
		private var _slingPoint : Point = new Point();
		private var _frame;
		
		public function DeerPanel()
		{
			alpha = 0;
			bkgPanel.alpha = 0;
			bkgPanel.closeBtn.addEventListener(MouseEvent.CLICK, close);
			bkgPanel.closeBtn.buttonMode = true;
			mouseEnabled = false;
			
			_slingBack = addChild(new DeerSling()) as DeerSling;
			_slingFront = addChild(new DeerSling()) as DeerSling;
			_slingFront.offset = 13;
			
			enable(true);
			
			addEventListener("onDeerMudImpact", onDeerMudImpact);
			addEventListener("onClotPosChange", onClotPosChange);
			addEventListener("onDeerClotReleased", onClotReleased);
			addEventListener("onClotLoaded", onClotPosChange);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		
		public function get type() : String
		{
			return "deer";
		}


		public function set frame(f) : void
		{
			_frame = f;
		}
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		
		public function open(e = null) : void
		{
			var deer = getChildByName("deer") as Deer;
			
			TweenMax.to(deer, .2, {x: 160, y:-22, ease:Back.easeOut});	
			TweenMax.to(bkgPanel,.2,{alpha:1});
			TweenMax.to(ctaPanel, .2, {x: 14.35, alpha:0});
			enable(false);
			TweenMax.to(deer.head, .2, {rotation:20, onComplete: onPanelOpened});
			
			dispatchEvent(new Event("characterPanelOpened", true));

		}
		
		
		public function close(e = null) : void
		{
			var deer = getChildByName("deer") as Deer;
			
			TweenMax.to(deer, .2, {x: 6, y:1.05, ease:Back.easeOut});
			TweenMax.to(deer.head, .2, {rotation:0});
			TweenMax.to(bkgPanel,.2,{alpha:0});
			TweenMax.to(ctaPanel, .25, {alpha:1, x:24.35, ease:Back.easeIn, onComplete:onPanelClosed});
			
			_clot.enable = false;
			removeChild(_clot)
			enable(true);
			_slingFront.visible = false;
			_slingBack.visible = false;
			deer.bandTop.alpha = 1;
			bkgPanel.mouseEnabled = false;
			dispatchEvent(new Event("characterPanelClosed", true));
		}
		
		
		public function openCTA(animate:Boolean) : void
		{
			if(animate)
			{
				ctaPanel.x = 14.35;
				TweenMax.to(ctaPanel, .25, {alpha:1, x:24.35, ease:Back.easeIn});
			}else{
				alpha = 1;
			}
		}
		
		
		public function closeCTA(animate:Boolean) : void
		{
			if(animate)
			{
				TweenMax.to(ctaPanel, .25, {alpha:0});	
			}else{
				ctaPanel.alpha = 0;
			}
		}
		
		
		public function animateIn(d:Number) : void
		{
			var deer = getChildByName("deer") as Deer;
			
			TweenMax.from(deer, .2, {delay:d, y:"+100", scaleY:0, ease:Back.easeOut});
			TweenMax.from( ctaPanel, .2, {delay:d+.1, x:"-20", alpha:0, ease:Back.easeOut});
			alpha = 1;
		}
		
		
		public function animateOut(d:Number) : void
		{
			/*slingMask.visible = false;*/
			TweenMax.to(deer, .2, {delay:d, y:"+100", scaleY:0, ease:Back.easeIn});
			TweenMax.to( ctaPanel, .2, {delay:d+.1, x:"-20", alpha:0, ease:Back.easeIn, onComplete:animationOut});
		}
		
		public function getClotDest() : Point
		{
			var c = _frame.crossHairs;
			var p = CoordinateTools.localToLocal(_frame.crossHairs, this);
			return p;
		}
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		private function mouseHandler(e:MouseEvent = null) : void
		{
			if(e.target.name == "overlay") 
			{ 
				close(); 
				return;
			};
		}
		
		
		private function animationOut() : void
		{
			deer.scaleY = 1;
			deer.y = 1.05;
			ctaPanel.alpha = 1;
			ctaPanel.x=24.35;
			alpha = 0;
		}

		
		private function onPanelOpened() : void
		{
			deer.toggleUnderwear("off");
			deer.gameMode = true;
			TweenMax.delayedCall(.3, function()
			{
				_clot = addChild(new DeerMudClot2()) as DeerMudClot2;
				_slingFront.visible = true;
				_slingBack.visible = true;
			})

		}
		
		
		private function onPanelClosed() : void
		{

			TweenMax.delayedCall(.05, function()
			{
				deer.bandTop.alpha = 0;
				deer.toggleUnderwear("on");
				deer.gameMode = false;
			})

		}
		
		
		private function onDeerMudImpact(e:Event) : void
		{
			/*_clot = addChild(new DeerMudClot()) as DeerMudClot;*/
		}
		
		
		private function onClotReleased(e:Event) : void
		{
			_slingBack.release();
			_slingFront.release();
			_clot = addChild(new DeerMudClot2()) as DeerMudClot2;
			TweenMax.to(_frame.crossHairs, .2, {alpha:0});
		}
		
		
		private function onClotPosChange(e:Event) : void
		{
			_slingBack.startPoint = CoordinateTools.localToLocal(deer.head, this, new Point(deer.head.p1.x, deer.head.p1.y));
			_slingBack.endPoint = CoordinateTools.localToLocal(deer.head, this, new Point(deer.head.p2.x, deer.head.p2.y));
			
			_slingFront.startPoint = CoordinateTools.localToLocal(deer.head, this, new Point(deer.head.p3.x, deer.head.p3.y));
			_slingFront.endPoint = CoordinateTools.localToLocal(deer.head, this, new Point(deer.head.p4.x, deer.head.p4.y));
			
			/*slingMask.visible = true;*/
			_slingPoint.x = e.target.x;
			_slingPoint.y = e.target.y;
			
			setChildIndex(_slingFront, numChildren-1);
			
			_slingFront.update(_slingPoint);
			_slingBack.update(_slingPoint);
			
			if(e.type == "onClotPosChange")
			{
				var left = 31;
				var top = 43;
				var width = 289;
				var height = 250;
				
			    var cx = left+(e.target.xTension*width);
				var cy = 34+(e.target.yTension*height);
				if(_frame.crossHairs.alpha < 1) TweenMax.to(_frame.crossHairs, .2, {alpha:1});
				TweenMax.to(_frame.crossHairs, .2, {x:cx, y:cy});
			}
		}
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		
		private function enable(b:Boolean) : void
		{
			if(b)
			{
				deer.addEventListener(MouseEvent.CLICK, open);
				ctaPanel.addEventListener(MouseEvent.CLICK, open);
				deer.buttonMode = ctaPanel.buttonMode = true;
				if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP, mouseHandler);
				if(stage) stage.removeEventListener(MouseEvent.CLICK, mouseHandler);
			}else{
				deer.removeEventListener(MouseEvent.CLICK, open);
				ctaPanel.removeEventListener(MouseEvent.CLICK, open);
				deer.buttonMode = ctaPanel.buttonMode = false;
				if(stage) stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
				if(stage) stage.addEventListener(MouseEvent.CLICK, mouseHandler);
			}
		}
	}

}


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
	import com.smithandrobot.utils.*;
	
	public class BearPanel extends Sprite implements ICharacterPanel
	{
		
		private var _pieYs : Array;
		private var _pieMCs : Array;
		private var _velocityMax : Number = 30;
		private var _velocity = 20;
		private var _mouseDown : Boolean = false;
		private var _frame : Number = 0;
		public function BearPanel()
		{
			alpha =0;
			bkgPanel.alpha = 0;
			
			var pie;
			
			bkgPanel.closeBtn.addEventListener(MouseEvent.CLICK, close);
			bkgPanel.closeBtn.buttonMode = true;
			bkgPanel.arrowMC.mouseEnabled = false;
			
			_pieYs = new Array();
			_pieMCs = new Array();

			//enable(true);
			
			for(var i = 1; i<= 10; i++)
			{
				pie = mudPies["m"+String(i)];
				_pieYs.push(pie.transform.matrix.ty);
				_pieMCs.push(pie)
			}
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get type() : String
		{
			return "bear";
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function open(e = null) : void
		{	
			TweenMax.to(bkgPanel,.2,{delay:.1, x:-133.4, alpha:1, ease:Back.easeOut});
			TweenMax.to(ctaPanel, .2, {x: -216.9, alpha:0, ease:Back.easeIn, easeParams:[3]});
			enable(false);
			dispatchEvent(new Event("characterPanelOpened", true));
		}
		
		
		public function close(e = null) : void
		{
			TweenMax.to(bkgPanel,.2,{x:-113.4, alpha:0, ease:Back.easeIn});
			TweenMax.to(ctaPanel, .2, {delay:.1, x: -236.9, alpha:1, ease:Back.easeOut});
			enable(true);
			dispatchEvent(new Event("characterPanelClosed", true));
		}
		
		
		public function openCTA(animate:Boolean) : void
		{
			if(animate)
			{
				ctaPanel.x = -247;
				TweenMax.to(ctaPanel, .25, {alpha:1, x:-237, ease:Back.easeIn});
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
			TweenMax.from( bear, .2, {delay:d, x:"+200", ease:Back.easeOut});
			TweenMax.from( ctaPanel, .2, {delay:d+.1, x:"+20", alpha:0, ease:Back.easeOut});
			
			_pieMCs.reverse();
			
			TweenMax.allFrom(_pieMCs, .15, {delay:d+.15, scaleY:0, y:"+20", ease:Back.easeOut, easeParams:[5]}, .02);
			
			alpha = 1;
		}
		
		public function animateOut(d:Number) : void
		{
			TweenMax.to( bear, .2, {delay:d+.18, x:"+200", ease:Back.easeIn, onComplete: onAnimationFinished});
			TweenMax.to( ctaPanel, .2, {delay:d, x:"+20", alpha:0, ease:Back.easeIn});
			_pieMCs.reverse();
			TweenMax.allTo(_pieMCs, .15, {delay:d, scaleY:0, y:"+20", ease:Back.easeIn, easeParams:[5]}, .02);
		}
		
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		private function onAdded(e:Event = null)
		{
			enable(true);
		};
		
		private function onAnimationFinished() : void
		{
			alpha = 0;
			bear.x = 0;
			ctaPanel.x = -236.9;
			ctaPanel.alpha = 1;
			var pie;
			
			for(var i = 0; i<= 9; i++)
			{
				pie = _pieMCs[i];
				pie.scaleY = 1;
				pie.y = _pieYs[i];
			}
		}
		
		
		private function onFrameUpdate(e:Event = null) : void
		{
			updateArrow();
		}
		
		
		private function mouseHandler(e:MouseEvent = null) : void
		{
			trace(e.type)
			if( e.type == MouseEvent.MOUSE_DOWN ) 
			{ 
				if(e.target.name == "overlay") 
				{ 
					close(); 
					return;
				};
				_mouseDown = true; bear.toggleSpin(true);
			};
			if( e.type == MouseEvent.MOUSE_UP ) { _mouseDown = false; _velocity = 20; bear.toggleSpin(false);};
			if( e.type == MouseEvent.CLICK ) 
			{ 
				_frame = 3;
				_mouseDown = true;
				updateArrow()
				_mouseDown = false;
			};
		}
		
		
		//-----------------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS         
		//-----------------------------------------------
		

		private function updateArrow(e:Event = null)
		{
			var p = this.localToGlobal(new Point(mouseX, mouseY));
			var aPt = bkgPanel.localToGlobal(new Point(bkgPanel.arrowMC.x, bkgPanel.arrowMC.y));
			
			var distanceX : Number = p.x - aPt.x;
			var distanceY : Number = p.y - aPt.y;
			var angleInRadians : Number = Math.atan2(distanceY,distanceX);
			var angleInDegrees : Number = angleInRadians * (180 / Math.PI);
			var m : BearMudPie;

			if(angleInDegrees < -179 || angleInDegrees > -120) 
			{
				angleInDegrees = (angleInDegrees > 0) ? -179 : -116;
				TweenMax.to(bkgPanel.arrowMC, .3, {rotation:angleInDegrees, overwrite:1});
				return;
			}
			
			TweenMax.to(bkgPanel.arrowMC, .3, {rotation:angleInDegrees, overwrite:1});
			
			if(_mouseDown && (_frame%3 == 0)) 
			{
				_velocity = ((_velocity+1) < _velocityMax) ? _velocity+=.5 : _velocityMax;
				m = new BearMudPie();
				m.x = ( _frame%2==0 ) ? 13 : -65;
				m.y = ( _frame%2==0 ) ? -148 : -194;
				m.rotation = RobotMath.randRange(0, 360);
				
				var xVelocity = RobotMath.randRange(-2, 2) + Math.cos(angleInRadians)*_velocity;
				var yVelocity = RobotMath.randRange(-2, 2)  + Math.sin(angleInRadians)*_velocity;
				m.setVelocity(xVelocity, yVelocity);
				addChild(m);
			}
			++_frame;
		}
		
		
		private function enable(b:Boolean) : void
		{
			if(b)
			{
				bear.addEventListener(MouseEvent.CLICK, open);
				ctaPanel.addEventListener(MouseEvent.CLICK, open);
				bear.buttonMode = ctaPanel.buttonMode = true;
				removeEventListener(Event.ENTER_FRAME, onFrameUpdate);
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP, mouseHandler);
				stage.removeEventListener(MouseEvent.CLICK, mouseHandler);
			}else{
				bear.removeEventListener(MouseEvent.CLICK, open);
				ctaPanel.removeEventListener(MouseEvent.CLICK, open);
				bear.buttonMode = ctaPanel.buttonMode = false;
				addEventListener(Event.ENTER_FRAME, onFrameUpdate);
				stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
				stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
				stage.addEventListener(MouseEvent.CLICK, mouseHandler);
			}
		}
	}

}


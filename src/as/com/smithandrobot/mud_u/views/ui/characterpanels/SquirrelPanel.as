package com.smithandrobot.mud_u.views.ui.characterpanels 
{
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.Point;
	import fl.controls.Slider;
	import fl.ik.*;

	import com.greensock.*;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	
	import com.smithandrobot.mud_u.interfaces.*;
	import com.smithandrobot.mud_u.views.ui.characterpanels.*;
	
	public class SquirrelPanel extends Sprite implements ICharacterPanel
	{
		
		
		private var _grayPicker : SquirrelColorPicker;
		private var _chocolatePicker : SquirrelColorPicker;
		private var _tanPicker : SquirrelColorPicker;
		private var _paintColor : String;
		private var _scale : Number = 1;
		
		public function SquirrelPanel()
		{
			alpha = 0;
			bkgPanel.alpha = 0;
			bkgPanel.closeBtn.addEventListener(MouseEvent.CLICK, close);
			bkgPanel.closeBtn.buttonMode = true;

			bkgPanel.slider.percent = _scale = .5;
			/*treePiece.alpha = 0;*/
			joystick.scaleX = joystick.scaleY = joystick.alpha = 0;
			joystick.rotation = 115;
			arm.visible = false;
			enable(true);
			
			_grayPicker = new SquirrelColorPicker(bkgPanel.grayPicker);
			_chocolatePicker = new SquirrelColorPicker(bkgPanel.chocolatePicker);
			_tanPicker = new SquirrelColorPicker(bkgPanel.tanPicker);
			
			_grayPicker.color = "gray";
			_chocolatePicker.color = "chocolate";
			_tanPicker.color = "tan";
			
			_grayPicker.addEventListener("onColorChange", onColorChange);
			_chocolatePicker.addEventListener("onColorChange", onColorChange);
			_tanPicker.addEventListener("onColorChange", onColorChange);
			
			addEventListener("onSliderChange", onScaleChange)
			_grayPicker.selected = true;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get type() : String
		{
			return "squirrel";
		}
		
		public function set frame(f) : void
		{
			arm.frame = f;
		}
		
		public function get scale() : Number { return _scale; };
		public function set scale(s) : void { _scale = s };
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function open(e = null) : void
		{
			TweenMax.to(squirrel, .2, {x: 18, y:-12, ease:Back.easeIn});	
			TweenMax.to(bkgPanel,.2,{delay:.1, x:57, autoAlpha:1, ease:Back.easeOut});
			TweenMax.to(ctaPanel, .2, {x: -55.05, alpha:0, ease:Back.easeIn});
			/*TweenMax.to(treePiece, .2, {scaleY:1, alpha:1, ease:Back.easeIn});*/
			TweenMax.to(joystick, .2, {rotation: 0, scaleY:1, scaleX:1, alpha:1, ease:Back.easeOut});
			enable(false);
			arm.enabled = true;
			dispatchEvent(new Event("characterPanelOpened", true));
			arm.visible = true;
		}
		
		
		public function close(e = null) : void
		{
			TweenMax.to(squirrel, .2, {delay:.15, x: 12, y:-2, ease:Back.easeOut});
			TweenMax.to(bkgPanel,.2,{x:47,autoAlpha:0, ease:Back.easeIn});
			TweenMax.to(ctaPanel, .2, {delay:.1, x: -45.05, alpha:1, ease:Back.easeOut});
			/*TweenMax.to(treePiece, .2, {scaleY:0, alpha:0, ease:Back.easeIn});*/
			TweenMax.to(joystick, .2, {rotation: 115, scaleY:0, scaleX : 0, alpha:0, ease:Back.easeIn});
			arm.visible = false;
			enable(true);
			arm.enabled = false;
			dispatchEvent(new Event("characterPanelClosed", true));
		}
		
		
		public function openCTA(animate:Boolean) : void
		{
			if(animate)
			{
				ctaPanel.x = -55;
				TweenMax.to(ctaPanel, .25, {alpha:1, x:-45.05, ease:Back.easeIn});
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
			TweenMax.from( squirrel, .2, {delay:d, y:"-200", ease:Back.easeOut});
			TweenMax.from( ctaPanel, .2, {delay:d+.1, x:"-20", alpha:0, ease:Back.easeOut});
			alpha = 1;
		}
		
		
		public function animateOut(d:Number) : void
		{
			TweenMax.to( squirrel, .2, {delay:d, y:"-200", ease:Back.easeIn});
			TweenMax.to( ctaPanel, .2, {delay:d+.1, x:"-20", alpha:0, ease:Back.easeIn, onComplete:animationFinished});
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
		
		
		private function animationFinished() : void
		{
			alpha = 0;
			squirrel.y = -2.05;
			ctaPanel.x = -45.05;
			ctaPanel.alpha = 1;
		}
		
		
		private function onColorChange(e:Event = null) : void
		{
			_paintColor = e.target.color;
			arm.color = e.target.color;
		}
		
		private function onScaleChange(e:Event = null) : void
		{
			_scale = e.target.percent;
		}
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		
		private function enable(b:Boolean) : void
		{
			if(b)
			{
				squirrel.addEventListener(MouseEvent.CLICK, open);
				ctaPanel.addEventListener(MouseEvent.CLICK, open);
				squirrel.buttonMode = ctaPanel.buttonMode = true;
				if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP, mouseHandler);
				if(stage) stage.removeEventListener(MouseEvent.CLICK, mouseHandler);
			}else{
				squirrel.removeEventListener(MouseEvent.CLICK, open);
				ctaPanel.removeEventListener(MouseEvent.CLICK, open);
				squirrel.buttonMode = ctaPanel.buttonMode = false;
				if(stage) stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
				if(stage) stage.addEventListener(MouseEvent.CLICK, mouseHandler);
			}
		}
	}

}


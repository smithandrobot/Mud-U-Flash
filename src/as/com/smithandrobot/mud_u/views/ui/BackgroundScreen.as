package com.smithandrobot.mud_u.views.ui {

	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.*;
	
	import com.greensock.*;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	
	import com.smithandrobot.mud_u.interfaces.IScreen;
	
	public class BackgroundScreen extends Sprite implements IScreen
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		
		/**
		 *	@constructor
		 */
		public function BackgroundScreen()
		{
			super();
			alpha = 0;
			TweenPlugin.activate([TransformAroundPointPlugin, MotionBlurPlugin]);
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function set data(d) : void {};
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		public function animateIn() : void
		{
			alpha = 1;
			TweenMax.from(bkg, .25, {alpha:0, y:"+10"});
			TweenMax.from(tree, .25, {delay:.4, 
									y:"+5", 
									ease:Back.easeOut, 
									easeParams:[.8], 
									scaleY:0,
									scaleX:.1
									});

			TweenMax.from(logo, .12, {delay:.65, scaleX:0, scaleY:0, ease:Back.easeOut, onComplete:animationInComplete});
		}
		
		public function animateOut() : void
		{
			
		}
		
		public function remove() : void
		{
			dispatchEvent(new Event("onScreenOut"));
			parent.removeChild(this);
		}
		
		
		public function hideJeep() : void
		{
			
		}
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		public function onAdded(e:Event) : void
		{
			animateIn();
		}
		
		private function animationInComplete() : void
		{
			dispatchEvent(new Event("backgroundAnimationDone", true));
		}
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}

}


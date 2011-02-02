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
	
	import com.smithandrobot.mud_u.views.ui.*;
	import com.smithandrobot.mud_u.ApplicationFacade;
	
	public class ImageLoadStatus extends Sprite 
	{
		
		private var _scope : *;
		private var _loader : LoaderStatus;

		public function ImageLoadStatus(scope = null)
		{
			alpha 		 = 0;
			visible = false;
			_scope = scope;

			_loader = addChild(new LoaderStatus()) as LoaderStatus;
			_loader.x = 382;
			_loader.y = 332;
		
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		
		public function start() : void
		{
			//
			TweenMax.to(this, .2, {autoAlpha:1});
			_loader.toggleVisible(true,true);
			status.text = "Downloading Photo";
		}
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		private function onAdded(e:Event) : void
		{			
			//TweenMax.to(this, .2, {alpha:1});
		}
		

		public function animateIn() : void
		{
			start();
		}
				
		public function animateOut() : void
		{
	 		TweenMax.to(this, .2, {alpha:0, onComplete:remove});
		}
		
		
		public function remove()
		{
			parent.removeChild(this);
			_loader.stop();
		}
		
		
	}

}


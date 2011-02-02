package com.smithandrobot.mud_u
{

	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.Point;
	
	import com.greensock.*;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	
	public class MudUChart extends Sprite 
	{
		
		private var _data;
		
		public function MudUChart()
		{
			bearBar.scaleY 		= 0;
			deerBar.scaleY 		= 0;
			squirrelBar.scaleY 	= 0;
			sasplotchBar.scaleY = 0;
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded)
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function onAdded(e:Event) : void
		{
			introAnimation();
		}
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function introAnimation() : void
		{
			TweenMax.from(bkg, .25, {scaleX:.3, scaleY:.3, ease:Back.easeOut});
			TweenMax.allFrom([bearP, deerP, squirrelP, sasplotchP], .2, {delay:.2, alpha:0, scaleX:.3, scaleY:.3, ease:Back.easeOut}, .08);
			TweenMax.from(ribbon, .2, {delay:.4, x:"-5", alpha:0});
			TweenMax.from(headline, .2, {delay:.5, y:"+5", alpha:0, onComplete:getData});
		}
		
		
		private function getData() : void
		{
			var data;
			
			if( loaderInfo.parameters.mudpie )
			{
				data = null;
			}else{
				data = {mudpie:1000, buck_wild:200, squirrel:50, sasplotch:2};	
			}
			
			_data = data;
			handleData(_data)
		}
		
		private function getMostMuds(obj) : Number
		{
			var most = 0;
			var i;
			
			for(i in obj)
			{
				if(obj[i] > most) most = obj[i];
			}
			
			return most;
		}
		
		private function handleData(obj) : void
		{
			var i = 0;
			var highest = getMostMuds(obj);
			var bar;
			var delay = .08;
			var iterator = 0;
			var scale  = 0
			var min = .1;
			
			var bars = [
					  	{bar:bearBar, data:obj.mudpie}, 
					  	{bar:deerBar, data:obj.buck_wild},
					  	{bar:squirrelBar, data:obj.squirrel}, 
					  	{bar:sasplotchBar, data:obj.sasplotch}
					  ];
			var total = bars.length-1;
			
			for(i; i<=total; i++)
			{
				bar = bars[i];
				scale = bar.data/highest;
				scale += min;
				TweenMax.to(bar.bar, .2 ,{delay:i*delay, scaleY:scale, ease:Back.easeOut});
			
			}
		}
	}

}


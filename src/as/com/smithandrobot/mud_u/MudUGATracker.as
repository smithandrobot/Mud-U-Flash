package com.smithandrobot.mud_u 
{
	import flash.display.Sprite;
	
	import com.google.analytics.AnalyticsTracker; 
	import com.google.analytics.GATracker; 
	
	public class MudUGATracker extends Sprite 
	{
		
		private static var _tracker : *;
		
		public function MudUGATracker(stage)
		{
			_tracker = stage.getChildByName("gaTracker")
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
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		public static function trackOutboundClick(location)
		{
			_tracker.trackEvent("Outbound Links", "Click", location);
		}
	}

}


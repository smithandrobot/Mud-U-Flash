package com.smithandrobot.mud_u.views.ui 
{
	
	import flash.events.EventDispatcher;
	import flash.display.*;	
	
	import com.greensock.*;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	
	public class CharacterPanelsManager extends EventDispatcher 
	{
		
		private var _panels : Array = new Array();
		
		public function CharacterPanelsManager()
		{
			super();
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function registerPanels(p:Array) 
		{ 
			_panels = p;
		};
		
		
		public function toggleCTAPanels(state:String = "close", animate : Boolean = false) : void
		{
			var i = 0;
			
			for(i in _panels)
			{
				if(state == "close") _panels[i].closeCTA(animate);
				if(state == "open") _panels[i].openCTA(animate);
			}
		}
	}
}


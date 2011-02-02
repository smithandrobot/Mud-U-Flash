package com.smithandrobot.mud_u
{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.system.*;
	
	import com.smithandrobot.mud_u.ApplicationFacade;
	
	public class MudU extends Sprite 
	{

		private var facade:ApplicationFacade;
		
		public function MudU()
		{
			Security.allowDomain("*");
			facade = ApplicationFacade.getInstance();
			addEventListener("backgroundAnimationDone", startUp);
			var d = new Debug(this);
			var t = new MudUGATracker(this);
		}
		
		private function startUp(e:Event) : void
		{
			facade.startup( this );
		}
		
	}

}


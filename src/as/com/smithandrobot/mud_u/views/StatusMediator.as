/**
 * StatusMediator.as
 *
 *
 *
 * @author   David Ford <>
 * @version  1.0.0
 */
package com.smithandrobot.mud_u.views 
{
	import flash.display.*;
	import flash.events.*;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
    import com.smithandrobot.mud_u.ApplicationFacade;
    import com.smithandrobot.mud_u.model.*;
    import com.smithandrobot.mud_u.views.ui.*;

	public class StatusMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "StatusMediator";
		

		public function StatusMediator( viewComponent:Object ):void 
		{
			super(NAME, viewComponent);
			statusBar.addEventListener("onMudvite", onMudVite);
		}


		override public function handleNotification(notification:INotification):void 
		{
			switch (notification.getName())
			{
				case ApplicationFacade.STATUS_CHANGE :
					onStatusChange(notification.getBody());
					break;
				
				default:
					break;
			}
		}
		

		override public function listNotificationInterests():Array 
		{
			return [
					ApplicationFacade.STATUS_CHANGE
					];
		}
		
		
		
		private function onMudVite(e: Event) : void
		{
			var f = facade.retrieveProxy("APIProxy") as APIProxy;
			f.sasplotchLocked = false;
		}
		
		
		private function get statusBar() : StatusBar
		{
			return viewComponent as StatusBar;
		}
		
		
		private function onStatusChange(i)
		{
			statusBar.status = i;
		}


	}
}
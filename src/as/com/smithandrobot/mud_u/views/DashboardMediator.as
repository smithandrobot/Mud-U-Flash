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

	public class DashboardMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "DashboardMediator";
		

		public function DashboardMediator( viewComponent:Object ):void 
		{
			super(NAME, viewComponent);
		}


		override public function handleNotification(notification:INotification):void 
		{
			switch (notification.getName())
			{
				case ApplicationFacade.PLAYER_DATA :
					onPlayerData(notification.getBody());
					break;
				
				default:
					break;
			}
		}
		

		override public function listNotificationInterests():Array 
		{
			return [
					ApplicationFacade.PLAYER_DATA
					];
		}
		
		
		
		private function onPlayerData(obj) : void
		{
			var f = facade.retrieveProxy("APIProxy") as APIProxy;
			/*f.sasplotchLocked = false;*/
			trace("heard player data: "+obj);
			dashbord.data = obj;
		}
		
		
		private function get dashbord() : Dashboard
		{
			return viewComponent as Dashboard;
		}
	}
}
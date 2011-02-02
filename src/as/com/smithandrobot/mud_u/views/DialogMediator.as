/**
 * DialogMediator.as
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
	
	import com.bigspaceship.utils.*;
	
	import com.smithandrobot.mud_u.model.*;
    import com.smithandrobot.mud_u.ApplicationFacade;
	import com.smithandrobot.mud_u.views.ui.*;
	
	public class DialogMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "DialogMediator";
		private var _fbProxy : FacebookDataProxy;
		private var _dataProxy : ApplicationDataProxy;
		/*private var _lastDialog = null;*/
		private var _dialogWindow = null;
		private var _dialogs : Array = new Array();
		private var _dialogID : String;
		
		public function DialogMediator(viewComponent:Object):void 
		{
			super(NAME, viewComponent);
			_dialogs.push({id:"mudvite", clss:DialogMudvite, instance:null});
			_dialogs.push({id:"login", clss:DialogLogin, instance:null});
			_dialogs.push({id:"error", clss:DialogError, instance:null});
			/*_fbProxy = 	facade.retrieveProxy("FacebookDataProxy") as FacebookDataProxy;*/
		}



		public function getFriends() : void 
		{ 
			var fbProxy = facade.retrieveProxy("FacebookDataProxy") as FacebookDataProxy;
			fbProxy.getFriends(); 
		}
		
		
		override public function handleNotification(notification:INotification):void 
		{
			switch (notification.getName())
			{
				case ApplicationFacade.OPEN_DIALOG:
					openDialog(notification.getBody());
					break;
				case ApplicationFacade.FRIENDS_DATA_LOADED:
					onFriendsData(notification.getBody());
				break;
				case ApplicationFacade.LOGOUT:
					onLoggedOut();
				break;
				case ApplicationFacade.LOGGED_IN:
					onLoggedIn();
				break;
				case ApplicationFacade.ERROR:
					onAppError(notification.getBody());
					break;
				case ApplicationFacade.FRIENDS_DATA_LOADED:
					onFriendsData(notification.getBody());
				break;
				default:
					break;
			}
		}
		

		override public function listNotificationInterests():Array 
		{
			return [
            		ApplicationFacade.OPEN_DIALOG,
            		ApplicationFacade.ERROR,
					ApplicationFacade.FRIENDS_DATA_LOADED,
					ApplicationFacade.LOGOUT,
					ApplicationFacade.LOGGED_IN
					];
		}
		
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		
		private function openDialog(d) : void
		{
			_dialogWindow = getDialogById(d);
			viewComponent.addChildAt(_dialogWindow, viewComponent.numChildren-1)
			_dialogWindow.open();
		}
		
		private function closeDialog() : void
		{
			_dialogWindow.close();
		}
		
		
		private function onFriendsData(d) : void
		{
			if(!_dialogWindow) return;
			
			if(_dialogWindow.hasOwnProperty("friends")) 
			{
				_dialogWindow.friends = d;
			}
		}
		
		
		private function onLoginBtnPressed(e:Event) : void
		{
			var appLogin = facade.retrieveProxy("ApplicationLogin");
			appLogin.login();
		}
		
		
		private function onAppError(o) : void
		{
			trace("error message: "+o);
			_dialogWindow = getDialogById("error");
			if(o) _dialogWindow.message = o;
			viewComponent.addChildAt(_dialogWindow, viewComponent.numChildren-1);
			_dialogWindow.open();
		}
		
		
		private function onLoggedOut() : void
		{
			_dialogWindow = getDialogById("login");
			viewComponent.addChildAt(_dialogWindow, viewComponent.numChildren-1)
			_dialogWindow.open();
		}
		
		
		private function onLoggedIn() : void
		{
			if(_dialogWindow == getDialogById("login"))
			{
				_dialogWindow.close();
			}
		}
		
		
		private function getDialogById(id:String) : *
		{
			for(var i in _dialogs)
			{
				if(_dialogs[i].id == id) 
				{
					if(!_dialogs[i].instance) _dialogs[i].instance = new _dialogs[i].clss(this);
					addListeners(_dialogs[i].instance);
					return _dialogs[i].instance;
				}
			}
			
			return new ErrorScreen();
		}
		
		private function addListeners(s:*) : void
		{
			if(!s.hasEventListener("onLogin")) s.addEventListener("onLogin", onLoginBtnPressed);
		}

	}
}
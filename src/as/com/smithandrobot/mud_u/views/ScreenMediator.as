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
	import com.smithandrobot.mud_u.MudUGATracker;
	
	public class ScreenMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ScreenMediator";
		private var _fbProxy : FacebookDataProxy;
		private var _dataProxy : ApplicationDataProxy;
		private var _playerProxy : APIProxy;
		private var _lastScreen = null;
		private var _currentScreen = null;
		private var _screens : Array = new Array();
		private var _screenID : String;
		private var _editHistory : Array = new Array();
		
		public function ScreenMediator(viewComponent:Object):void 
		{
			super(NAME, viewComponent);
			_fbProxy = 	facade.retrieveProxy("FacebookDataProxy") as FacebookDataProxy;
			_dataProxy = facade.retrieveProxy("ApplicationDataProxy") as ApplicationDataProxy;
			_playerProxy = facade.retrieveProxy("APIProxy") as APIProxy;
			
			_screens.push({id:"home", clss:HomeScreen, instance:null, pageID: '/step1/photo-select'});
			_screens.push({id:"userPhotos"	, clss:PickUserPhotoScreen, instance:null, pageID: '/step2/user-photo'});
			_screens.push({id:"friendsPhotos", clss:PickFriendsPhotoScreen, instance:null, pageID: '/step2/friend-photo'});
			_screens.push({id:"editPhoto", clss:EditPhotoScreen, instance:null, pageID: '/step3/photo-resize'});
			_screens.push({id:"forest", clss:ForestScreen, instance:null, pageID: '/step4/mud-photo'});
			_screens.push({id:"share", clss: ShareScreen, instance:null, pageID: '/step5/share-photo'});
			_screens.push({id:"finish", clss: FinishScreen, instance:null, pageID: '/step6/mud-again'});
			_screens.push({id:"webCam", clss: WebCamScreen, instance:null, pageID: '/step2/webcam'});
		}


		//--------------------------------------
		//  MEDIATOR METHODS
		//--------------------------------------
		
		override public function handleNotification(notification:INotification):void 
		{
			switch (notification.getName())
			{
				case ApplicationFacade.FRIENDS_DATA_LOADED:
					onFriendsData(notification.getBody());
				break;
				
				case ApplicationFacade.FRIENDS_USING_APP_DATA_LOADED:
					onFriendsUsingApp(notification.getBody());
				break;
				
				case ApplicationFacade.USER_ALBUMS_LOADED:
					onUserAlbumData(notification.getBody());
				break;
				case ApplicationFacade.ALBUM_PHOTOS_LOADED:
					onAlbumPhotoData(notification.getBody());
				break;
				case ApplicationFacade.SCREEN_CHANGE:
					onProgressStateChange(notification.getBody());
					break;
				case ApplicationFacade.UNLOCK_SASPLOTCH:
					onUnlockSasplotch();
					break;
				case ApplicationFacade.PLAYER_DATA:
					onPlayerData(notification.getBody());
					break;
				case ApplicationFacade.PHOTO_UPLOADED:
            	case ApplicationFacade.PHOTO_TAGGED:
            	case ApplicationFacade.POSTS_COMPLETED:
					onShareStatusChange(notification.getName());
					break;
				default:
					break;
			}
		}
		

		override public function listNotificationInterests():Array 
		{
            return [ 
            		ApplicationFacade.INITIALIZE_SITE,
            		ApplicationFacade.FRIENDS_DATA_LOADED,
            		ApplicationFacade.FRIENDS_USING_APP_DATA_LOADED,
					ApplicationFacade.USER_ALBUMS_LOADED,
					ApplicationFacade.ALBUM_PHOTOS_LOADED,
            		ApplicationFacade.SCREEN_CHANGE,
            		ApplicationFacade.PHOTO_UPLOADED,
            		ApplicationFacade.PHOTO_TAGGED,
            		ApplicationFacade.POSTS_COMPLETED,
					ApplicationFacade.UNLOCK_SASPLOTCH,
					ApplicationFacade.PLAYER_DATA
                   ];
		}

		
		public function editHistory(e = null) : void
		{
			trace("edit history! going to: "+_editHistory[_editHistory.length-1])
			//onProgressStateChange(_editHistory[_editHistory.length-2]);
			_dataProxy.screen = _editHistory[_editHistory.length-1];
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
        protected function get scope():Sprite
        {
            return viewComponent as Sprite;
        }


		public function get appPhoto() : BitmapData { return _dataProxy.appPhotoData; };
		
		public function getEditedPhoto() : Sprite { return _dataProxy.editedPhoto; }
		
		public function getFBProxy() : FacebookDataProxy { return _fbProxy; };
		
		public function getAppProxy() : ApplicationDataProxy { return _dataProxy; };
		
		public function getAPIProxy() : APIProxy { return _playerProxy; };
		
		public function getPlayerData() : * { return _playerProxy; };
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function getFriends() : void { _fbProxy.getFriends(); }
		
		public function getFriendsUsingApplication() : void { _fbProxy.getFriendsUsingApplication(); }
		
		public function getUserAlbums() : void { _fbProxy.getUserAlbums(); }
		
		public function getAlbumPhotos(id) : void { _fbProxy.getAlbumPhotos(id); }
		
		public function getFriendsAlbums(id) : void { _fbProxy.getFriendsAlbums(id); }
		
		public function getMuddedPhoto() : Bitmap { return _dataProxy.muddedPhoto; }
		
		public function getFriendToMud() : String { return _dataProxy.friendToMud; }
		
		public function setFriendToMud(f:String) : void { _dataProxy.friendToMud = f; }
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function onScreenOut(e:Event = null) : void
		{
			_currentScreen = getScreenById(_screenID);
			scope.addChildAt(_currentScreen, scope.numChildren-1);
			_currentScreen.animateIn();
		}
		
		
		private function onProgressStateChange(i) : void
		{

			if (_screenID == i) return;
			
			addEditHistory(i);
			
			_screenID = i;
			
			if(_currentScreen) _currentScreen.animateOut();
			if(!_currentScreen) onScreenOut();

		}
		
		
		private function onFriendsData(d) : void
		{
			if(_currentScreen.hasOwnProperty("friends")) 
			{
				_currentScreen.friends = d;
			}
		}
		
		private function onFriendsUsingApp(d) : void
		{
			if(_currentScreen.hasOwnProperty("friendsUsingApp")) 
			{
				_currentScreen.friendsUsingApp = d;
			}
		}
		
		
		private function onUserAlbumData(d) : void
		{
			if(_currentScreen.hasOwnProperty("albums")) 
			{
				_currentScreen.albums = d;
			}
		}
		
		private function onAlbumPhotoData(d) : void
		{
			if(_currentScreen.hasOwnProperty("albumPhotos")) 
			{
				_currentScreen.albumPhotos = d;
				}
		}


		private function onCancelSetUp(e:Event) : void
		{
			_dataProxy.screen = "home";
		}
		
		
		private function onMudAgain(e:Event) : void
		{
			sendNotification( ApplicationFacade.STATUS_CHANGE, 1 );
			_dataProxy.screen = "home";
		}
		
		
		private function onMudSelectedFriend(e:Event) : void
		{
			sendNotification( ApplicationFacade.STATUS_CHANGE, 1 );
			_dataProxy.screen = "friendsPhotos";
		}
		
		private function onSetUpTypeChosen(e:Event) : void
		{
			var screen : String =  e.target.setupType;
			_dataProxy.screen = screen;
		}
		
		
		private function onPhotoChosen(e: Event) : void
		{
			_dataProxy.appPhotoData = e.target.bmpData;
			_dataProxy.screen = "editPhoto";	
		}
		
		private function onPhotoEdited(e:Event) : void
		{
			_dataProxy.editedPhoto = e.target.editedPhoto;
			_dataProxy.screen = "forest";
			sendNotification( ApplicationFacade.STATUS_CHANGE, 2 );
		}
		
		private function onPhotoMudded(e:Event) : void
		{
			_dataProxy.muddedPhoto = e.target.muddedPhoto;
			_dataProxy.screen = "share";
			sendNotification( ApplicationFacade.STATUS_CHANGE, 3 );
		}
		
		
		private function onFinishScreenBack(e:Event) : void
		{
			_dataProxy.screen = "share";
			sendNotification( ApplicationFacade.STATUS_CHANGE, 3 );
		}
		
		
		private function onForestBackBtn(e:Event) : void
		{
			_dataProxy.screen = "editPhoto";
			sendNotification( ApplicationFacade.STATUS_CHANGE, 1 );
		}
		
		private function onShareScreenBackBtn(e:Event) : void
		{
			_dataProxy.screen = "forest";
			sendNotification( ApplicationFacade.STATUS_CHANGE, 2 );
		}
		
		
		private function onShareScreenFinshed(e:Event) : void
		{
			_dataProxy.screen = "finish";
		}
		
		
		private function onShareStatusChange(status) : void
		{
			if(_currentScreen.hasOwnProperty("shareStatus")) 
			{
				_currentScreen.shareStatus = status;
			}
		}
		
		
		private function onScreenError(e:Event) : void
		{
			var message = null;
			if(e.target.hasOwnProperty("errorMessage")) message = e.target.errorMessage;
			sendNotification(ApplicationFacade.ERROR, message);
		}
		
		
		private function onUnlockSasplotch()
		{
			if(_currentScreen.hasOwnProperty("sasplotchLocked")) _currentScreen.sasplotchLocked = false;
		}
		
		private function onPlayerData(d) : void
		{
			
		}
		
		
		//--------------------------------------
		//  PRIVATE METHODS
		//--------------------------------------
		
		private function getScreenById(id:String) : *
		{
			for(var i in _screens)
			{
				if(_screens[i].id === id) 
				{
					if(!_screens[i].instance) _screens[i].instance = new _screens[i].clss(this);
					MudUGATracker.trackPageView(_screens[i].pageID);
					addListeners(_screens[i].instance);
					return _screens[i].instance;
				}
			}
			
			return new ErrorScreen();
		}
		
		
		private function addEditHistory(h) : void
		{
			if(h == "home" || h == "userPhotos" || h == "webCam" || h == "friendsPhotos" ) 
			{
				_editHistory.push(h);
			}
			
			if(_editHistory.length > 5) _editHistory.shift();
		}
		
		
		private function addListeners(s:*) : void
		{
			if(!s.hasEventListener("onPickPhotoCancel")) s.addEventListener("onPickPhotoCancel", onCancelSetUp);
			if(!s.hasEventListener("onSetUpTypeChosen")) s.addEventListener("onSetUpTypeChosen", onSetUpTypeChosen);
			if(!s.hasEventListener("onScreenOut")) s.addEventListener("onScreenOut", onScreenOut);
			if(!s.hasEventListener("onPhotoChosen")) s.addEventListener("onPhotoChosen", onPhotoChosen);
			if(!s.hasEventListener("onPhotoEdited")) s.addEventListener("onPhotoEdited", onPhotoEdited);
			if(!s.hasEventListener("onForestBackBtn")) s.addEventListener("onForestBackBtn", onForestBackBtn);
			if(!s.hasEventListener("onShareScreenBackBtn")) s.addEventListener("onShareScreenBackBtn", onShareScreenBackBtn);
			if(!s.hasEventListener("onPhotoMudded")) s.addEventListener("onPhotoMudded", onPhotoMudded);
			if(!s.hasEventListener("onShareScreenFinshed")) s.addEventListener("onShareScreenFinshed", onShareScreenFinshed);
			if(!s.hasEventListener("onMudAgain")) s.addEventListener("onMudAgain", onMudAgain);
			if(!s.hasEventListener("onMudSelectedFriend")) s.addEventListener("onMudSelectedFriend", onMudSelectedFriend);
			if(!s.hasEventListener("screenError")) s.addEventListener("screenError", onScreenError);
			if(!s.hasEventListener("onEditHistory")) s.addEventListener("onEditHistory", editHistory);
			if(!s.hasEventListener("onFinishScreenBack")) s.addEventListener("onFinishScreenBack", onFinishScreenBack);
		}

	}
}
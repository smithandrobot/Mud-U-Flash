package com.smithandrobot.mud_u.model
{
    import flash.system.*;
    import flash.events.*;
	import flash.display.*;
	import flash.net.*;
	
	import com.adobe.serialization.json.*;
	
    import com.smithandrobot.mud_u.ApplicationFacade;
	import com.smithandrobot.mud_u.model.ApplicationDataProxy;
	
    import org.puremvc.as3.interfaces.IProxy;
    import org.puremvc.as3.patterns.proxy.Proxy;
	
	import com.bigspaceship.utils.Out;
	import com.bigspaceship.api.facebook.OAuthBridge;
	import com.bigspaceship.api.facebook.FacebookPermissions;
	import com.bigspaceship.events.FacebookAuthEvent;
	import com.bigspaceship.api.facebook.OAuthSession;
	
	
    public class ApplicationLogin extends Proxy implements IProxy
    {
        public static const NAME:String = "ApplicationLogin";
		private var _bridge : OAuthBridge;
		private var _scope : Sprite;
		private var _perms : String = FacebookPermissions.FRIENDS_BIRTHDAY+", "+FacebookPermissions.USER_BIRTHDAY+", "+FacebookPermissions.USER_ABOUT_ME+", "+FacebookPermissions.OFFLINE_ACCESS+", "+FacebookPermissions.USER_PHOTO_VIDEO_TAGS+", "+FacebookPermissions.FRIENDS_PHOTO_VIDEO_TAGS+", "+FacebookPermissions.PUBLISH_TO_STREAM + ',' + FacebookPermissions.USER_PHOTOS + ',' + FacebookPermissions.FRIENDS_PHOTOS+ ',' + FacebookPermissions.READ_STREAM;
		private var _uid : String = null;
		private var _name : String;
		private var _started : Boolean = false;
		private var _playerData : Object = new Object();
		private var _apiProxy;
		
		private const USE_API : Boolean = true;
		
        public function ApplicationLogin( scope )
        {
            Security.loadPolicyFile( "http://graph.facebook.com/crossdomain.xml" );
            Security.loadPolicyFile( "http://muduapp.srsc.us/crossdomain.xml" );
			Security.allowDomain( "*" );
			
			super(NAME, null);
			trace("perms: "+_perms);
			Debug.trace(this, "ApplicationLogin");
			
			_scope = scope;			
			init( scope );
        }


		public function login() : void
		{
			_bridge.login( { perms:_perms } );
		}
		
		
		private function init( scope ):void
		{
			
			var lInfo = (_scope.parent) ? _scope.parent.loaderInfo : _scope.loaderInfo;
			
			_bridge = new OAuthBridge(getDebugSession());
			_bridge.setPermissions(_perms);
			_bridge.addEventListener( FacebookAuthEvent.LOGIN, onLogin, false, 0, true );
			_bridge.addEventListener( FacebookAuthEvent.LOGOUT, onLogOut, false, 0, true );
			_bridge.addEventListener( FacebookAuthEvent.LOGIN_PROCESS_START, onLogInStart, false, 0, true );
			_bridge.addEventListener( FacebookAuthEvent.LOGIN_PROCESS_COMPLETE, onLogInComplete, false, 0, true );
			_bridge.initialize( lInfo );
			if(! lInfo.parameters.session) _bridge.login( { perms:_perms } );
			
		}
		
		// MouseEvent.MOUSE_MOVE
		private function getDebugSession() : OAuthSession
		{	
			var sessionObj:Object  	= {};
			// test user	
			//sessionObj.access_token	= "172785809421346|1eb501d7a4f471087fbcfe6b-100000241798640|NfuYzoC-NwEUPkY_hDfwliC83Go";
			sessionObj.access_token	= "172785809421346%7Cd154fae6d39c8ea6ece26242-562363085%7CKb8UbheaTaWgJJAcsD5fdK_nD7Y";
			sessionObj.expires 	   	= 000000000;
			sessionObj.secret 	   	= "Sp7av4fu1nVZ7aEZSgPGZQ__";
			sessionObj.session_key 	= "2.hTY_89ILXQmmit37RcQrjA__.3600.1292533200-562363085";
			sessionObj.sig 		   	= "6486dad3a3cb667bbe31e353065051c2";
			sessionObj.uid 		   	= "562363085";
			 
			var debugSession:OAuthSession = new OAuthSession(sessionObj);
			
			return debugSession;
		}
		
		
		private function getUID() : void
		{
			if(_started) return;
			
			var req:URLRequest = new URLRequest("https://graph.facebook.com/me/?fields=id,name,birthday,gender,location&access_token="+_bridge.session.access_token);
			var uidRequest:URLLoader = new URLLoader();
			uidRequest.addEventListener(Event.COMPLETE, onUID);
			uidRequest.addEventListener(IOErrorEvent.IO_ERROR , function(e){ trace("error getting UID")});
			uidRequest.load(req);

			_started = true;
		}
		
		
		private function createPlayer(obj) : void
		{			
			var req:URLRequest = new URLRequest("http://muduapp.srsc.us/api/players/create/");
			req.method = URLRequestMethod.POST;
			
			var variables:URLVariables = new URLVariables();
			variables.token = _bridge.session.access_token;		
			req.data = variables;
			
			var userRequest:URLLoader = new URLLoader();
			userRequest.addEventListener(Event.COMPLETE, onCreatePlayer);
			userRequest.addEventListener(IOErrorEvent.IO_ERROR , function(e){ trace("Error creating player data message: "+e.text)})
			userRequest.load(req);
		}
		
		
		private function onLogin(e:Event) : void
		{
			trace(this, "onLogin event");
			onLogInComplete();
		}
		
		
		private function onLogOut(e:Event) : void
		{
			//sendNotification( ApplicationFacade.LOGOUT );
		}
		
		
		private function onLogInStart(e:Event) : void
		{
			Debug.trace(this, "onLogInStart event")
		}
		
		
		private function onLogInComplete(e:Event = null) : void
		{
			getUID();
		}
		
		
		private function onUID(e:Event) : void
		{
			_uid = JSON.decode(e.target.data).id;
			_name = JSON.decode(e.target.data).name;
			createPlayer(JSON.decode(e.target.data));
			_apiProxy = new APIProxy();
			facade.registerProxy( _apiProxy );
			startUp();

		}
		
		
		private function onCreatePlayer(e:Event) : void
		{
			trace(e.target.data);
			_playerData = JSON.decode(e.target.data);
			_apiProxy.playerData = _playerData;
			/*_playerData.photosMudded = 1;
			_playerData.photosShared = 1;
			_playerData.mudvites = 5;
			_playerData.mudprops = 5;
			_playerData.rank = 1534;
			_playerData.weekRank = 1123;
			_playerData.numberOfFriendsUsing = 12;*/
						
			sendNotification( ApplicationFacade.PLAYER_DATA, _playerData);
		}
		
		
		private function startUp(e:Event = null) : void
		{
			var fb = new FacebookDataProxy();

			_apiProxy.playerID 	= _uid;
			//apiProxy.playerData = _playerData;
			fb.token 			= _bridge.session.access_token;
			fb.sessionKey 		= _bridge.session.session_key;
			fb.uid 				= _uid;
			fb.name 			= _name;
			
			facade.registerProxy( fb );

			
			sendNotification( ApplicationFacade.INITIALIZE_SITE, _uid);
			sendNotification( ApplicationFacade.LOGGED_IN );
			
			var appModel = facade.retrieveProxy("ApplicationDataProxy");

			/*appModel.screen = "home";*/
			// appModel.screen = "share";	
			appModel.screen = "home";
		}
    }
}


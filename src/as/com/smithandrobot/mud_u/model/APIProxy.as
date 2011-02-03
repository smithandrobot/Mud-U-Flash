package com.smithandrobot.mud_u.model
{
	import 	flash.net.*;
	import 	flash.events.*;
	
	import  com.adobe.serialization.json.*;
	
    import com.smithandrobot.mud_u.ApplicationFacade;

    import org.puremvc.as3.interfaces.IProxy;
    import org.puremvc.as3.patterns.proxy.Proxy;
	
	
    public class APIProxy extends Proxy implements IProxy
    {
        public static const NAME:String = "APIProxy";
		private var _baseURL = "http://muduapp.srsc.us/api/";
		private var _userData;
		private var _sasplotchLocked = true	;
		private var _uID;
		
        public function APIProxy( )
        {
			super(NAME, null);
        }

		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get sasplotchLocked() :Boolean { return _sasplotchLocked; };
		
		public function set sasplotchLocked(b:Boolean) :void 
		{ 
			trace("API PROXY heard sasplotchLocked: "+b);
			if(_sasplotchLocked == b) return;
			_sasplotchLocked = b;
			if(!_sasplotchLocked) 
			{
				sendNotification( ApplicationFacade.UNLOCK_SASPLOTCH );
				var fb  = facade.retrieveProxy("FacebookDataProxy");
				fb.postUnlockedSasplotch();
			}
		};
		
		public function get playerData() : * { return _userData; };
		
		public function set playerData(d) : void
		{
			_userData = d;
			if(!d.hasOwnProperty("data")) return;
			if(d.data.achievements.length > 0) _sasplotchLocked = false;
			// trace("API Proxy playerData set locked: "+_uID+", _sasplotchLocked: "+_sasplotchLocked);
		}
		
		
		public function set playerID(s:String) : void
		{
			_uID = s;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		
		public function getUserData( id:String ):void
		{
			//if(_userData) { sendNotification( ApplicationFacade.PLAYER_DATA ); };
			
			var req:URLRequest = new URLRequest(_baseURL+"players/view/"+id);
			var userRequest:URLLoader = new URLLoader();
			userRequest.addEventListener(Event.COMPLETE, onUserDataLoaded);
			userRequest.addEventListener(IOErrorEvent.IO_ERROR , onAPIError)
			userRequest.load(req);
		}
		
				
		public function setAchievement(userID, achievmentID) : void
		{
			var req:URLRequest = new URLRequest(_baseURL+"achievements/create/");
			req.method = URLRequestMethod.POST;
			
 			var variables:URLVariables = new URLVariables();
            variables.facebookId = userID;
            variables.achievementId = achievmentID;

            req.data = variables;

			var userRequest:URLLoader = new URLLoader();
			userRequest.addEventListener(Event.COMPLETE, onAchievement);
			userRequest.addEventListener(IOErrorEvent.IO_ERROR , onAPIError)
			userRequest.load(req);
		}
		
		
		public function addInteraction(id:Number , interactionValue:String = "") : void
		{
			var req:URLRequest = new URLRequest(_baseURL+"interactions/create/");
			req.method = URLRequestMethod.POST;
			
 			var variables:URLVariables = new URLVariables();
            variables.facebookId = _uID;
            variables.interactionId = id;
			variables.interactionValue = interactionValue;

            req.data = variables;

			var userRequest:URLLoader = new URLLoader();
			userRequest.addEventListener(Event.COMPLETE, onInteractionResult);
			if(id == 3 || id == 8 || id == 9 || id == 4) 
			{
				getUserData(_uID);
			}
			userRequest.addEventListener(IOErrorEvent.IO_ERROR , onAPIError)
			userRequest.load(req);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		private function onUserDataLoaded(e:Event = null) : void
		{
			_userData = JSON.decode(e.target.data);
		   	_userData.photosMudded = 2;
		   	_userData.photosShared = 0;
		   	_userData.mudvites = 6;
		   	_userData.mudprops = 8;
		   	_userData.rank = 15340;
		   	_userData.weekRank = 120;
			_userData.friendsData = [{id:3417915, rank:14}, {id:500041832, rank:2}, {id:500042807, rank:14}];
			sendNotification( ApplicationFacade.PLAYER_DATA, _userData );
		}
		
		
		private function onAchievement(e:Event) : void
		{
			trace("api achievment: "+e.target.data);
		}
		
		// match
		
		private function onInteractionResult(e:Event)  :void
		{
			trace("interaction result: "+e.target.data);
		}
		
		
		private function onAPIError(e:IOErrorEvent) : void
		{
			trace("API ERROR")
		}
		//-----------------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS         
		//-----------------------------------------------
		
		

		
		
    }
}


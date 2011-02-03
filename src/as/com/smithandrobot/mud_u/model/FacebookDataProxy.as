package com.smithandrobot.mud_u.model
{
	import flash.events.*;	
	import flash.net.*;
    import flash.system.*;
	import flash.display.*;
	import flash.utils.ByteArray;
	
	import com.adobe.serialization.json.*;
	import com.adobe.images.JPGEncoder;
	
	import com.bigspaceship.utils.Out;
	
    import com.smithandrobot.mud_u.ApplicationFacade;

    import org.puremvc.as3.interfaces.IProxy;
    import org.puremvc.as3.patterns.proxy.Proxy;
	
	import ru.inspirit.net.events.MultipartURLLoaderEvent;
	import ru.inspirit.net.MultipartURLLoader;
	
    public class FacebookDataProxy extends Proxy implements IProxy
    {
        public static const NAME:String 	= "FacebookDataProxy";
		protected var _friends 				: Object = null;
		private var _friendID				: String;
		protected var _userAlbums 			: Object = null;
		protected var _friendsAlbums		: Object = null;
		protected var _token 				: String;
		protected var _sessionKey 			: String;
		protected var _friendsUsingAppData 	: Object;
		protected var _photoTags 			: *;
		protected var _uid					: String;
		protected var _name					: String;
		protected var _photoLink			: String;
		protected var _photoSmall			: String;
		protected var _debug				= false;
		
        public function FacebookDataProxy()
        {
            Security.loadPolicyFile( "http://graph.facebook.com/crossdomain.xml" );
			Security.allowDomain( "*" );
			super(NAME, null);
        }
		
		public function get friends() : Object { return _friends; };
		
		public function set token(s:String) : void { _token = s; }
		
		public function set sessionKey(s:String) : void { _sessionKey = s; }
		
		public function set uid(uid:String) : void { _uid = uid; };
		public function get uid() : String { return _uid; };
		
		public function set name(n:String) : void { _name = n; };
		public function get name() : String { return _name; };
		

		
		public function getFriends( ):void
		{
			if(_friends) 
			{
				sendNotification( ApplicationFacade.FRIENDS_DATA_LOADED, _friends);
				return;
			}else{
				trace("getting friends forst time!")
				var req:URLRequest = new URLRequest("https://graph.facebook.com/me/friends?fields=name,picture,id&access_token=" + _token);
				var friendsRequest:URLLoader = new URLLoader();
				friendsRequest.addEventListener(Event.COMPLETE, onFriendsLoaded);
				friendsRequest.addEventListener(IOErrorEvent.IO_ERROR , onFBLoadError);
				friendsRequest.load(req);
				getFriendsUsingApplication();
			}
		}
		
		
		public function getUserAlbums():void
		{
			if(_userAlbums) 
			{
				sendNotification( ApplicationFacade.USER_ALBUMS_LOADED, _userAlbums);
				return;
			}
			
			var req:URLRequest = new URLRequest("https://graph.facebook.com/me/albums?access_token=" + _token);
			var albumsRequest:URLLoader = new URLLoader();
			albumsRequest.addEventListener(Event.COMPLETE, onUserAlbumsLoaded);
			albumsRequest.addEventListener(IOErrorEvent.IO_ERROR , onFBLoadError)
			albumsRequest.load(req);
		}
		
		
		public function getFriendsAlbums( id ):void
		{
			_friendID = id;
			var req:URLRequest = new URLRequest("https://graph.facebook.com/"+id+"/albums?access_token=" + _token);
			var albumsRequest:URLLoader = new URLLoader();
			albumsRequest.addEventListener(Event.COMPLETE, onFriendsAlbumsLoaded);
			albumsRequest.addEventListener(IOErrorEvent.IO_ERROR , onFBLoadError)
			albumsRequest.load(req);
		}
		
		
		public function getAlbumPhotos( id ):void
		{
			var req:URLRequest = new URLRequest("https://graph.facebook.com/"+id+"/photos?access_token=" + _token);
			var albumPhotosRequest:URLLoader = new URLLoader();
			albumPhotosRequest.addEventListener(Event.COMPLETE, onAlbumsPhotosLoaded);
			albumPhotosRequest.addEventListener(IOErrorEvent.IO_ERROR , onFBLoadError)
			albumPhotosRequest.load(req);
		}
		
		
		
		public function getFriendsUsingApplication() : void
		{
			if(_friendsUsingAppData) 
			{
				sendNotification( ApplicationFacade.FRIENDS_USING_APP_DATA_LOADED, _friendsUsingAppData);
				return;
			}
			var req:URLRequest = new URLRequest("https://api.facebook.com/method/friends.getAppUsers?access_token="+ _token +"&format=json");
			trace("friends using app:\r"+req.url);
			var friendsUsingAppRequest:URLLoader = new URLLoader();
			friendsUsingAppRequest.addEventListener(Event.COMPLETE, onFriendsUsingAppLoaded);
			friendsUsingAppRequest.addEventListener(IOErrorEvent.IO_ERROR , onFBLoadError)
			friendsUsingAppRequest.load(req);
		}
		
		
		public function postToWall(id: String = "me", data:Object = null) : void
		{
			if(_debug) 
			{
				onPostedToWall();
				return;
			}
			
			var ml:MultipartURLLoader = new MultipartURLLoader();
			var firstName = _name.split(" ")[0];
			ml.addEventListener(Event.COMPLETE, onPostedToWall);
			ml.addEventListener(MultipartURLLoaderEvent.DATA_PREPARE_COMPLETE, function(e){e.target.startLoad();});
			ml.addEventListener(IOErrorEvent.IO_ERROR, function(e){trace("error posting to wall: "+e)} )
			ml.addVariable("access_token", _token);
			if(_photoLink) ml.addVariable("actions", JSON.encode({name: "View the Mudded Photo", link: _photoLink}));
			ml.addVariable("picture", "http://c0374997.cdn2.cloudfiles.rackspacecloud.com/wall_post_icon.png");
			ml.addVariable("message", "Check out this photo I mudded at Mud U. http://apps.facebook.com/muduapp/");
			ml.addVariable("name","View "+firstName+"'s Mudded Photo");
			if(_photoLink) ml.addVariable("link", _photoLink);
			ml.addVariable("caption","Mud your own photo");
			ml.addVariable("description", "Mud U. Mud photos of yourself and your friends. Then share them everywhere.");
			ml.dataFormat = URLLoaderDataFormat.TEXT;
			ml.load("https://graph.facebook.com/"+id+"/feed?access_token="+_token, true);
		}
		
		
		public function postIMuddedActionToWall(id: String = "me", data:Object = null) : void
		{
			if(_debug) 
			{
				//onPostedToWall();
				return;
			}
			
			var ml:MultipartURLLoader = new MultipartURLLoader();
			var firstName = _name.split(" ")[0];
			ml.addEventListener(Event.COMPLETE, onPostedToWall);
			ml.addEventListener(MultipartURLLoaderEvent.DATA_PREPARE_COMPLETE, function(e){e.target.startLoad();});
			ml.addEventListener(IOErrorEvent.IO_ERROR, function(e){trace("error posting to wall: "+e)} )
			ml.addVariable("access_token", _token);
			if(_photoLink) ml.addVariable("actions", JSON.encode({name: "View the Mudded Photo", link: _photoLink}));
			ml.addVariable("picture", "http://c0374997.cdn2.cloudfiles.rackspacecloud.com/wall_post_icon.png");
			ml.addVariable("message", "Check out this photo I mudded at Mud U. http://apps.facebook.com/muduapp/");
			ml.addVariable("name","View "+firstName+"'s Mudded Photo");
			if(_photoLink) ml.addVariable("link", _photoLink);
			ml.addVariable("caption","Mud your own photo");
			ml.addVariable("description", "Mud U. Mud photos of yourself and your friends. Then share them everywhere.");
			ml.dataFormat = URLLoaderDataFormat.TEXT;
			ml.load("https://graph.facebook.com/me/feed?access_token="+_token, true);
		}
		
		
		public function postUnlockedSasplotch() : void
		{
			if(_debug) 
			{
				return;
			}
			
			var ml:MultipartURLLoader = new MultipartURLLoader();
			ml.addEventListener(Event.COMPLETE, onPostedToWall);
			ml.addEventListener(MultipartURLLoaderEvent.DATA_PREPARE_COMPLETE, function(e){e.target.startLoad();});
			ml.addEventListener(IOErrorEvent.IO_ERROR, function(e){trace("error posting sasplotch teaser to wall: "+e)} )
			ml.addVariable("access_token", _token);
			ml.addVariable("actions", JSON.encode({name: "Meet Sasplotch", link: "http://apps.facebook.com/muduapp/"}));
			ml.addVariable("picture", "http://c0374997.cdn2.cloudfiles.rackspacecloud.com/sasplotch_wall_90x90.png");
			ml.addVariable("message", "");
			ml.addVariable("name","I unlocked Sasplotch.");
			ml.addVariable("link", "http://apps.facebook.com/muduapp/");
			ml.addVariable("caption","Mud a photo at Mud U. It will make sense.");
			ml.addVariable("description", "");
			ml.dataFormat = URLLoaderDataFormat.TEXT;
			ml.load("https://graph.facebook.com/me/feed?access_token="+_token, true);
		}
		
		
		public function uploadPhoto(bmpData:BitmapData = null, tags = null) : void
		{
			if(_debug) 
			{
				_photoTags = tags;
				onPhotoUploadedComplete();
				return;
			}
			
			if(bmpData == null) bmpData = new Mud();
			_photoTags = tags;
			var ml:MultipartURLLoader = new MultipartURLLoader();
			ml.addEventListener(Event.COMPLETE, onPhotoUploadedComplete);
			ml.addEventListener(MultipartURLLoaderEvent.DATA_PREPARE_COMPLETE, function(e){e.target.startLoad();});
			ml.addEventListener(IOErrorEvent.IO_ERROR, onFBLoadError )
			
			ml.dataFormat = URLLoaderDataFormat.TEXT;
			//_mc.addChild(bmp);
			
			var j_encoder:JPGEncoder = new JPGEncoder(90);

			var img:ByteArray = j_encoder.encode(bmpData);
			ml.addVariable('caption', 'Uploaded From Mud U Application - http://apps.facebook.com/muduapp');
			ml.addFile(img, 'img.png', 'image');
			ml.load("https://api.facebook.com/method/photos.upload?access_token="+_token+"&format=json", true);
		}
		
		
		private function makeProfilePicture(bmpData:BitmapData) : void
		{
			 
		}
		
		
		private function tagPhoto(id:String) : void
		{
			if(_debug) 
			{
				onPhotoTagged();
				return;
			}
			
			var total = _photoTags.length-1;
			var i :int = 0;
			var tags = new Array();
			for(i; i<= total;i++)
			{
				tags.push({x:0,y:0, tag_uid:_photoTags[i].id});
			}
			
			
			var req:URLRequest = new URLRequest("https://api.facebook.com/method/photos.addTag?pid="+id+"&tags="+JSON.encode(tags)+"&access_token="+_token+"&owner_uid="+_uid+"&format=json");

			var tagRequest:URLLoader = new URLLoader();
			tagRequest.addEventListener(Event.COMPLETE, onPhotoTagged);
			tagRequest.addEventListener(IOErrorEvent.IO_ERROR , onFBLoadError)
			tagRequest.load(req);
		}
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		private function onFriendsLoaded(e:Event = null) : void
		{
			_friends = JSON.decode(e.target.data).data;
			_friends.sortOn("name", Array.CASEINSENSITIVE);
			sendNotification( ApplicationFacade.FRIENDS_DATA_LOADED, _friends);
		}
		
		
		private function onFriendsAlbumsLoaded(e:Event = null) : void
		{
			if(JSON.decode(e.target.data).data.length == 0)
			{
				_friendsAlbums = [{
						name:"Profile Picure (1)", 
						photosPrivate: true, 
						id:_friendID, 
						picture:"https://graph.facebook.com/"+_friendID+"/picture?type=large&access_token=" + _token,
						source:"https://graph.facebook.com/"+_friendID+"/picture?type=large&access_token=" + _token
						}];
				sendNotification( ApplicationFacade.USER_ALBUMS_LOADED, _friendsAlbums);
			}else{
				_friendsAlbums = JSON.decode(e.target.data).data;
				_friendsAlbums.sortOn("name", Array.CASEINSENSITIVE);
				sendNotification( ApplicationFacade.USER_ALBUMS_LOADED, _friendsAlbums);
			}
		}
		
		
		private function onUserAlbumsLoaded(e:Event = null) : void
		{
			_userAlbums = JSON.decode(e.target.data).data;
			_userAlbums.sortOn("name", Array.CASEINSENSITIVE);
			sendNotification( ApplicationFacade.USER_ALBUMS_LOADED, _userAlbums);
		}
		
		
		private function onAlbumsPhotosLoaded(e:Event = null) : void
		{
			var albumPhotos = JSON.decode(e.target.data).data;
			sendNotification( ApplicationFacade.ALBUM_PHOTOS_LOADED, albumPhotos);
		}
		
		
		private function onFriendsUsingAppLoaded(e:Event) : void
		{
			_friendsUsingAppData = JSON.decode(e.target.data);
			sendNotification( ApplicationFacade.FRIENDS_USING_APP_DATA_LOADED, _friendsUsingAppData);
		}
		
		
		private function onPhotoUploadedComplete(e:Event = null) : void
		{
			if(_debug)
			{
				sendNotification( ApplicationFacade.PHOTO_UPLOADED );
				if(_photoTags) 
				{
					trace("taggging photos")
					tagPhoto(null);
				}
				return;
			}
			
			var obj = JSON.decode(e.target.response);
			var pid = obj.pid;
			_photoLink = obj.link;
			_photoSmall = obj.src_small;
			sendNotification( ApplicationFacade.PHOTO_UPLOADED );
			postIMuddedActionToWall();
			if(_photoTags) tagPhoto(pid);
		}
		
		
		private function onPhotoTagged(e:Event = null) : void
		{
			sendNotification( ApplicationFacade.PHOTO_TAGGED );
		}
		
		
		private function onPostedToWall(e:Event = null) : void
		{
			sendNotification( ApplicationFacade.POSTS_COMPLETED );
		}
		
		
		private function onFBLoadError(e:Event) : void
		{
			var error = JSON.decode(e.target.data);
			handleFBError("Error contacting Facebook.");
		}
		
		
		private function handleFBError(fbError) : void
		{
			switch(fbError.error.type)
			{
				case "OAuthException":
					Out.info(this, "OAUthError error: "+fbError.error.message);
					sendNotification( ApplicationFacade.ERROR,  {message:"Sorry, your application session has expired or there is an authorization error.", type:"fatal"});
					break;
			}
		}
    }
}


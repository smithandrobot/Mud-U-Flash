package com.smithandrobot.mud_u.views.ui 
{

	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.Point;
	
	import com.greensock.*;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	
	import com.smithandrobot.mud_u.views.ui.*;
	import com.smithandrobot.mud_u.ApplicationFacade;
	
	public class ShareScreenFacebookStatus extends Sprite 
	{
		
		private var _shareScreen : *;
		private var _tags 		 : * = false;
		private var _posts 		 : *;
		private var _makeProfile : *;
		private var _addToGallery : *;
		private var _fbproxy : *;
		private var _loader : LoaderPercent;
		private var _totalActions : int = 3;
		private var _actions : Object = new Object();
		private var _photo : BitmapData;
		private var _appProxy:*;
		private var _apiProxy:*;
		
		public function ShareScreenFacebookStatus(shareScreen)
		{
			alpha 		 = 0;
			_shareScreen = shareScreen;
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			_loader = addChild(new LoaderPercent(this)) as LoaderPercent;
			_loader.x = 382;
			_loader.y = 332;
			_loader.start();
			_loader.percent = 0;
			visible = false;		
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function set fbProxy(fb) : void { _fbproxy = fb; };
		
		public function set appProxy(ap) : void { _appProxy = ap; };
		
		public function set apiProxy(ap) : void { _apiProxy = ap; };
			
		public function set tags(t) : void 
		{ 
			_tags = t; 
		};
			
		public function set posts(p) : void { _posts = p; };
		
		public function set photo(b:BitmapData) : void { _photo = b; };
		
		public function set makeProfilePhoto(p:Boolean) : void { _makeProfile = p };
		
		public function set addToGallery(a: Boolean) : void { _addToGallery = a; };
		
		private function set action(i:int) : void { _loader.percent = i/_totalActions; };
				
		public function set fbstatus(s:String) : void
		{
			switch(s)
			{
				case ApplicationFacade.PHOTO_UPLOADED :
					trace("ShareScreenFacebookStatus - photo uploaded");
					_actions.photoUploadedToUserAlbum = true;
					_apiProxy.addInteraction(8, "uploaded photo");
					if(_tags) tagPhoto();
					if(!_tags && _posts) postToWall();
					if(!_tags && !_posts) fbstatus = ApplicationFacade.POSTS_COMPLETED;
					
					break;
				case ApplicationFacade.PHOTO_TAGGED :
					action = 2;
					_actions.photoTagged = true;
					if(_posts) 
					{
						status.text = "Posting to Your Friend's Wall";
						postToWall();
					}else{
						fbstatus = ApplicationFacade.POSTS_COMPLETED;
					}
					break;
				case ApplicationFacade.POSTS_COMPLETED :
					if(_posts) 
					{
						_actions.postedToWall = true;
						_apiProxy.addInteraction(9, "shared photo");
					}
					action = 3;
					animateOut();
					break;
				default:
					trace("unknown status passed to "+this);
					break;
			}
		}
		
		
		public function start() : void
		{
			trace("_posts: "+_posts)
			trace("_tags: "+_tags)
			trace("\r")
			TweenMax.to(this, .2, {autoAlpha:1});
			resetActions();
			_loader.percent = 0;
			_loader.start();
			status.text = "Uploading Photo";
			_fbproxy.uploadPhoto(_photo, _tags);
		}
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		private function onAdded(e:Event) : void
		{			
			TweenMax.to(this, .2, {alpha:1});
		}
		
		
		private function tagPhoto() : void
		{
			if(!_tags)
			{
				fbstatus = ApplicationFacade.PHOTO_TAGGED;
			}else{
				status.text = "Tagging Photo";
			}
		}
		
		
		private function postToWall() : void
		{
			if(!_posts)
			{
				fbstatus = ApplicationFacade.POSTS_COMPLETED;
			}else{		
		   		status.text = "Posting to Your Friend's Wall";
		   		_fbproxy.postToWall(_posts);
			}
		}
		
		
		private function animateOut() : void
		{
	 		TweenMax.to(this, .2, {alpha:0, onComplete:remove, overwrite:1});
		}
		
		
		public function remove()
		{
			trace("Actions:"+
			"\rpostedToWall: "+_actions.postedToWall+
			"\rphotoTagged: "+_actions.photoTagged+
			"\rphotoUploadedToUserAlbum: "+_actions.photoUploadedToUserAlbum+"\r");
			_appProxy.shareActions = _actions;
			dispatchEvent(new Event("onShareCompleted", true));
			parent.removeChild(this);
		}
		
		
		private function resetActions() : void
		{
			_actions.postedToWall = false;
			_actions.photoTagged = false;
			_actions.photoUploadedToUserAlbum = false;

			/*_tags 		  = false;
			_posts 		  = false;
			_makeProfile  = false;
			_addToGallery = false;*/
		}
		
	}

}


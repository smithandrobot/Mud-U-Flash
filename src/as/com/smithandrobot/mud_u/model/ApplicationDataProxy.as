package com.smithandrobot.mud_u.model
{
	import flash.display.*;
	import flash.external.*;
	
    import com.smithandrobot.mud_u.ApplicationFacade;

    import org.puremvc.as3.interfaces.IProxy;
    import org.puremvc.as3.patterns.proxy.Proxy;
	
	import com.bigspaceship.utils.Out;
	import com.bigspaceship.api.facebook.OAuthBridge;
	import com.bigspaceship.api.facebook.FacebookPermissions;
	import com.bigspaceship.events.FacebookAuthEvent;
	import com.bigspaceship.api.facebook.OAuthSession;
	
    public class ApplicationDataProxy extends Proxy implements IProxy
    {
        public static const NAME:String = "ApplicationDataProxy";
		private var _scope 	: Sprite;
		private var _screenID : String;
		private var _appPhotoData : BitmapData;
		private var _editedPhoto : Sprite = new DebugPhoto();
		private var _muddedPhoto : Bitmap = new Bitmap(new Mud());
		private var _friendToMud : String// = "500042807"; // 100000241798640 // 562363085 // 500042807
		private var _shareActions : Object;
		
        public function ApplicationDataProxy( scope )
        {
			super(NAME, null);
			_scope = scope;
			_shareActions = new Object();
			_shareActions.postedToWall = true;
			_shareActions.photoTagged = true;
			_shareActions.photoUploadedToUserAlbum = true;
			_shareActions.photoUploadedToMudUAlbum = false;
        }


		public function set screen(s:String) : void 
		{
			if(_screenID == s) return;
			_screenID = s;

			sendNotification( ApplicationFacade.SCREEN_CHANGE, _screenID ); 
		};
		
		
		public function set appPhotoData(b:BitmapData) : void { _appPhotoData = b; };
		public function get appPhotoData() : BitmapData { return _appPhotoData; };
		
		public function set editedPhoto(b:Sprite) : void { _editedPhoto = b; };
		public function get editedPhoto() : Sprite { return _editedPhoto; };
		
		public function set muddedPhoto(b:Bitmap) : void { _muddedPhoto = b; };
		public function get muddedPhoto() : Bitmap { return _muddedPhoto; };
		
		public function set friendToMud(f:String) : void { _friendToMud = f; };
		public function get friendToMud() : String { return _friendToMud; };
		
		public function set shareActions(o:Object) : void { _shareActions = o; };
		public function get shareActions() : Object { return _shareActions; };
		
    }


}
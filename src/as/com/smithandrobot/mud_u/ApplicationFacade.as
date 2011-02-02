package com.smithandrobot.mud_u
{
	import flash.display.Sprite;
    import org.puremvc.as3.interfaces.IFacade;
    import org.puremvc.as3.patterns.facade.Facade;
	
	import com.smithandrobot.mud_u.controller.*;
	import com.smithandrobot.mud_u.MudU;
	
	public class ApplicationFacade extends Facade implements IFacade
	{

        public static const STARTUP : String				= "startup";
        public static const INITIALIZE_SITE : String  		= "initializeApplication";
        public static const FRIENDS_DATA_LOADED : String 	= "onFriendsDataLoaded";
        public static const FRIENDS_USING_APP_DATA_LOADED 	= "onFriendsUsingAppDataLoaded";
        public static const ERROR : String					= "onAppError";
        public static const SCREEN_CHANGE : String			= "onScreenChange";
        public static const USER_ALBUMS_LOADED : String		= "onUserAlbumsLoaded";
        public static const ALBUM_PHOTOS_LOADED : String	= "onAlbumPhotosLoaded";
        public static const STATUS_CHANGE : String			= "onStatusChange";
        public static const OPEN_DIALOG : String			= "onOpenDialog";
		public static const LOGOUT : String					= "onLogout";
		public static const LOGGED_IN : String				= "onLoggedIn";
		public static const PHOTO_UPLOADED : String			= "onPhotoUploaded";
		public static const PHOTO_TAGGED : String			= "onPhotoTagged";
		public static const POSTS_COMPLETED : String		= "onPostsComplete";
		public static const UNLOCK_SASPLOTCH : String		= "onUnlockSasaplotch";
		public static const PLAYER_DATA : String			= "onPlayerData";
		
		
        public static function getInstance() : ApplicationFacade 
        {
            if ( instance == null ) instance = new ApplicationFacade();
            return instance as ApplicationFacade;
        }

	
        public function startup( scope:Sprite ):void
        {
        	sendNotification( STARTUP, scope );
        }
		
        override protected function initializeController() : void 
        {
            super.initializeController(); 
            registerCommand( STARTUP, StartupCommand );
        };

	}

}
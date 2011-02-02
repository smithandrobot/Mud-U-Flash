

package com.smithandrobot.mud_u.views 
{

/**
 *	Class description.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0
 *	@author David Ford
 *	@since  28.07.2009
 */
    import flash.display.*;
    import flash.events.*;
	import flash.utils.*;

	/*import com.greensock.TweenNano;*/
	
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.Mediator;

	import com.smithandrobot.mud_u.ApplicationFacade;
	import com.smithandrobot.mud_u.views.*;
	import com.smithandrobot.mud_u.views.ui.*;
	import com.smithandrobot.mud_u.model.*;
	
	public class StageMediator extends Mediator implements IMediator
	{


        public static const NAME:String 	= "StageMediator";
		private var _model					: ApplicationDataProxy;
		
		
		
		public function StageMediator( sprite )
		{
            super( NAME, sprite );
            facade.registerMediator( new DialogMediator( scope ) );
			scope.addEventListener("onUserInvite", onUserInvite);
		}
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
        override public function listNotificationInterests():Array 
        {
            return [ 
            		ApplicationFacade.INITIALIZE_SITE
                   ];
        }


        override public function handleNotification( note:INotification ):void 
        {
            switch ( note.getName() ) 
            {
                case ApplicationFacade.INITIALIZE_SITE:     	
					initializeSite(note.getBody());
                  	break;
                default:
                  	break;
            }
        }


		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function onUserInvite(e:Event = null) : void
		{
			var f = facade.retrieveProxy("APIProxy") as APIProxy;
			f.sasplotchLocked = false;
		}
		
		
		//--------------------------------------
		//  PROTECTED/PRIVATE METHODS
		//--------------------------------------
		
		
        protected function get scope():Sprite
        {
            return viewComponent as Sprite;
        }
		
		
        private function initializeSite(o:Object):void
        {	
			var statusBar = scope.getChildByName("statusBar") as StatusBar;
			var d = scope.addChild(new Dashboard()) as Dashboard;
			
			statusBar.uID = o;
            facade.registerMediator( new ScreenMediator( scope ) );
            facade.registerMediator( new StatusMediator( statusBar ) );
            facade.registerMediator( new DashboardMediator( d ) );
			scope.dispatchEvent(new Event("onSiteInitialized", true));
        }
		
	}

}
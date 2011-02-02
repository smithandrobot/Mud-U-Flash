package com.smithandrobot.mud_u 
{

	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.Point;
	import flash.net.*;
	
	import com.bigspaceship.api.facebook.FacebookPermissions;
	
	import com.greensock.*;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	
	public class TestAccountCreator extends Sprite 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		
		/**
		 *	@constructor
		 */
		public function TestAccountCreator()
		{
			trace("TestAccountCreator");
			var apID;
			// pinkiering
			apID = "131296520253246";
			
			// mud u dev
			//apID = "172785809421346";
			
			var req:URLRequest = new URLRequest("https://graph.facebook.com/"+apID+"/accounts/test-users");
			req.method = URLRequestMethod.POST;
			trace("req: "+req.url)
 			var variables:URLVariables = new URLVariables();
            variables.installed = true;
            variables.permissions = FacebookPermissions.FRIENDS_BIRTHDAY+", "+FacebookPermissions.USER_BIRTHDAY+", "+FacebookPermissions.USER_ABOUT_ME+", "+FacebookPermissions.OFFLINE_ACCESS+", "+FacebookPermissions.USER_PHOTO_VIDEO_TAGS+", "+FacebookPermissions.FRIENDS_PHOTO_VIDEO_TAGS+", "+FacebookPermissions.PUBLISH_TO_STREAM + ',' + FacebookPermissions.USER_PHOTOS + ',' + FacebookPermissions.FRIENDS_PHOTOS+ ',' + FacebookPermissions.READ_STREAM;
			variables.access_token = "131296520253246|ae1d4f5df91267a5b300f34b-100000241798640|rr1QmKnUcRZ4RnDMBzVI0xnRfbk";

            req.data = variables;

			var userRequest:URLLoader = new URLLoader();
			userRequest.addEventListener(Event.COMPLETE, onTestUserResult);
			userRequest.addEventListener(IOErrorEvent.IO_ERROR , function(e){trace("ERROR: "+e.text)})
			userRequest.load(req);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function onTestUserResult(e) : void
		{
			trace("test user result:\r"+e.target.data)
		}
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}

}


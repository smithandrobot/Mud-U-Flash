package com.smithandrobot.utils
{

	import flash.system.Security;
	import flash.system.Capabilities;
	import flash.net.LocalConnection;

	public class Environment{
			
		public static function get IS_IN_BROWSER():Boolean 
		{
			return (Capabilities.playerType == "PlugIn" || Capabilities.playerType == "ActiveX");
		}
		
		
		public static function get IS_LOCAL():Boolean 
		{
			return (Capabilities.playerType == "External" || Capabilities.playerType == "StandAlone");
		}
	
	
		public static function get DOMAIN():String
		{
			return new LocalConnection().domain;
		}


		public static function get IS_IN_AIR():Boolean 
		{
			return Capabilities.playerType == "Desktop";
		}
		
		
		public static function get IS_ON_SERVER():Boolean 
		{
			return Security.sandboxType == Security.REMOTE;
		}
	}
}
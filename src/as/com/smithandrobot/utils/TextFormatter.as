package com.smithandrobot.utils 
{

/**
 *	Class description.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0
 *	@author David Ford
 *	@since  06.08.2009
 */
	import flash.text.TextFormat;

	public class TextFormatter 
	{

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private static var _lang	: String = "en";
		private static var _format 	: TextFormat;
		
		public function TextFormatter()
		{

		}

		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public static function set language(i:String) : void { _lang = i; };

		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public static function getFormatObject(type = "regular")
		{
			return createFormat(type);
		}
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private static function createFormat(type = "regular")
		{
			var format 		= new TextFormat();
			format.font 	= getFont(type); //(_lang == "en") ? new HNeue().fontName : "_sans";
			format.color 	= 0xFFFFFF;
			format.leading = 0;
			format.bold		= (type == "bold") ? true : false;
			format.size 	= 22;
			format.align 	= "left";
			
			return format
		}
		
		private static function getFont(type)
		{
			if(_lang != "en") return "_sans";
			
			if(type == "regular") return new HNeueReg().fontName;
			if(type == "bold") return new HNeue().fontName;
		}
	}

}




package com.smithandrobot.utils 
{

/**
 *	Class description.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0
 *	@author David Ford
 *	@since  03.06.2010
 */
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class TextEllipses
	{

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------


		public function TextEllipses()
		{

		}

		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		public static function trim(textfield,maxwidth)
		{
			if(textfield.width <= maxwidth) return;
			
			var orgText = textfield.text;
			var pos = textfield.text.length;
			var newText;
			
			while(textfield.width > maxwidth)
			{
				newText = orgText.slice(0, pos);
				textfield.text = newText;
				textfield.appendText("...");
				textfield.autoSize="left";
				--pos;
			}
			
			
		}
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}

}


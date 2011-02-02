
package com.smithandrobot.events 
{

	import flash.events.Event;
	
	/**
	 *	Event subclass description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author David Ford
	 *	@since  01.07.2009
	 */
	public class XMLLoaderEvent extends Event {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const XML_LOADED:String = "onXMLLoaded";
		private var _data : XML;
		/**
		 *	@constructor
		 */
		public function XMLLoaderEvent( type:String, data: XML, bubbles:Boolean=true, cancelable:Boolean=false )
		{
			super(type, bubbles, cancelable);
			_data = data;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get data() : XML { return _data; };
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		override public function clone():Event
		{
			return new XMLLoaderEvent(type, data, bubbles, cancelable);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}

}


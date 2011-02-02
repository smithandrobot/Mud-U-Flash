
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
	public class FileLoaderEvent extends Event 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const FILE_LOADED:String = "onFileLoaded";
		private var _data : Object;
		/**
		 *	@constructor
		 */
		public function FileLoaderEvent( type:String, data: Object, bubbles:Boolean=true, cancelable:Boolean=false )
		{
			super(type, bubbles, cancelable);
			_data = data;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get data() : Object { return _data; };
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		override public function clone():Event
		{
			return new FileLoaderEvent(type, data, bubbles, cancelable);
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


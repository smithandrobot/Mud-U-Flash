

package com.smithandrobot.utils {

/**
 *	Class description.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0
 *	@author David Ford
 *	@since  13.04.2009
 */
	import flash.events.*;
	import flash.net.*
	
	public class XMLLoader extends EventDispatcher 
	{

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _file : String;
		private var _loader : URLLoader;
		private var _xmlData : XML;
		
		public function XMLLoader(){}

		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function set file(f:String) : void
		{
			_file = f;
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, xmlComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR , onIOError);
			_loader.addEventListener(ProgressEvent.PROGRESS, progress);
			_loader.load(new URLRequest(f));
		}

		
		public function get xmlData() : XML
		{
			return _xmlData;
		}
		
		
		private function xmlComplete(e:Event)
		{
			_loader.removeEventListener(Event.COMPLETE, xmlComplete);
 			_xmlData = new XML(e.target.data);
			dispatchEvent(new Event(Event.COMPLETE));
		}


		private function progress(e:ProgressEvent)
		{
			/*trace(e.bytesLoaded);
			trace(e.bytesTotal);*/
		}
		
		private function onIOError(e:IOErrorEvent) : void
		{
			trace("error in xml loader");
			dispatchEvent(new Event("couldNotFindFile"));
		}
	}

}


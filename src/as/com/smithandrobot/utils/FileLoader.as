

package com.smithandrobot.utils 
{
	import flash.net.URLRequest;
	import flash.net.*;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	
	public class FileLoader extends EventDispatcher 
	{


		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------

		private var _file 		: String;
		private var _loader 	: Loader;
		private var _files		: Array;
		private var _cacheFiles	: Boolean = false;
		private var _content	: *;
		private var _sameDomain : Boolean = false;
		
		public function FileLoader()
		{
			if(_cacheFiles) _files = new Array();
		}

		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		
		public function set file(f:String) : void
		{
			if(f=="" || f==null) 
			{
				trace("No files passed to file loader!")
				return;
			}
			
			_file = f;

			var cachedFile;
			
			if(_cacheFiles)
			{
				if(cachedFile == checkIfFileLoaded(f))
				{
					_content = cachedFile;
					dispatchEvent(new Event(Event.COMPLETE));
				}else{
					startLoad(f);

				}
			}else{
				startLoad(f);
			}
			
		}
		
		
		public function get content() : * { return _content };
		public function set sameDomain(b:Boolean) : void { _sameDomain = b; };
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		

		private function startLoad(f)
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.INIT, onCompleteHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR , onErrorHandler);
			/*
		var separateDefinitions:LoaderContext = new LoaderContext();
		separateDefinitions.applicationDomain = new ApplicationDomain();
			*/
			var context:LoaderContext = new LoaderContext();
			context.applicationDomain = (_sameDomain) ? new ApplicationDomain(ApplicationDomain.currentDomain) : new ApplicationDomain();
			_loader.load(new URLRequest(_file), context);
		}
		
		
		private function onOpen(loadEvent:Event)
		{
			var file = loadEvent.target.loader.contentLoaderInfo.url;
		}
		
		
		private function onCompleteHandler(loadEvent:Event)
		{
				_content = loadEvent.currentTarget.content;
				_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
				if(_cacheFiles) _files.push({file:_file, content: _content});
				
				dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
		private function onProgressHandler(mProgress:ProgressEvent)
		{
			var percent:Number = mProgress.bytesLoaded/mProgress.bytesTotal;
		}
		
		
		private function checkIfFileLoaded(f)
		{
			for (var i in _files)
			{
				if(_files[i].file == f) return _files[i].file
			}
			
			return null;
		}
		
		
		private function onErrorHandler(e:IOErrorEvent)
		{
			trace("there is an error: "+e);
		}
		
	}

}


package com.smithandrobot.mud_u.views.ui 
{

	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.*;
	import flash.filters.*;
	import flash.system.*;
	import flash.net.*;
	import flash.external.*;
	
	import com.greensock.*;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	
	public class FinishScreenBanner extends Sprite 
	{
		
		private static var BANNER_URL = 'https://s3.amazonaws.com/mud-u/mud+u+skyscraper+banner/mudu_skyscraper.swf';
		
		public function FinishScreenBanner()
		{
			super();
			loadBanner();
		}
		
		
		private function loadBanner() : void
		{
			var url:String = BANNER_URL+'?reqNum='+new Date().getTime();
			var lc = new LoaderContext(true);
			var r:URLRequest = new URLRequest( url );
				r.method = URLRequestMethod.GET;

			var l:Loader = new Loader();
				l.contentLoaderInfo.addEventListener( Event.COMPLETE, onBannerLoaded );
				//l.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onAppLoadProgress );
				//l.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onAppLoadError);
				l.load( r, lc );
		}
		
		private function onBannerLoaded( e = null) : void
		{
			addChild(e.target.content);
		}
	}

}


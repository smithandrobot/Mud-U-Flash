package com.smithandrobot.mud_u 
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
	
	import com.smithandrobot.utils.*;
	
	public class MudUAppLoader extends Sprite 
	{
		
		private var _mudSplats = [MudSplatA, MudSplatB, MudSplatC, MudSplatD, MudSplatE, MudSplatF, MudSplatG, MudSplatH, MudSplatI, MudSplatJ, MudSplatK];
		private var _container : Sprite
		private var _splatTimer : Timer;
		private var _bmpData : BitmapData;
		private var _logo : MovieClip;
		
		public function MudUAppLoader()
		{
			Security.allowDomain("*");
			var randNumber = RobotMath.randRange(10000, 100000);
			super();
			_container = addChild(new Sprite()) as Sprite;
			
			_bmpData = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0x00FFFFFF);
			_container.addChild(new Bitmap(_bmpData));
			
			_splatTimer = new Timer(1, 0);
			_splatTimer.addEventListener(TimerEvent.TIMER, splat)
			_splatTimer.start();
			
			_logo = _container.addChild(new Logo()) as MovieClip;
			_logo.x = stage.stageWidth/2;
			_logo.y = stage.stageHeight/2;

			addEventListener("onSiteInitialized", onUserData);
			trace("randNumber: "+randNumber);
			loadFile("mud_u_app.swf?cache="+randNumber);

			
			
			var d = new Debug(this);
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
		
		private function onAppLoaded(e:Event = null) : void
		{
			addChildAt(e.target.content, 0);
			//_splatTimer.stop();
			/*TweenMax.to(_container, .2, {alpha:0, y:"+20", onComplete:remove, ease:Back.easeIn});*/
			_logo.t.text = "Getting info...";
			//_logo.t.width = _logo.t.textWidth+10;
			_logo.t.autoSize = "center";
		}
		
		private function onAppLoadProgress(e:Event) : void
		{
			var loaded = e.target.bytesLoaded;
			var total = e.target.bytesTotal;
			var percent = (loaded/total)*100
			_logo.t.text = percent.toFixed(0)+"%";
		}
		
		
		private function onAppLoadError(e:IOErrorEvent) : void
		{
			trace(" error loading app!")
		}
		
		
		private function splat(e:TimerEvent) : void
		{
			var index = RobotMath.randRange(0, _mudSplats.length-1);
			var mSplat = _mudSplats[index];
			var variance = 100;
			
			var radius = RobotMath.randRange(0, variance);
			var angle = RobotMath.randRange(0, 360);
			var rad = angle*(Math.PI/180);

			var splat = new mSplat();
			var bmp = new Bitmap(new mSplat());
			bmp.smoothing = true;
			bmp.x = bmp.y = -100;
			
			var s = new Sprite();
			s.addChild(bmp);
			s.x = ((stage.stageWidth/2) + Math.cos(rad) * radius);
			s.y = ((stage.stageHeight/2) + Math.sin(rad) * radius) + 20;
			s.rotation = RobotMath.randRange(0, 180);

			_bmpData.draw(s,s.transform.matrix)
			
			//_container.setChildIndex(_logo,numChildren-1)
			s = null;
			shakeCamera();
		}

		private function onUserData(e:Event = null)
		{
			TweenMax.to(_container, .2, {alpha:0, y:"+20", onComplete:remove, ease:Back.easeIn});
		}
				
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		
		private function shakeCamera() : void
		{
			var offset = RobotMath.randRange(-2, 2);
			_container.y = offset;
			_container.x = offset;
			_logo.x = (stage.stageWidth/2) + offset ;
			_logo.y = (stage.stageHeight/2) + offset;
		}
		
		
		private function loadFile(f) : void
		{
			var url:String = f;
			var lc = new LoaderContext(true);
			var r:URLRequest = new URLRequest( url );
				r.method = URLRequestMethod.GET;

			var l:Loader = new Loader();
				l.contentLoaderInfo.addEventListener( Event.COMPLETE, onAppLoaded );
				l.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onAppLoadProgress );
				l.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onAppLoadError);
				l.load( r, lc );
		}
		
		private function remove() : void
		{
			removeChild(_container);
		}

	}

}


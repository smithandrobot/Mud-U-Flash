package com.ruedaminute
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.events.*;
	
	public class CamGrabber extends Sprite
	{
		private var cam:Camera;
		private var cam_width:Number=600;
		private var cam_height:Number=400;
		private var cam_fps:Number=15;
		
		private var picture:BitmapData;
		private var bmp:Bitmap;
		private var flip:Matrix;
		
		private var vid:Video;
		private var _webCam : Boolean;
		
		public function CamGrabber(default_width:Number=600, default_height:Number=400)
		{
			super();
			//addEventListener(Event.ADDED_TO_STAGE, onAdded)
			cam_width=default_width;
			cam_height=default_height;
			init();
		}
		
		
		public function get webCam() : Boolean { return _webCam};
		
		private function init():void{
			cam= Camera.getCamera();
			if(!cam)
			{
				_webCam = false;
				// todo take care of users with no camera!
				//dispatchEvent(new StatusEvent("status", true, false, "Camera.Muted", "error"));
				// return;
			
			}
			_webCam = false;
			cam.addEventListener(StatusEvent.STATUS , onWebCameraStatus);
			cam.setMode(cam_width, cam_height, cam_fps);
			vid= new Video(cam_width, cam_height);
			vid.attachCamera(cam);
			addChild(vid);
			
			picture= new BitmapData(vid.width, vid.height);
			bmp= new Bitmap(picture);
			bmp.smoothing = true
			addChild(bmp);
			this.addEventListener(Event.ENTER_FRAME, draw);
			
			flip= new Matrix();
			flip.scale(-1,1)
			flip.translate(vid.width,0)
		}
		
		private function draw(e:Event):void{
			if (cam.fps!=cam_fps) return;
			picture.draw(vid, flip);
		}
		
		public function snap():BitmapData{
			removeChild(vid);
			removeChild(bmp);
			vid.attachCamera(null);
			this.removeEventListener(Event.ENTER_FRAME, draw);
			return picture;
		}
		
		public function reInit() : void
		{
			addChild(vid);
			addChild(bmp);
			vid.attachCamera(cam);
			this.addEventListener(Event.ENTER_FRAME, draw);
		}
		
		
		private function onWebCameraStatus(e:StatusEvent) : void
		{
			dispatchEvent(e);
		}
	}
}
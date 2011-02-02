package com.smithandrobot.mud_u.views.ui {

	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.Point;
	import flash.net.*;
	import flash.system.*;
	import flash.media.*;
	
	import com.greensock.*;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	
	import com.smithandrobot.mud_u.interfaces.IScreen;
	
	public class HomeScreen extends Sprite implements IScreen
	{
		
		private var _data : *;
		private var _mediator;
		private var _type : String = undefined;
		private var _fileRef : FileReference;
		private var _bmpData : BitmapData;
		public function HomeScreen(m)
		{
			TweenPlugin.activate([MotionBlurPlugin]);
			TweenPlugin.activate([ScalePlugin]);
			
			_mediator = m;
			
			_fileRef = new FileReference();
			_fileRef.addEventListener(Event.CANCEL, onCancel);
			_fileRef.addEventListener(Event.SELECT, onSelect);
			_fileRef.addEventListener(Event.COMPLETE, onComplete);
			
			alpha = 0;
			
			initBehaviors(photoButton);
			if(Camera.getCamera()) initBehaviors(webCamButton);
			initBehaviors(friendsPhotosButton);
			initBehaviors(uploadButton);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		
		public function set data(d:*) : void { _data = d; };
		public function get setupType() : String {return _type};
		
		public function get bmpData() : BitmapData { return _bmpData; };
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		

		public function animateIn() : void
		{
			alpha = 1;
			TweenMax.allFrom([friendsPhotosButton, photoButton, uploadButton, webCamButton], .25, {y:"+100", alpha:0, scaleX:.1, scaleY:.1, ease:Back.easeOut}, .05);
			TweenMax.from(frame, .15, {delay:.4, y:"-600", ease:Back.easeOut, easeParams:[.8], rotation:5});
			TweenMax.from(frontMud, .15, {delay:.4, y:"+20", alpha:0, ease:Back.easeOut});
			TweenMax.from(pickCopy, .25, {delay:.35, alpha:0, y:"-10"});
			TweenMax.from(instructions, .25, {delay:.45, alpha:0, y:"-10"});
			TweenMax.from(tagLine, .25, {delay:.5, scaleX:0, scaleY:0, ease:Back.easeOut});
		}
		
		
		
		public function animateOut() : void
		{
			TweenMax.allTo([friendsPhotosButton, photoButton, uploadButton, webCamButton], .25, {alpha:0, scaleX:.1, scaleY:.1, ease:Back.easeIn}, .05);

			TweenMax.to(frame, .25, {delay:.4, y:"-600", ease:Back.easeIn, easeParams:[.8], rotation:5});
			TweenMax.to(pickCopy, .25, {delay:.35, alpha:0, y:"-10"});
			TweenMax.to(tagLine, .25, {delay:.3, scaleX:0, scaleY:0, ease:Back.easeIn});
			TweenMax.to(instructions, .25, {delay:.45, alpha:0, y:"-10", onComplete:remove});
		}
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function onButtonClick(e:Event) : void
		{
			_type = null;
			switch(e.target)
			{
				case photoButton :
					_type = "userPhotos";
				break;
				
				case webCamButton:
					_type = "webCam";
				break;
				
				case friendsPhotosButton:
					_type = "friendsPhotos";
				break;
				
				case uploadButton:
					getImageFile()
				break;
				
			}
			
			if(_type) dispatchEvent(new Event("onSetUpTypeChosen", true));
		}
		
		
		private function onCancel(e:Event) : void
		{
			trace("cancelled");
		}
		
		
		private function onSelect(e:Event) : void
		{
			_fileRef.load();
		}
		
		
		private function onComplete(e:Event) : void
		{

			var loader = new Loader();


			loader.loadBytes(_fileRef.data);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event)
			{
				trace("COMPLETE width: "+e.target.width);
				_bmpData = new BitmapData(loader.width, loader.height);
				_bmpData.draw(loader.content);
				dispatchEvent(new Event("onPhotoChosen", true));
			})
		}
		
		
		private function mouseOverHandler(e:MouseEvent) : void
		{
			/*if(e.type == MouseEvent.MOUSE_OVER) TweenMax.to(e.target, .2, {ease:Back.easeOut, rotation:3});
			if(e.type == MouseEvent.MOUSE_OUT) TweenMax.to(e.target, .2, {ease:Back.easeIn, rotation:0});*/
			if(e.type == MouseEvent.MOUSE_OVER) TweenMax.to(e.target, .25, {scale:1.05});
			if(e.type == MouseEvent.MOUSE_OUT) TweenMax.to(e.target, .25, {scale:1});
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function initBehaviors(btn) : void
		{
			btn.addEventListener(MouseEvent.CLICK, onButtonClick);
			btn.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			btn.addEventListener(MouseEvent.MOUSE_OUT, mouseOverHandler);
			btn.buttonMode = true;
		}
		
		
		public function remove() : void
		{
			dispatchEvent(new Event("onScreenOut"));
			parent.removeChild(this);
			TweenMax.allTo([tagLine, photoButton, webCamButton, friendsPhotosButton, uploadButton], .001, {alpha:1, scaleX:1, scaleY:1});

			TweenMax.to(frame, .001, {delay:.4, y:"+600", rotation:0});
			TweenMax.to(pickCopy, .001, {alpha:1, y:"+10"});
			TweenMax.to(instructions, .001, {alpha:1, y:"+10"});
			
			frontMud.alpha = 1;
			frontMud.y = 448.95;
		}
		
		
		private function getImageFile() : void
		{
			_fileRef.browse( new Array( new FileFilter( "Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png" ) ) );

		}
	}

}


package com.smithandrobot.mud_u.views.ui 
{

	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.*;
	//impoer flash.events.ActivityEvent.ACTIVITY;
	import com.greensock.*;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	
	import com.ruedaminute.CamGrabber;
	
	import com.smithandrobot.mud_u.interfaces.IScreen;

	public class WebCamScreen extends Sprite 
	{		
		
		private var _webCamCanvas : CamGrabber;
		private var _mediator;
		private var _state = "takePhoto";
		private var _bmpLayer : Sprite;
		private var _bmpData : BitmapData;
		
		public function WebCamScreen(m = null)
		{
			_mediator = m;
			_webCamCanvas = new CamGrabber(289, 250);
			_webCamCanvas.addEventListener(StatusEvent.STATUS , onWebCameraStatus);
			_bmpLayer = frame.imgContainer.addChild(new Sprite()) as Sprite;
			
			retakeBtn.alpha = 0;
			retakeBtn.scaleX = 0
			retakeBtn.scaleY = 0
			
			useThisBtn.alpha = 0;
			useThisBtn.scaleX = 0
			useThisBtn.scaleY = 0
			
			enable(true);
		}
		


		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function set data(d) : void {};
		
		public function get bmpData() : BitmapData { return _bmpData; };

		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		public function animateIn() : void
		{
			_webCamCanvas.reInit();
			TweenMax.from(this, .25, {alpha:0});
			TweenMax.from(frame, .25, {scaleX:.1, scaleY:.1, ease:Back.easeOut});
			TweenMax.from(title, .25, {x:"-10", alpha:0, ease:Back.easeOut});
			TweenMax.from(useThisBtn, .25, {delay:.1, alpha:0, scaleX:0, scaleY:0, ease:Back.easeOut});
			TweenMax.from(retakeBtn, .25, {delay:.2, alpha:0, scaleX:0, scaleY:0, ease:Back.easeOut, onComplete:onAnimatedIn});	
		}
		
		public function animateOut() : void
		{
			//TweenMax.from(this, .25, {alpha:0});
			TweenMax.to(takePhotoBtn, .25, {alpha:0, scaleX:0, scaleY:0, ease:Back.easeIn});
			TweenMax.to(cancelBtn, .25, {delay:.1, alpha:0, scaleX:0, scaleY:0, ease:Back.easeIn});
			
			TweenMax.to(retakeBtn, .25, {alpha:0, scaleX:0, scaleY:0, ease:Back.easeIn});
			TweenMax.to(useThisBtn, .25, {delay:.1, alpha:0, scaleX:0, scaleY:0, ease:Back.easeIn});
			
			TweenMax.to(frame, .25, {delay:.2, scaleX:.1, scaleY:.1, ease:Back.easeIn, onComplete:remove});	
			TweenMax.to(title, .25, {delay:.2, x:"-10", alpha:0, ease:Back.easeIn});
		}
		

		public function remove() : void
		{
			dispatchEvent(new Event("onScreenOut"));
			parent.removeChild(this);
			frame.imgContainer.removeChild(_webCamCanvas);
			
			
			title.x = 499.15;
			title.alpha = 1;
			
			takePhotoBtn.alpha = 1;
			takePhotoBtn.scaleX = 1
			takePhotoBtn.scaleY = 1
			
			cancelBtn.alpha = 1;
			cancelBtn.scaleX = 1
			cancelBtn.scaleY = 1
			
			retakeBtn.alpha = 0;
			retakeBtn.scaleX = 0
			retakeBtn.scaleY = 0
			
			useThisBtn.alpha = 0;
			useThisBtn.scaleX = 0
			useThisBtn.scaleY = 0
			
			frame.alpha = 1;
			frame.scaleX = 1;
			frame.scaleY = 1
		}



		private function enable(b:Boolean) : void
		{
			if(b)
			{
				takePhotoBtn.addEventListener(MouseEvent.CLICK, onTakePhoto);
				takePhotoBtn.addEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
				takePhotoBtn.addEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
				
				cancelBtn.addEventListener(MouseEvent.CLICK, onCancel);
				cancelBtn.addEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
				cancelBtn.addEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);

				useThisBtn.addEventListener(MouseEvent.CLICK, onUseThis);
				useThisBtn.addEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
				useThisBtn.addEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
				
				retakeBtn.addEventListener(MouseEvent.CLICK, onRetake);
				retakeBtn.addEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
				retakeBtn.addEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
				
				takePhotoBtn.buttonMode = cancelBtn.buttonMode = useThisBtn.buttonMode = retakeBtn.buttonMode = true;
			}else{
				
				takePhotoBtn.removeEventListener(MouseEvent.CLICK, onTakePhoto);
				takePhotoBtn.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
				takePhotoBtn.removeEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
				
				cancelBtn.removeEventListener(MouseEvent.CLICK, onCancel);
				cancelBtn.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
				cancelBtn.removeEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
				
				useThisBtn.removeEventListener(MouseEvent.CLICK, onUseThis);
				useThisBtn.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
				useThisBtn.removeEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
				
				retakeBtn.removeEventListener(MouseEvent.CLICK, onRetake);
				retakeBtn.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
				retakeBtn.removeEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
				
				takePhotoBtn.buttonMode = cancelBtn.buttonMode = useThisBtn.buttonMode = retakeBtn.buttonMode = false;
			}
		}
		
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function onTakePhoto(e:MouseEvent) : void
		{
			_bmpData = _webCamCanvas.snap();
			var webBMP = _bmpLayer.addChild(new Bitmap(_bmpData));
			showApproveBtns();
		}
		
		private function onCancel(e:MouseEvent) : void
		{
			_webCamCanvas.snap();
			dispatchEvent(new Event("onPickPhotoCancel", true));
		}
		
		
		private function onRetake(e:MouseEvent = null) : void
		{
			_bmpLayer.removeChildAt(0);
			_webCamCanvas.reInit();
			showSetUpBtns();
		}
		
		
		private function onUseThis(e:MouseEvent) : void
		{
			_bmpData = new BitmapData(289,250);
			_bmpData.draw(frame.imgContainer);
			dispatchEvent(new Event("onPhotoChosen", true));
		}
		
		private function onWebCameraStatus(e:StatusEvent) : void
		{
			if(e.code == "Camera.Muted")
			{
				dispatchEvent(new Event("onPickPhotoCancel", true));
			}
		}
		
		
		private function mouseOverOutHandler(e:MouseEvent) : void
		{
			if(e.type == MouseEvent.MOUSE_OVER) TweenMax.to(e.target, .25, {scale:1.05});
			if(e.type == MouseEvent.MOUSE_OUT) TweenMax.to(e.target, .25, {scale:1});
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//---------------------------------------
		
		
		private function onAnimatedIn()
		{
			_webCamCanvas.alpha = 0;
			if(!_webCamCanvas.parent) frame.imgContainer.addChild(_webCamCanvas);

			TweenMax.to(_webCamCanvas, .2, {alpha:1});
		}
		
		private function showSetUpBtns()
		{
			setChildIndex(takePhotoBtn, numChildren-1);
			setChildIndex(cancelBtn, numChildren-1);
			
			TweenMax.to(takePhotoBtn, .25, {delay:.1, alpha:1, scaleX:1, scaleY:1, ease:Back.easeOut});
			TweenMax.to(cancelBtn, .25, {delay:.2, alpha:1, scaleX:1, scaleY:1, ease:Back.easeOut});
			
			TweenMax.to(useThisBtn, .25, {alpha:0, scaleX:0, scaleY:0, ease:Back.easeIn});
			TweenMax.to(retakeBtn, .25, {delay:.1, alpha:0, scaleX:0, scaleY:0, ease:Back.easeIn});
			
		}
		
		private function showApproveBtns()
		{
			setChildIndex(useThisBtn, numChildren-1);
			setChildIndex(retakeBtn, numChildren-1);
			
			TweenMax.to(takePhotoBtn, .25, {delay:.1, alpha:0, scaleX:0, scaleY:0, ease:Back.easeIn});
			TweenMax.to(cancelBtn, .25, {delay:.2, alpha:0, scaleX:0, scaleY:0, ease:Back.easeIn});
			
			TweenMax.to(useThisBtn, .25, {alpha:1, scaleX:1, scaleY:1, ease:Back.easeOut});
			TweenMax.to(retakeBtn, .25, {delay:.1, alpha:1, scaleX:1, scaleY:1, ease:Back.easeOut});
			
		}
	}

}


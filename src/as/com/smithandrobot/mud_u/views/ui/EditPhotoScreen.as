package com.smithandrobot.mud_u.views.ui {

	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.*;
	
	import com.senocular.display.TransformTool;
	
	import com.greensock.*;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	
	import com.smithandrobot.mud_u.transform.MudUTransformTool;
	import com.smithandrobot.mud_u.views.ui.*;
	import com.smithandrobot.mud_u.interfaces.IScreen;

	public class EditPhotoScreen extends Sprite implements IScreen
	{
		
		private var _mediator;
		private var _bmpData : BitmapData;
		private var _transformTool : MudUTransformTool;
		private var _imgOrg = new Point();
		private var _transformLayer : Sprite;
		private var _editedPhoto : Sprite;
		private var _maskEditor : EditPhotoScreenMaskEditor;
		
		public function EditPhotoScreen(m = null)
		{
			super();
			_mediator = m;
			
			cancelBtn.addEventListener(MouseEvent.CLICK, function(){ dispatchEvent(new Event("onPickPhotoCancel", true)) });
			cancelBtn.addEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
			cancelBtn.addEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
			cancelBtn.mouseChildren = false;
			cancelBtn.buttonMode = true;
			
			doneBtn.addEventListener(MouseEvent.CLICK, onPhotoEdited);
			doneBtn.addEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
			doneBtn.addEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
			doneBtn.mouseChildren = false;
			doneBtn.buttonMode = true;
			
			backBtn.addEventListener(MouseEvent.CLICK, onBackBtnClicked);
			backBtn.addEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
			backBtn.addEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
			backBtn.mouseChildren = false;
			backBtn.buttonMode = true;
			
			var container = frame.imgContainer.imgSource;
			container.visible = false;
			
			_imgOrg.x = frame.imgContainer.transform.matrix.tx;
			_imgOrg.y = frame.imgContainer.transform.matrix.ty;
			
			_transformLayer = addChild(new Sprite()) as Sprite;
			/*_transformLayer.x = frame.x;
			_transformLayer.y = frame.y;*/
			
			_maskEditor = addChild(new EditPhotoScreenMaskEditor()) as EditPhotoScreenMaskEditor;
			_maskEditor.x = 44;
			_maskEditor.y = 266;
			_maskEditor.rotation = 3;
			
			initTransformTool();
		}
		
		
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function set data(d) : void {};
		
		public function get editedPhoto() : Sprite { return _editedPhoto; };
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		public function animateIn() : void
		{
			loadImage();
			
			TweenMax.from(this, .25, {alpha:0});
			TweenMax.from(backBtn, .3, {y:"-100", ease:Bounce.easeOut});
			TweenMax.from(frame, .25, {scaleX:.1, scaleY:.1, ease:Back.easeOut});
			TweenMax.from(greenDot, .25, {delay:.25, scaleX:.1, alpha:0, scaleY:.1, ease:Back.easeOut});
			TweenMax.from(copy1, .25, {delay:.25, x:"-10", alpha:0, ease:Strong.easeOut});
			
			TweenMax.from(diamond, .25, {delay:.3, scaleX:.1, alpha:0, scaleY:.1, ease:Back.easeOut});
			TweenMax.from(copy2, .25, {delay:.3, x:"-10", alpha:0, ease:Strong.easeOut});
			
			TweenMax.from(doneBtn, .25, {delay:.25, scaleX:.1, alpha:0, scaleY:.1, ease:Back.easeOut});		
			TweenMax.from(cancelBtn, .25, {delay:.3, scaleX:.1, alpha:0, scaleY:.1, ease:Back.easeOut});
			TweenMax.from(_maskEditor,.25, {delay:.3, alpha:0});
		}
		
		
		public function animateOut() : void
		{
			_transformTool.visible = false;
			
			TweenMax.to(backBtn, .3, {y:"-100", ease:Bounce.easeOut});
			TweenMax.to(frame, .25, {alpha:0, scaleX:.1, scaleY:.1, ease:Back.easeIn});
			TweenMax.to(_maskEditor,.25, {alpha:0});
			TweenMax.to(doneBtn, .25, {delay:.25, scaleX:.1, scaleY:.1, ease:Back.easeIn});
			
			TweenMax.to(greenDot, .25, {delay:.25, scaleX:.1, alpha:0, scaleY:.1, ease:Back.easeIn});
			TweenMax.to(copy1, .25, {delay:.25, x:"-10", alpha:0, ease:Strong.easeIn});
			
			TweenMax.to(diamond, .25, {delay:.27, scaleX:.1, alpha:0, scaleY:.1, ease:Back.easeIn});
			TweenMax.to(copy2, .25, {delay:.27, x:"-10", alpha:0, ease:Strong.easeIn});
			
			TweenMax.to(cancelBtn, .25, {delay:.33, scaleX:.1, scaleY:.1, ease:Back.easeIn, onComplete:remove});
		}
		
		
		public function remove() : void
		{
			var container = frame.imgContainer.imgSource;
			
			dispatchEvent(new Event("onScreenOut"));
			parent.removeChild(this);
			
			alpha = 1;

			doneBtn.scaleX = doneBtn.scaleY = 1;
			doneBtn.alpha = 1;
			
			cancelBtn.alpha = 1;
			cancelBtn.scaleX = cancelBtn.scaleY = 1;
			
			frame.alpha = 1;
			frame.scaleX = frame.scaleY = 1;
			
			greenDot.scaleY = greenDot.scaleX = 1;
			greenDot.alpha = 1;
			
			diamond.scaleX = 1;
			diamond.scaleY = 1;
			diamond.alpha = 1;
			
			copy1.x = 318;
			copy1.scaleX = copy1.scaleY = 1;
			copy1.alpha = 1;
			
			copy2.x = 319;
			copy2.scaleX = 1;
			copy2.scaleY = 1;
			copy2.alpha = 1;
			
			_maskEditor.alpha = 1;
			
			if(container.imgHolder.numChildren > 0 ) container.imgHolder.removeChildAt(1);
			
			resetTransform();
			_transformTool.target = null;
			frame.imgContainer.x = _imgOrg.x;
			frame.imgContainer.y = _imgOrg.y;
			
			TweenMax.to(backBtn, .001, {y:"+100"});
		}
		
		
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function onPhotoEdited(e:Event) : void
		{
			if(!_editedPhoto) _editedPhoto = new Sprite();
			var bmp = getPhotoBitmap();
			var bkgBMP = new Bitmap(bmp.bitmapData.clone());
			bkgBMP.smoothing = true;
			
			while(_editedPhoto.numChildren > 0)
			{
				_editedPhoto.removeChildAt(0);
			}
			
			var bkgBMPData = _editedPhoto.addChild(bkgBMP);
			bkgBMPData.name = "bmpDataLayer";
			
			var maskedBMP = new Sprite();
			maskedBMP.addChild(bmp);
			_editedPhoto.addChild(maskedBMP);
			var bmpMask = _editedPhoto.addChild(_maskEditor.photoMask);
			bmpMask.name="bmpMask";
			
			var mBMPdata = new BitmapData(289, 250, true, 0x00FFFFFF);
			mBMPdata.draw(bmpMask);
			var mBMP = new Bitmap(mBMPdata);
			mBMP.name = "maskBMPData";
			_editedPhoto.addChildAt(mBMP, 0);
			
			maskedBMP.mask = bmpMask;
			maskedBMP.name = "maskedImage";
			
			dispatchEvent(new Event("onPhotoEdited", true))
		}
		
		
		private function onBackBtnClicked(e:MouseEvent) : void
		{
			trace("back btn clicked")
			dispatchEvent(new Event("onEditHistory", true));
		}
		
		private function mouseOverOutHandler(e:MouseEvent) : void
		{
			if(e.type == MouseEvent.MOUSE_OVER) TweenMax.to(e.target, .25, {scale:1.05});
			if(e.type == MouseEvent.MOUSE_OUT) TweenMax.to(e.target, .25, {scale:1});
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function loadImage() : void
		{
			_bmpData = _mediator.appPhoto;
			var container = frame.imgContainer.imgSource;
			container.visible = true;
			var bmp = new Bitmap(_bmpData);
			bmp.smoothing = true;

			var img = container.imgHolder.addChild(bmp);
			
			resizeBMP()
			
			container.imgHolder.mask = container.imgMask;
			_transformTool.target = container.imgHolder;
			_transformTool.registration = new Point(_transformTool.boundsTopLeft.x+container.width/2, _transformTool.boundsTopLeft.y+container.height/2);
			_transformTool.visible = true;
		}
		
		
		private function getPhotoBitmap() : Bitmap
		{
			var container = frame.imgContainer.imgSource;
			
			var bmd = new BitmapData(289, 250, false, 0xF0EAD5);
			bmd.draw(container);
			var nb = new Bitmap(bmd);
			nb.smoothing = true;
			return nb;
		}
		
		
		private function initTransformTool() : void
		{
			_transformTool = new MudUTransformTool();
			_transformTool.moveEnabled = true;
			_transformTool.constrainScale = true;
			_transformTool.skewEnabled = false;
			_transformTool.moveUnderObjects = true;
			_transformTool.customCursorsEnabled = false;
			_transformTool.setSkin(TransformTool.SCALE_TOP_LEFT, new Ellipse());
			_transformTool.setSkin(TransformTool.SCALE_TOP_RIGHT, new Ellipse());
			_transformTool.setSkin(TransformTool.SCALE_BOTTOM_LEFT, new Ellipse());
			_transformTool.setSkin(TransformTool.SCALE_BOTTOM_RIGHT, new Ellipse());
			_transformTool.setSkin(TransformTool.ROTATION_TOP_LEFT, new RotationTopLeft());
			_transformTool.setSkin(TransformTool.ROTATION_TOP_RIGHT, new RotationTopRight());
			_transformTool.setSkin(TransformTool.ROTATION_BOTTOM_RIGHT, new RotationBottomRight());
			_transformTool.setSkin(TransformTool.ROTATION_BOTTOM_LEFT, new RotationBottomLeft());
			_transformTool.setSkin(TransformTool.SCALE_TOP, new EmptyControl());
			_transformTool.setSkin(TransformTool.SCALE_RIGHT, new EmptyControl());
			_transformTool.setSkin(TransformTool.SCALE_BOTTOM, new EmptyControl());
			_transformTool.setSkin(TransformTool.SCALE_LEFT, new EmptyControl());
			_transformTool.registrationControl.visible = false;
			_transformLayer.addChild(_transformTool);
		}
		
		
		private function resetTransform():void {
			_transformTool.toolMatrix = new Matrix();
			_transformTool.apply();
		}
		
		
		private function resizeBMP()
		{
			var container = frame.imgContainer.imgSource;
			var img = container.imgHolder;
			var mask = container.imgMask;
			
			if(img.width > img.height && img.width > mask.width)
			{
				img.height = mask.height;
				img.scaleX = img.scaleY;
				img.x = (mask.x + mask.width/2) - img.width/2;
			}
			
			if(img.width < img.height && img.height > mask.height)
			{
				img.width = mask.width;
				img.scaleY= img.scaleX;
				img.y = (mask.y + mask.height/2) - img.height/2;
			}
			
			if(img.width==img.height && img.height > mask.height)
			{
				img.height = mask.height;
				img.scaleX = img.scaleY;
				img.x = (mask.x + mask.width/2) - img.width/2;
			}
		}
		
	}

}


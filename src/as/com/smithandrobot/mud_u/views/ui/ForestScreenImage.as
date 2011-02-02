package com.smithandrobot.mud_u.views.ui 
{

	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.*;
	import flash.filters.*;
	
	import com.greensock.*;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	
	import aether.effects.filters.*;
	import aether.utils.*;
	
	import com.smithandrobot.utils.*;
	
	public class ForestScreenImage extends Sprite 
	{
		
		private var _originalImg 			: Bitmap;
		private var _originalImgMask		: Bitmap;
		private var _originalImgMasked 		: Bitmap;
		private var _outerBlur				: Bitmap;
		private var _mudLayer 				: Bitmap;
		private var _maskedFaceOverlay 		: Bitmap;
		private var _maskedFaceOverlayMask 	: Bitmap;
		private var _maskedFaceScreened 	: Bitmap;
		private var _maskedFaceScreenedMask	: Bitmap;
		private var _overshootLayer 		: Bitmap;
		private var _maskedTexture			: Bitmap;
		private var _maskedTextureMask		: Bitmap;
		private var _highlightMask			: Bitmap;
		private var _highlight 				: Bitmap;
		
		private var _deerSplats				= [MudSplatA, MudSplatB, MudSplatC, MudSplatD, MudSplatE, MudSplatF, MudSplatG, MudSplatH, MudSplatI, MudSplatJ, MudSplatK];
		private var _bearSplats				= [MudSplatA, MudSplatB, MudSplatC, MudSplatD, MudSplatE, MudSplatF, MudSplatG, MudSplatH, MudSplatI, MudSplatJ, MudSplatK];
		private var _sasplotchSplats		= [SasplotchMud1, SasplotchMud2, SasplotchMud3];
		private var _splatContainer			= new Sprite();
		private var _splatMatrix			: Matrix;
		private var _splatContainerMask		: Bitmap;
		
		public function ForestScreenImage()
		{
			var bmp 								= new BitmapData(289, 250, true, 0x00FFFFFF);
			                        				
			_originalImg 							= new Bitmap(bmp.clone());
			_originalImg.smoothing					= true;
			addChild(_originalImg);     	
			
			_outerBlur 								= new Bitmap(bmp.clone());
			_outerBlur.smoothing					= true;
			addChild(_outerBlur);  		

			_originalImgMask 						= new Bitmap(bmp.clone());
			_originalImgMask.smoothing				= true;
			var originalMask						= addChild(new Sprite().addChild(_originalImgMask));
			originalMask.cacheAsBitmap				= true;
			
			
			_originalImgMasked 						= new Bitmap(bmp.clone());
			_originalImgMasked.smoothing			= true;
			var originalMasked						= _splatContainer.addChild(new Sprite().addChild(_originalImgMasked));
			originalMasked.cacheAsBitmap			= true;
			originalMasked.mask						= originalMask;                     			

			                            			
			_mudLayer 								= new Bitmap(bmp.clone());
			_mudLayer.smoothing						= true;
			var mLayer								= _splatContainer.addChild(new Sprite().addChild(_mudLayer));
			mLayer.blendMode 						= "multiply";
			
			
			_highlightMask							= new Bitmap(bmp.clone());
			_highlightMask.smoothing				= true;
			var highlightMask 						= _splatContainer.addChild(new Sprite().addChild(_highlightMask));
			highlightMask.cacheAsBitmap 			= true;
			
			_highlight 								= new Bitmap(bmp.clone());
			_highlight.smoothing					= true;
			var highlight							= _splatContainer.addChild(new Sprite().addChild(_highlight));
			highlight.cacheAsBitmap 				= true;
			highlight.mask							= highlightMask;

			
			/*_maskedFaceOverlayMask 					= new Bitmap(bmp.clone());
			_maskedFaceOverlayMask.smoothing		= true;
			var maskedFaceOverlayMask 				= _splatContainer.addChild(new Sprite().addChild(_maskedFaceOverlayMask));
			maskedFaceOverlayMask.cacheAsBitmap 	= true;
			
			_maskedFaceOverlay 						= new Bitmap(bmp.clone());
			_maskedFaceOverlay.smoothing			= true;
			var maskedFaceOverlay					= _splatContainer.addChild(new Sprite().addChild(_maskedFaceOverlay));
			maskedFaceOverlay.blendMode 			= "multiply";
			maskedFaceOverlay.mask					= maskedFaceOverlayMask;
			maskedFaceOverlay.cacheAsBitmap 		= true; 
			maskedFaceOverlay.alpha					= 0;*/
			
			_maskedFaceScreenedMask					= new Bitmap(bmp.clone());
			_maskedFaceScreenedMask.smoothing		= true;
			var maskedFaceScreenedMask 				= _splatContainer.addChild(new Sprite().addChild(_maskedFaceScreenedMask));
			maskedFaceScreenedMask.cacheAsBitmap	= true;
			
			_maskedFaceScreened 					= new Bitmap(bmp.clone());
			_maskedFaceScreened.smoothing			= true;
			var maskedFaceScreened					= _splatContainer.addChild(new Sprite().addChild(_maskedFaceScreened));
			maskedFaceScreened.cacheAsBitmap 		= true;
			maskedFaceScreened.alpha				= 0//.55;
			maskedFaceScreened.blendMode 			= "screen";
			maskedFaceScreened.mask					= maskedFaceScreenedMask;
			
			/* */
			_maskedTexture  						= new Bitmap(new MudTexture());
			_maskedTexture .smoothing				= true;
			var maskedTexture 						= _splatContainer.addChild(new Sprite().addChild(_maskedTexture ));
			maskedTexture.cacheAsBitmap 			= true; 
			
			_maskedTextureMask						= new Bitmap(bmp.clone());
			_maskedTextureMask.smoothing			= true;
			var maskedTextureMask 					= _splatContainer.addChild(new Sprite().addChild(_maskedTextureMask));
			maskedTextureMask.cacheAsBitmap			= true;

			maskedTexture.mask						= maskedTextureMask;
			/* */
			
			_splatMatrix							= new Matrix();
			
			_splatContainerMask						= new Bitmap(bmp.clone());
			_splatContainerMask.smoothing			= true;
			var sm 									= addChild(new Sprite().addChild(_splatContainerMask));
			sm.cacheAsBitmap 						= true;
			
			_splatContainer.cacheAsBitmap 			= true;
			_splatContainer.mask 					= sm;
			
			_maskedFaceOverlayMask 					= new Bitmap(bmp.clone());
			_maskedFaceOverlayMask.smoothing		= true;
			var maskedFaceOverlayMask 				= _splatContainer.addChild(new Sprite().addChild(_maskedFaceOverlayMask));
			maskedFaceOverlayMask.cacheAsBitmap 	= true;
			
			_maskedFaceOverlay 						= new Bitmap(bmp.clone());
			_maskedFaceOverlay.smoothing			= true;
			var maskedFaceOverlay					= _splatContainer.addChild(new Sprite().addChild(_maskedFaceOverlay));
			maskedFaceOverlay.blendMode 			= "multiply";
			maskedFaceOverlay.mask					= maskedFaceOverlayMask;
			maskedFaceOverlay.cacheAsBitmap 		= true; 
			maskedFaceOverlay.alpha					= .5;
			
			addChild(_splatContainer);
			addChild(new Bitmap(new Vignette()));
			
			addEventListener(Event.ADDED_TO_STAGE, onDisplayStateChange);
			addEventListener(Event.REMOVED_FROM_STAGE, onDisplayStateChange);
			bmp = null;
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		
		public function set src(b) : void 
		{
			var p = new Point(0,0);
			_originalImg.bitmapData.draw(b);
			
			_originalImgMasked.bitmapData.draw(b)
			//_originalImgMasked.x = 50;
			
			var mask = b.getChildByName("maskBMPData");
			//_originalImgMask.bitmapData.draw(mask);
			
			_splatContainerMask.bitmapData.draw(mask);
			_highlight.bitmapData = createHighLightBMD(_originalImgMasked.bitmapData);
			_maskedFaceOverlay.bitmapData.draw(b);
			Adjustments.desaturate(_maskedFaceOverlay.bitmapData, 1);
			
			_maskedFaceScreened.bitmapData.draw(b);
			
			Adjustments.desaturate(_maskedFaceScreened.bitmapData, 1);
			Adjustments.setLevels(_maskedFaceScreened.bitmapData, 187, 1.16, 25);
			/*Adjustments.adjustContrast(_maskedFaceScreened.bitmapData, .5);
			Adjustments.adjustBrightness(_maskedFaceScreened.bitmapData, -175);*/

			
			resetMudLayers();
		}
		


		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		
		public function start() { };
		
		public function splat(p:Point, type:String = null) : void
		{
			var bmpd 			= _bearSplats[RobotMath.randRange(0, _bearSplats.length-1)];
			var bmdClass 		= new bmpd();
			var scale 			= (type == "bear") ? RobotMath.randRange(.4, .7, true) : 1;
			_splatMatrix.a  	= scale
			_splatMatrix.d  	= _splatMatrix.a;
			_splatMatrix.tx 	= p.x-(bmdClass.width*_splatMatrix.a)/2;
			_splatMatrix.ty 	= p.y-(bmdClass.height*_splatMatrix.a)/2;
			
			_mudLayer.bitmapData.draw(bmdClass, _splatMatrix)
			_maskedFaceScreenedMask.bitmapData.draw(bmdClass, _splatMatrix);
			_maskedFaceOverlayMask.bitmapData.draw(bmdClass, _splatMatrix);
			_maskedTextureMask.bitmapData.draw(bmdClass, _splatMatrix);
			_highlightMask.bitmapData.draw(bmdClass, _splatMatrix);
			_outerBlur.bitmapData.draw(bmdClass, _splatMatrix);
		}
		
		
		public function squirrelPaint(p:Point, bmd, scale = 1) : void
		{
			if(scale < .1) scale 	= .1;
			var bmpData 			= new bmd();
			var c 					= new ColorTransform();
			_splatMatrix.a 			= scale//RobotMath.randRange(.2, 1, true);
			_splatMatrix.d 			= _splatMatrix.a;
			_splatMatrix.tx 		= p.x-(bmpData.width*_splatMatrix.a)/2;
			_splatMatrix.ty 		= p.y-(bmpData.height*_splatMatrix.a)/2;
			c.alphaMultiplier 		= .5;
			
			_mudLayer.bitmapData.draw(bmpData, _splatMatrix)
			_maskedFaceScreenedMask.bitmapData.draw(bmpData, _splatMatrix);
			_maskedFaceOverlayMask.bitmapData.draw(bmpData, _splatMatrix);
			_maskedTextureMask.bitmapData.draw(bmpData, _splatMatrix);
			_highlightMask.bitmapData.draw(bmpData, _splatMatrix);
			_outerBlur.bitmapData.draw(bmpData, _splatMatrix);
		}
		
		

		public function sasplotchSplat(p:Point, type:String = null) : void
		{
			var bmpd = _sasplotchSplats[RobotMath.randRange(0, _sasplotchSplats.length-1)];
			var bmdClass = new bmpd();
			var scale = (type == "bear") ? RobotMath.randRange(.4, .7, true) : 1;
			_splatMatrix.a = 1;
			_splatMatrix.d = _splatMatrix.a;
			_splatMatrix.tx = p.x-(bmdClass.width*_splatMatrix.a)/2;
			_splatMatrix.ty = p.y-(bmdClass.height*_splatMatrix.a)/2;
			_mudLayer.bitmapData.draw(bmdClass, _splatMatrix)
			_maskedFaceScreenedMask.bitmapData.draw(bmdClass, _splatMatrix);
			_maskedFaceOverlayMask.bitmapData.draw(bmdClass, _splatMatrix);
			_maskedTextureMask.bitmapData.draw(bmdClass, _splatMatrix);
			_highlightMask.bitmapData.draw(bmdClass, _splatMatrix);
			_outerBlur.bitmapData.draw(bmdClass, _splatMatrix);
		}
		
		
		public function erase(p:Point) : void
		{
			var toolsize = 10;
			var basepoint = new Point(0,0);
			var brush_mc = new CopyMaskInverted();
   			var erasebmp:BitmapData = new BitmapData(toolsize, toolsize, true, 0xFFFFFFFF);
   			var rect:Rectangle=new Rectangle(erasebmp.width,erasebmp.height);

   			erasebmp.draw(brush_mc);
   			erasebmp.copyChannel(erasebmp, erasebmp.getColorBoundsRect(0xFFFFFF,0,true), basepoint, 1, 8);

			var offset = new Point( p.x-(toolsize/2) , p.y-(toolsize/2) );

			var drawRect = new Rectangle(offset.x, offset.y, toolsize, toolsize);
			_mudLayer.bitmapData.copyPixels(_mudLayer.bitmapData, drawRect, offset, erasebmp, basepoint, false);
			_maskedFaceScreenedMask.bitmapData.copyPixels(_maskedFaceScreenedMask.bitmapData, drawRect, offset, erasebmp, basepoint, false);
			_maskedFaceOverlayMask.bitmapData.copyPixels(_maskedFaceOverlayMask.bitmapData, drawRect, offset, erasebmp, basepoint, false);
			_highlightMask.bitmapData.copyPixels(_maskedFaceOverlayMask.bitmapData, drawRect, offset, erasebmp, basepoint, false);
			_maskedTextureMask.bitmapData.copyPixels(_maskedFaceOverlayMask.bitmapData, drawRect, offset, erasebmp, basepoint, false);
		}
		
		
		public function clear() : void
		{
			var rect = new Rectangle(0,0,289, 250);
			_mudLayer.bitmapData.fillRect(rect, 0x00000000);
			_maskedFaceScreenedMask.bitmapData.fillRect(rect, 0x00000000);
			_maskedFaceOverlayMask.bitmapData.fillRect(rect, 0x00000000);
			_maskedTextureMask.bitmapData.fillRect(rect, 0x00000000);
			_highlightMask.bitmapData.fillRect(rect, 0x00000000);			
		}
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		private function onDisplayStateChange(e:Event) : void
		{
			if(e.type == Event.ADDED_TO_STAGE) { addEventListener(Event.ENTER_FRAME, onBlurOuterBMP); };
			if(e.type == Event.REMOVED_FROM_STAGE) { removeEventListener(Event.ENTER_FRAME, onBlurOuterBMP); };			
		}
		
		
		private function onBlurOuterBMP(e:Event = null) : void
		{
			var bf = new BlurFilter(2, 2, 3);
			_outerBlur.bitmapData.applyFilter(_outerBlur.bitmapData, new Rectangle(0,0, 289, 250), new Point(0,0), bf);
		}
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		
		private function resetMudLayers() : void
		{
			var rect = new Rectangle(0,0,289, 250);
			_mudLayer.bitmapData.fillRect(rect, 0x00FFFFFF);
			_maskedFaceScreenedMask.bitmapData.fillRect(rect, 0x00FFFFFF);
			_maskedFaceOverlayMask.bitmapData.fillRect(rect, 0x00FFFFFF);
			_maskedTextureMask.bitmapData.fillRect(rect, 0x00000000);
			_highlightMask.bitmapData.fillRect(rect, 0x00000000);
		}
		
		private function createHighLightBMD(org:BitmapData) : BitmapData
		{
			Adjustments.desaturate(org, 1);
			/*Adjustments.setLevels(org, 100, 1, 170);*/
			Adjustments.adjustContrast(org, 2)
			
			var bf = new BlurFilter(10,10,4);
			var targetBitmapData:BitmapData = new BitmapData(org.width, org.height, true, 0x00000000);

			targetBitmapData.threshold(org, org.rect, new Point(0,0), ">=", 0xFF999999, 0x7FC69C6D, 0xFFFFFFFF, false);
			targetBitmapData.applyFilter(targetBitmapData, targetBitmapData.rect, new Point(), bf);
			return targetBitmapData;
		}
		
	}

}


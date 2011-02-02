package com.smithandrobot.mud_u.views.ui {

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
	
	import com.smithandrobot.mud_u.interfaces.IScreen;
	import com.smithandrobot.mud_u.views.*;
	import com.smithandrobot.utils.*;
	

	public class ForestScreen extends Sprite implements IScreen
	{		
		private var _mediator 			: *;
		private var _editedPhoto 		: Sprite;
		private var _charPanelManager 	: CharacterPanelsManager;
		private var _muddedPhoto 		: Bitmap;
		private var _overlay			: Sprite;
		private var _mudBMP				: Bitmap;
		private var _mudBMPData			: BitmapData;
		private var _mudHitBMP			: Bitmap;
		private var _mudHitBMPData		: BitmapData;
		private var _mudHitSprite		: Sprite;
		private var _emptyBMPData		: BitmapData;
		private var _emptyRect			: Rectangle;
		private var _emptyPoint			: Point = new Point(0,0);
		private var _modes				: Array = ["darken", "multiply", "overlay"];
		private var _lastSquirrelPoint  : Point = new Point();
		private var _copySprite			: Sprite;
		private var _deerSplats			: Array;
		private var _bearSplats			: Array;
		private var _panel				: *;
		private var _playerData			: *;
		private var _forestImage		: ForestScreenImage;
		
		
		public function ForestScreen(m)
		{
			_mediator 			= m;
			mouseEnabled 		= false;
 			_charPanelManager 	= new CharacterPanelsManager();

			_charPanelManager.registerPanels([deer, bear, squirrel, frog, sasplotch]);
			
			_deerSplats			= [MudSplatA, MudSplatB, MudSplatC, MudSplatD, MudSplatE, MudSplatF, MudSplatG, MudSplatH, MudSplatI, MudSplatJ, MudSplatK];
			_bearSplats			= [MudSplatA, MudSplatB, MudSplatC, MudSplatD, MudSplatE, MudSplatF, MudSplatG, MudSplatH, MudSplatI, MudSplatJ, MudSplatK];
			
			_overlay  			= addChildAt(new Overlay(), 0) as Sprite;
			_overlay.name		= "overlay";
			_overlay.mouseEnabled = false;
			_overlay.alpha		= 0;

			_mudBMPData = new BitmapData(289, 250, true, 0x00FFFFFF);
			_mudBMP = new Bitmap(_mudBMPData);
			_mudBMP.smoothing = true;
			
			_mudHitBMPData = new BitmapData(289, 250, true, 0x00FFFFFF);
			_mudHitBMP = new Bitmap(_mudHitBMPData);
			_mudHitBMP.smoothing = true;
			
			_mudHitSprite = new Sprite();
			_mudHitSprite.addChild(_mudHitBMP);
			
			_emptyBMPData = new BitmapData(289, 250, true, 0x00000000);
			
			_copySprite = new Sprite();
			_copySprite.name = "copySprite";
			
			var copyMask = _copySprite.addChild( new CopyMask());
			copyMask.name = "copyMask";
			copyMask.cacheAsBitmap = true;
			
			var copyBMP = new Bitmap(_emptyBMPData);
			copyBMP.smoothing = true;
			var dataLayer = _copySprite.addChild(copyBMP);
			dataLayer.name="copyDataLayer";
			dataLayer.mask = copyMask;
			dataLayer.cacheAsBitmap = true;
			
			_emptyRect = new Rectangle(0,0,10,10);
			
			squirrel.frame = frame;
			
			deer.frame = frame;
			sasplotch.frame = frame;
			setChildIndex(sasplotch, numChildren-1);
			
			frame.crossHairs.alpha = 0;
			backToForest.x = 933;
			backToForest.y = 695;
			backToForest.addEventListener(MouseEvent.CLICK, function(){ dispatchEvent(new Event("characterPanelClosed", true)); });
			backToForest.addEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
			backToForest.addEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
			backToForest.buttonMode = true;
			
			
			_forestImage = addChild(new ForestScreenImage()) as ForestScreenImage;
			//_forestImage.x = 289;
			
			clearBtn.addEventListener(MouseEvent.CLICK, onClearClicked);
			
			addEventListener("characterPanelOpened", onPanelOpened);
			addEventListener("characterPanelClosed", onPanelClosed);
			addEventListener("onDeerMudImpact", onDeerMudImpact);
			addEventListener("onSasplotchMudImpact", onSasplotchMudImpact);
			addEventListener("onBearMudImpact", onBearMudImpact);
			addEventListener("onSquirrelDraw", onSquirrelDraw);
			addEventListener("onFrogErase", onFrogErase);			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			initBehaviors();
		}
		


		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function set data(d) : void {};
		
		
		public function set sasplotchLocked(b) : void
		{
			sasplotch.locked = b;
		}
		
		
		public function get muddedPhoto() : Bitmap { return _muddedPhoto; };


		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
	
		public function animateIn() : void
		{
			TweenMax.from(this, .1, {alpha:0});
			TweenMax.allFrom([treeFront, squirrelTree], .15, {scaleY:0, ease:Back.easeOut}, .15);
			TweenMax.from(frame, .15, {y:"-250", ease:Back.easeOut, easeParams:[3]});
			TweenMax.from(backBtn, .3, {y:"-100", ease:Bounce.easeOut});
			TweenMax.from(doneBtn, .3, {y:615, x:775, ease:Back.easeOut});
			deer.animateIn(.3);
			bear.animateIn(.35);
			squirrel.animateIn(.4);
			frog.animateIn(.45);
			sasplotch.animateIn(.5);
		}
		
		
		public function animateOut() : void
		{
			TweenMax.allTo([treeFront, squirrelTree], .25, {delay:.3, scaleY:0, ease:Back.easeOut, alpha:0}, .15);
			TweenMax.to(frame, .3, { y:"-700", ease:Back.easeIn });
			TweenMax.to(backBtn, .3, { y:"-100", ease:Bounce.easeIn });
			TweenMax.to(doneBtn, .3, { y:615, x:775, ease:Back.easeIn });
			deer.animateOut(.3);
			bear.animateOut(.35);
			squirrel.animateOut(0);
			frog.animateOut(.45);
			sasplotch.animateOut(0);
			TweenMax.to(this, .25, { delay:.7, alpha:0, onComplete:remove });
		}
		

		public function remove() : void
		{
			parent.removeChild(this);
			frame.y = 189.45;
			treeFront.scaleY = 1.139;
			squirrelTree.alpha = treeFront.alpha = 1;
			squirrelTree.scaleY = 1;
			TweenMax.to(backBtn, .001, {y:"+100"});
			TweenMax.to(doneBtn, .001, {y:569.95, x:580.95});
			alpha = 1;
			dispatchEvent(new Event("onScreenOut"));
		}



		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		private function onAdded(e:Event) : void
		{
			sasplotch.locked = _mediator.getPlayerData().sasplotchLocked;
			addEditedPhoto();
		}
		
		
		private function onBackBtnClicked(e:MouseEvent) : void
		{
			dispatchEvent(new Event("onForestBackBtn"))
		}
		
		
		private function onClearClicked(e:MouseEvent) : void
		{

			_forestImage.clear();
		}
		
		
		private function onDoneBtnCLicked(e:MouseEvent) : void
		{ 
			var image = frame.imgHolder.imgContainer
			var bmpData = new BitmapData(289, 250);
			bmpData.draw(_forestImage, null, null, null, null, true);
			//bmpData.draw(image, null, null, null, null, true);
			_muddedPhoto = new Bitmap(bmpData);
			_muddedPhoto.smoothing = true;
			
			dispatchEvent(new Event("onPhotoMudded"));
		}
		
		
		private function onPanelOpened(e:Event) : void
		{
			_overlay.mouseEnabled = true;
			_panel = e.target;
			TweenMax.to(_overlay, .2, {alpha:1});
			setChildIndex(_overlay, numChildren-1);
			
			if(e.target.type == "squirrel" || e.target.type == "sasplotch") setChildIndex(squirrelTree, numChildren-1);
			if(e.target.type == "sasplotch") {squirrel.visible = false; };
			if(e.target.type == "deer") frame.crossHairs.alpha = 1;
			
			setChildIndex(frame, numChildren-1);
			setChildIndex(e.target as Sprite, numChildren-1);
			setChildIndex(backToForest, numChildren-1); 
			if(e.target.type != "frog") _mediator.getAPIProxy().addInteraction(getInteractionID(e.target.type));
			
			TweenMax.to(backToForest, .2, {x:679, y:645, ease:Back.easeOut});
		}
		
		
		private function onPanelClosed(e:Event) : void
		{
			_overlay.mouseEnabled = false;
			setChildIndex(_overlay, 0);
			if(e.target.hasOwnProperty("type")) 
			{
				if(e.target.type == "squirrel" || e.target.type == "sasplotch") setChildIndex(squirrelTree, 1);
				if(e.target.type == "sasplotch") {squirrel.visible = true};
			}else{
				_panel.close(); 
			}
			setChildIndex(frog, numChildren-1);
			TweenMax.to(_overlay, .2, {alpha:0})
			TweenMax.to(backToForest, .2, {x:899, y:645, ease:Back.easeIn});
			TweenMax.to(frame.crossHairs, .2, {alpha:0, overwrite:1});
		}
		
		
		private function onDeerMudImpact(e:Event) : void
		{
			var framePoint = CoordinateTools.localToLocal(e.target as DisplayObject, _forestImage/*_editedPhoto.getChildByName("maskedImage")*/);
			_forestImage.splat(framePoint, "deer");
		}
		
		
		private function onSasplotchMudImpact(e:Event) : void
		{
			var framePoint = CoordinateTools.localToLocal(e.target as DisplayObject, _forestImage);
			_forestImage.sasplotchSplat(framePoint, "sasplotch");
		}
		
		
		private function onBearMudImpact(e:Event) : void
		{
			var framePoint = CoordinateTools.localToLocal(e.target as DisplayObject, _forestImage /*_editedPhoto.getChildByName("maskedImage")*/);
			_forestImage.splat(framePoint, "bear");
		}
		
		
		private function onSquirrelDraw(e:Event = null) : void
		{
			var framePoint = CoordinateTools.localToLocal(e.target.ikNode_18 as DisplayObject, _forestImage /*_editedPhoto.getChildByName("maskedImage")*/);
			framePoint.x = framePoint.x.toFixed(0);
			framePoint.y = framePoint.y.toFixed(0);
			
			if(_lastSquirrelPoint.x != framePoint.x && _lastSquirrelPoint.y != framePoint.y)
			{
				_forestImage.squirrelPaint(framePoint, getSquirrelPaintClass(e.target.color), squirrel.scale);
				_lastSquirrelPoint = framePoint;
			}
		}
		
		private function onFrogErase(e:Event) : void
		{

			var erasePoint = CoordinateTools.localToLocal(e.target as DisplayObject, _forestImage/*_editedPhoto.getChildByName("maskedImage")*/, e.target.clickedPoint);
			_forestImage.erase(erasePoint);

		}
		
		
		private function onBlurOuterBMP(e:Event = null) : void
		{
			var bf = new BlurFilter(2, 2, 3);
			_mudHitBMPData.applyFilter(_mudHitBMPData, new Rectangle(0,0, 289, 250), new Point(0,0), bf);
		}
		
		
		private function mouseOverOutHandler(e:MouseEvent) : void
		{
			if(e.type == MouseEvent.MOUSE_OVER) TweenMax.to(e.target, .25, {scale:1.05});
			if(e.type == MouseEvent.MOUSE_OUT) TweenMax.to(e.target, .25, {scale:1});
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		
		private function addEditedPhoto() : void
		{

			var photo = _mediator.getEditedPhoto();
			
			if(!photo.getChildByName("edited"))
			{
				_forestImage.src =  _mediator.getEditedPhoto();
				var edited = photo.addChild(new Sprite());
				edited.name = "edited";
			}
			var holder = frame.imgHolder.imgContainer;

			holder.addChild(_forestImage);
		}
		
		
		private function toggleCTAPanels(s:String ,animate:Boolean) : void
		{
			if(s == "open") _charPanelManager.toggleCTAPanels("open",animate);
			if(s == "close") _charPanelManager.toggleCTAPanels("close",animate);
		}
		
		
		private function initBehaviors() : void
		{
			backBtn.addEventListener(MouseEvent.CLICK, onBackBtnClicked);
			backBtn.addEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
			backBtn.addEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
			
			clearBtn.addEventListener(MouseEvent.CLICK, onClearClicked);
			clearBtn.addEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
			clearBtn.addEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
			
			doneBtn.addEventListener(MouseEvent.CLICK, onDoneBtnCLicked);
			doneBtn.addEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
			doneBtn.addEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
			
			doneBtn.buttonMode = backBtn.buttonMode = clearBtn.buttonMode = true;	
		}
		
		private function getSquirrelPaintClass(paintColor:String) : *
		{
			var c;
			
			switch(paintColor)
			{
				case "gray" : 
					c = MudGray;
					break;
				case "chocolate" : 
					c = MudChocolate;
					break;
				case "tan" : 
					c = MudKhaki;
					break;
				default : 
					c = MudGray;
					break;
			}
			
			return c;
		}
		
		
		private function getInteractionID(s:String) : int
		{
			var id;
			
			switch(s)
			{
				case "deer":
					id = 4;
					break;
				case "squirrel":
					id = 5;
					break;
				case "sasplotch":
					id = 6;
					break;
				case "bear":
					id = 7;
					break;
				default:
					id = -1;
					break;
			}
			
			return id;
		}
	}

}
package com.smithandrobot.mud_u.views.ui 
{
	import fl.controls.*;
	import fl.data.DataProvider;
	import fl.controls.listClasses.*;
	import fl.events.*;
	
	import flash.net.*;
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.*;
	import flash.system.*;
	
	import com.greensock.*;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	
	import com.bigspaceship.utils.*;
	
	import com.smithandrobot.mud_u.views.ui.*;
	import com.smithandrobot.mud_u.interfaces.IScreen;
	import com.smithandrobot.utils.*;
	import com.smithandrobot.mud_u.views.ui.*;
	import com.smithandrobot.mud_u.MudUGATracker;
	
	public class PickUserPhotoScreen extends Sprite 
	{
		
		private var _mediator;
		private var _chooseBtnEnabled : Boolean;
		private var _rockwell = new RockwellBold();
		private var _bmpData : BitmapData;
		private var _imgLoaderStatus : ImageLoadStatus;
		private var _errorMessage : String;
		
		public function PickUserPhotoScreen(m)
		{
			super();
			_mediator = m;
			_mediator.getUserAlbums();
			jeep.jeep.gotoAndStop("in");
			cancelBtn.addEventListener(MouseEvent.CLICK, function(){ dispatchEvent(new Event("onPickPhotoCancel", true)) });
			cancelBtn.addEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
			cancelBtn.addEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
			cancelBtn.mouseChildren = false;
			jeep.addEventListener(MouseEvent.CLICK, onJeepClick);
			jeep.buttonMode = true;
			cancelBtn.buttonMode = true;
			albumStatus.toggleVisible(true, false);
			photoStatus.toggleVisible(false, false);
			
		}
		
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function set albums(d) : void 
		{	
			albumStatus.toggleVisible(false, true);
			
			var l = getChildByName("albumList") as List;
			l.rowHeight = 35;			
			l.labelField = "name";
			l.setRendererStyle("textFormat", getTextFormat());
			l.setStyle("embedFonts", true);
			l.dataProvider = new DataProvider(d);
			l.addEventListener(ListEvent.ITEM_CLICK, onAlbumSelected);
			l.selectedIndex = 0;
			
			var id = l.selectedItem.id;
			_mediator.getAlbumPhotos(id);
		};
		
		
		public function set albumPhotos(d) : void 
		{
			photoStatus.toggleVisible(false, true);
			var l = getChildByName("photos") as TileList;
			l.setStyle("cellRenderer", BrowserImageCell);
			l.sourceField = "picture";
			l.rowHeight = 80;
			l.columnWidth = 80;
			l.columnCount = 4;
			l.direction = "vertical";
			l.setRendererStyle("imagePadding", 5);
			l.dataProvider = new DataProvider(d);
			l.addEventListener(ListEvent.ITEM_CLICK, onPhotoSelected);
		};

		
		public function get bmpData() : BitmapData { return _bmpData; };
		
		public function get errorMessage() : String { return _errorMessage; };
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		public function animateIn() : void
		{
			jeep.jeep.gotoAndPlay("in");
			TweenMax.from(bkg, .25, {alpha:0});
			TweenMax.allFrom([albumList, photos], .25, {alpha:0});
			TweenMax.from(chooseBtn, .25, {y:"-10", alpha:0, ease:Back.easeOut});
			TweenMax.from(cancelBtn, .25, {delay:.15, y:"-10", alpha:0, ease:Back.easeOut});
			TweenMax.from(instructions, .25, {y:"+10", alpha:0});
		}
		
		public function animateOut() : void
		{	
			jeep.jeep.gotoAndPlay("out");
			TweenMax.to(chooseBtn, .25, {y:"+10", alpha:0, ease:Back.easeIn});
			TweenMax.to(instructions, .25, {y:"-10", alpha:0});
			TweenMax.to(cancelBtn, .25, {delay:.15, y:"+10", alpha:0, ease:Back.easeIn});
			TweenMax.to(photos, .25, {delay:.25, alpha:0});
			TweenMax.to(albumList, .25, {delay:.3, alpha:0});
			TweenMax.to(bkg, .25, {delay:.35, alpha:0, onComplete:remove});
		}
		
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function onAlbumSelected(e = null) : void
		{
			var pl = getChildByName("photos") as TileList;
			pl.dataProvider = new DataProvider();
			
			photoStatus.toggleVisible(true, true);
			var l = getChildByName("albumList") as List;
			var id = e.item.id;
			toggleChooseBtn(false);
			_mediator.getAlbumPhotos(id);
		}
		
		
		private function onPhotoSelected(e:ListEvent) : void
		{
			var l = getChildByName("photos") as TileList;
			var img = e.item.source;

			toggleChooseBtn(true);
		}
		
		private function onPhotoChosen(e:MouseEvent) : void
		{
			var l = getChildByName("photos") as TileList;
			var source = l.selectedItem.source;
			
			loadFile(source);
		}
		
		
		private function onCancel(e:MouseEvent) : void
		{
			dispatchEvent(new Event("onPickPhotoCancel", true));
		}
		
		
		private function onFileLoaded(e : Event) : void
		{
			_bmpData = e.currentTarget.content.bitmapData;
			_imgLoaderStatus.animateOut();
			dispatchEvent(new Event("onPhotoChosen", true));
		}
		
		
		private function onLoadError(e) : void
		{
			_imgLoaderStatus.animateOut();
			_errorMessage = "We couldn’t load the image\ryou selected.";
			dispatchEvent(new Event("screenError", true));	
		}
		
		private function onJeepClick(e) : void
		{
			MudUGATracker.trackOutboundClick("http://www.jeep.com");
			navigateToURL(new URLRequest("http://www.jeep.com"), "_blank");
		}
		
		
		private function mouseOverOutHandler(e:MouseEvent) : void
		{
			if(e.type == MouseEvent.MOUSE_OVER) TweenMax.to(e.target, .25, {scale:1.05});
			if(e.type == MouseEvent.MOUSE_OUT) TweenMax.to(e.target, .25, {scale:1});
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		
		private function getTextFormat() : TextFormat
		{
			var tf:TextFormat = new TextFormat();
			tf.font = _rockwell.fontName;
			tf.blockIndent = 15;
			tf.color = 0x4c4135;
			tf.size = 14;
			return tf;
		}
		
		private function toggleChooseBtn(b:Boolean = false) : void
		{
			if(_chooseBtnEnabled == b) return;
			
			_chooseBtnEnabled = b;
			var a = (b) ? 1 : .5;
			TweenMax.to(chooseBtn, .2, {alpha:a})
			if(_chooseBtnEnabled)
			{
				chooseBtn.addEventListener(MouseEvent.CLICK, onPhotoChosen);
				chooseBtn.addEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
				chooseBtn.addEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
				chooseBtn.mouseChildren = false;
				chooseBtn.buttonMode = true;
			}else{
				chooseBtn.removeEventListener(MouseEvent.CLICK, onPhotoChosen);
				chooseBtn.removeEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
				chooseBtn.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
				chooseBtn.buttonMode = false;
			}
		}
		
		
		public function remove() : void
		{
			dispatchEvent(new Event("onScreenOut"));
			parent.removeChild(this);
			toggleChooseBtn(false);
					
			TweenMax.to(instructions, .01, {y:"+10", alpha:1});
			TweenMax.to(chooseBtn, .01, {y:505.05, alpha:.5});
			TweenMax.to(cancelBtn, .01, {y:"-10", alpha:1});
			TweenMax.to(photos, .01, {alpha:1});
			TweenMax.to(albumList, .01, {alpha:1});
			TweenMax.to(bkg, .01, {alpha:1});
		}
		
		
		private function loadFile(f) : void
		{
			var url:String = f;
			var lc = new LoaderContext(true)
			_imgLoaderStatus = addChild(new ImageLoadStatus(this)) as ImageLoadStatus;
			_imgLoaderStatus.animateIn();
			var r:URLRequest = new URLRequest( url );
				r.method = URLRequestMethod.GET;

			var l:Loader = new Loader();
				l.contentLoaderInfo.addEventListener( Event.COMPLETE, onFileLoaded );
				l.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
				l.load( r, lc );
		}
	}

}
package com.smithandrobot.mud_u.views.ui 
{

	import fl.controls.List;
	import fl.controls.CheckBox;
	import fl.data.DataProvider;
	import fl.events.*;
	
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.*;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import com.adobe.images.JPGEncoder;
	
	import com.greensock.*;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	
	import com.smithandrobot.mud_u.interfaces.IScreen;
	import com.smithandrobot.mud_u.views.ui.MudviteCellRenderer;
	
	public class ShareScreen extends Sprite implements IScreen
	{		
		
		private var _form : MovieClip;
		private var _mediator;
		private var _rockwell 		= new RockwellBold();
		private var _friendsList : List;
		private var _addToGalleryCheck : CheckBox;
		private var _muddedPhoto : Bitmap;
		private var _overlay : Overlay = new Overlay();
		private var _shareScreen : ShareScreenFacebookStatus;
		private var _lastCellIndex = 99999;
		
		public function ShareScreen(m = null)
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
			
			_form = form;
			_mediator = m;
			_addToGalleryCheck = form.addToGallery;
			_addToGalleryCheck.selected = true;
 			_friendsList = form.getChildByName("friendsList") as List;
			_friendsList.addEventListener(MouseEvent.CLICK, onCellRenderClick);
			
			tagBrowser.visible = false;
			instructionPanel.visible = false;
			
			styleAndInitCheckBoxes();
			
			TweenMax.to(downloadBtn, .002, {scaleX: 0, scaleY:0, alpha:0});
			initButtons();
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		


		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function set data(d) : void {};
		
		public function set friends(d) : void
		{
			var dp = new DataProvider(d);
			var tagDP = new DataProvider(d);
			
			var meObj = new Object();
			meObj.name = _mediator.getFBProxy().name;
			meObj.id = _mediator.getFBProxy().uid;
			
			tagDP.addItemAt(meObj,0);
			
			_friendsList.labelField = "name";
			_friendsList.rowHeight = 30;
			_friendsList.setStyle('cellRenderer', MudviteCellRenderer);
			_friendsList.dataProvider = dp;
			_friendsList.setRendererStyle("textFormat", getTextFormat());
			_friendsList.setStyle("embedFonts", true);
			
			_friendsList.selectedIndex = -1;
			
			tagBrowser.tagList.labelField = "name";
			tagBrowser.tagList.rowHeight = 30;
			tagBrowser.tagList.setStyle('contentPadding', 5);
			tagBrowser.tagList.setStyle('cellRenderer', MudviteCellRenderer);
			tagBrowser.tagList.setRendererStyle("textFormat", getTextFormat());
			tagBrowser.tagList.setStyle("embedFonts", true);
			tagBrowser.tagList.dataProvider = tagDP;
			tagBrowser.tagList.selectedIndex = -1;
			tagBrowser.tagList.selectedItems = [];
			
			ls.toggleVisible(false, true);
			
		}
		
		public function set shareStatus(status) : void
		{
			_shareScreen.fbstatus = status;
		}
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
	
		public function animateIn() : void
		{
			TweenMax.from(this, .1, {alpha:0});
			frame.y = -427;
			backBtn.y = -backBtn.height;
			copy.x = 403;
			copy.alpha = shareBtn.alpha = 0
			shareBtn.y = 504;
			
			TweenMax.to(frame, .15, {y:125, ease:Back.easeOut, easeParams:[2]});
			TweenMax.to(backBtn, .4, {delay:.1, y:16.55, ease:Bounce.easeOut});
			TweenMax.to(skipBtn, .4, {delay:.1, y:16.55, ease:Bounce.easeOut});
			TweenMax.to(copy, .2, {delay:.2, x: 413.75, alpha:1, ease:Back.easeOut});
			TweenMax.to(shareBtn, .2, {delay:.25, y: 475, alpha:1, ease:Back.easeOut});
			TweenMax.to(downloadBtn, .2, {delay:.25, scaleX: 1, scaleY:1, alpha:1, ease:Back.easeOut});
		}
		
		
		public function animateOut() : void
		{
			TweenMax.to(this, .41, {alpha:0,  onComplete:remove});	
			TweenMax.to(frame, .2, {y:-427, ease:Back.easeIn, easeParams:[2]});
			TweenMax.to(backBtn, .2, {delay:.1, y:-backBtn.height, ease:Back.easeIn});
			TweenMax.to(skipBtn, .2, {delay:.1, y:-backBtn.height, ease:Back.easeIn});
			TweenMax.to(copy, .2, {delay:.2, x: 403, alpha:0, ease:Back.easeIn});
			TweenMax.to(shareBtn, .2, {delay:.2, y: 455, alpha:0, ease:Back.easeIn});
			TweenMax.to(downloadBtn, .2, {delay:.25, scaleX: 0, scaleY:0, alpha:0, ease:Back.easeOut});
		}
		

		public function remove() : void
		{
			tagBrowser.tagList.selectedItems = [];
			parent.removeChild(this);
			dispatchEvent(new Event("onScreenOut"));
			TweenMax.to(downloadBtn, .002, {scaleX: 0, scaleY:0, alpha:0});
			alpha = 1;
		}



		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		private function onAdded(e:Event) : void
		{
			if(_mediator) 
			{
				ls.toggleVisible(true, true);
				_mediator.getFriends();
				addMuddedPhoto();
			}
		}

		
		private function onCellRenderClick(e) : void
		{
			if(_friendsList.selectedIndex == _lastCellIndex)
			{
				_friendsList.selectedIndex = -1;
				_lastCellIndex = 999;
			}else{
				_lastCellIndex = _friendsList.selectedIndex;
			}
		}
		
		
		private function onShareIt(e:Event = null) : void
		{
			// dispatchEvent(new Event("onShareScreenFinshed", true));
			var bmpData = new BitmapData(289,250);
			bmpData.draw(frame.imgContainer);
			
			if(!_shareScreen)  
			{
				_shareScreen = addChild(new ShareScreenFacebookStatus(this)) as ShareScreenFacebookStatus;
				_shareScreen.addEventListener("onShareCompleted", function(){dispatchEvent(new Event("onShareScreenFinshed", true));})
			}

			for(var i in tagBrowser.tagList.selectedItems)
			{
				trace("*** friends: "+tagBrowser.tagList.selectedItems[i].name)
			}

			if(tagBrowser.tagList.selectedItems.length > 0)
			{
				trace("** sending tags, tags length: "+tagBrowser.tagList.selectedItems.length);
				_shareScreen.tags = tagBrowser.tagList.selectedItems;
			}else{
				trace("** NOT sending tags, tags length: "+tagBrowser.tagList.selectedItems.length);
				_shareScreen.tags = false
			}
		    /*_shareScreen.tags = (tagBrowser.tagList.selectedItems.length > 0) ? tagBrowser.tagList.selectedItems : false;*/
		    _shareScreen.posts = (_friendsList.selectedItem) ? _friendsList.selectedItem.id : null;
		    _shareScreen.addToGallery = (_addToGalleryCheck.selected) ? _addToGalleryCheck.selected : null;

		    _shareScreen.photo = bmpData;
		    _shareScreen.fbProxy = _mediator.getFBProxy();
			_shareScreen.appProxy = _mediator.getAppProxy();
			_shareScreen.apiProxy = _mediator.getAPIProxy();
			
			if(!_shareScreen.parent) addChild(_shareScreen);
			_shareScreen.start();
		}
		
		
		private function onOpenTagBrowser(e:Event = null) : void
		{

			if(!_overlay.parent) 
			{
				_overlay.alpha = 0;
				addChild(_overlay);
			}
			
			setChildIndex(_overlay, numChildren-1);
			setChildIndex(tagBrowser, numChildren-1);
			
			TweenMax.to(_overlay, .2, {alpha:1});
			TweenMax.to(tagBrowser, .2, {autoAlpha:1});			
		}
		
		
		private function onCloseTagBrowser(e:Event = null) : void
		{
			var func = function()
			{
				if(_overlay.parent) removeChild(_overlay)
			}
			
			TweenMax.to(_overlay, .2, {alpha:0, onComplete:func});
			TweenMax.to(tagBrowser, .2, {autoAlpha:0});	
		}
		
		
		private function onOpenInstructions(e:Event = null) : void
		{

			if(!_overlay.parent) 
			{
				_overlay.alpha = 0;
				addChild(_overlay);
			}
			
			setChildIndex(_overlay, numChildren-1);
			setChildIndex(instructionPanel, numChildren-1);
			
			TweenMax.to(_overlay, .2, {alpha:1});
			TweenMax.to(instructionPanel, .2, {autoAlpha:1});			
		}
		
		
		private function onCloseInstructions(e:Event = null) : void
		{
			var func = function()
			{
				if(_overlay.parent) removeChild(_overlay)
			}
			
			TweenMax.to(_overlay, .2, {alpha:0, onComplete:func});
			TweenMax.to(instructionPanel, .2, {autoAlpha:0});	
		}
		
		private function onDownload(e:Event) : void
		{
			var bmpData = new BitmapData(288,250);
			bmpData.draw(frame.imgContainer);
			
			var encoder = new JPGEncoder(100);
			var fileRef = new FileReference();
		
			var ba:ByteArray = encoder.encode(bmpData);
			fileRef.save(ba, "mud_u_image.jpg");
			ba.clear();
		}
		
		
		private function onSkip(e:MouseEvent) : void
		{
			var appProxy = _mediator.getAppProxy();
			appProxy.shareActions = null;
			dispatchEvent(new Event("onShareScreenFinshed", true));
		}
		
		
		private function mouseOverOutHandler(e:MouseEvent) : void
		{
			if(e.type == MouseEvent.MOUSE_OVER) TweenMax.to(e.target, .25, {scale:1.05});
			if(e.type == MouseEvent.MOUSE_OUT) TweenMax.to(e.target, .25, {scale:1});
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		

		
		private function addMuddedPhoto() : void
		{
			_muddedPhoto = _mediator.getMuddedPhoto();
			frame.imgContainer.addChild(_muddedPhoto);
		}
		
		
		private function initButtons() : void
		{
			backBtn.addEventListener(MouseEvent.CLICK, function(){dispatchEvent(new Event("onShareScreenBackBtn"))});
			backBtn.addEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
			backBtn.addEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
			
			backBtn.buttonMode = true;
			
			shareBtn.addEventListener(MouseEvent.CLICK, onShareIt);
			shareBtn.addEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
			shareBtn.addEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
			shareBtn.buttonMode = true;
			
			skipBtn.addEventListener(MouseEvent.CLICK, onSkip);
			skipBtn.addEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
			skipBtn.addEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
			skipBtn.buttonMode = true;
			
			frame.addEventListener(MouseEvent.CLICK, onOpenTagBrowser);
			frame.buttonMode = true;
			
			tagBrowser.closeBtn.addEventListener(MouseEvent.CLICK, onCloseTagBrowser);
			tagBrowser.closeBtn.buttonMode = true;
			
			tagBrowser.tagBtn.addEventListener(MouseEvent.CLICK, onCloseTagBrowser);
			tagBrowser.tagBtn.buttonMode = true;
			                                    
			downloadBtn.addEventListener(MouseEvent.CLICK, onDownload);
			downloadBtn.addEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
			downloadBtn.addEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
			downloadBtn.buttonMode = true;
			
			ribbon.addEventListener(MouseEvent.CLICK, onOpenInstructions);
			ribbon.addEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
			ribbon.addEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
			ribbon.buttonMode = true;
			
			instructionPanel.okBtn.addEventListener(MouseEvent.CLICK, onCloseInstructions);
			instructionPanel.okBtn.addEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
			instructionPanel.okBtn.addEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
			instructionPanel.okBtn.buttonMode = true;
		}
		
		
		private function getTextFormat() : TextFormat
		{
			var tf:TextFormat = new TextFormat();
			tf.font = _rockwell.fontName;
			tf.blockIndent = 5;
			tf.color = 0x4c4135;
			tf.bold =true;
			tf.size = 15;
			return tf;
		}
		
		
		private function styleAndInitCheckBoxes() : void
		{
			var f = getTextFormat();
			f.color = 0x567140;
			f.size = 15;
			f.bold = false;
		
			
			_addToGalleryCheck.setStyle("embedFonts", true);
			_addToGalleryCheck.setStyle("textFormat", f );
			_addToGalleryCheck.setStyle("textPadding", 2);
			_addToGalleryCheck.label = "Add Photo to Adventure U Gallery";


			_addToGalleryCheck.addEventListener(MouseEvent.ROLL_OUT,fixText);
            _addToGalleryCheck.addEventListener(MouseEvent.MOUSE_OVER,fixText);
            _addToGalleryCheck.addEventListener(MouseEvent.MOUSE_DOWN,fixText);
            _addToGalleryCheck.addEventListener(MouseEvent.CLICK,fixText);

			fixText();
		}
		
		
		private function fixText(e:MouseEvent = null)  :void
		{	
			_addToGalleryCheck.drawNow();
			_addToGalleryCheck.textField.width = _addToGalleryCheck.textField.textWidth+30;	
		}
	}

}


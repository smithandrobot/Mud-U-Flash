package com.smithandrobot.mud_u.views.ui 
{

	import fl.controls.*;
	import fl.data.DataProvider;
	import fl.events.*;
	
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.*;
	import flash.utils.ByteArray;
	
	import com.greensock.*;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	
	import com.smithandrobot.mud_u.interfaces.IScreen;
	import com.smithandrobot.mud_u.views.ui.MudviteCellRenderer;
	
	public class FinishScreen extends Sprite implements IScreen
	{		

		private var _mediator;
		private var _rockwell = new RockwellBold();
		private var _friendsList : TileList;
		private var _friendsData : Array;
		private var _friendsUsingAppData : Array;
		
		public function FinishScreen(m = null)
		{
			_mediator = m;
			alpha = 1;
			var fb = getChildByName("friendBrowser") as MovieClip;
 			_friendsList = friendBrowser.getChildByName("friendsList") as TileList;
			_friendsList.addEventListener(ListEvent.ITEM_CLICK, onFriendListClick);
			shareActions = _mediator.getAppProxy().shareActions;
			initButtons();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		


		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		
		public function set data(d) : void {};
		
		public function set friends(d) : void
		{
			var a = clone(d);

			_friendsData = a;
			
			if(_friendsUsingAppData)
			{
				sortData();
			}
		}


		public function set friendsUsingApp(d) : void
		{
			_friendsUsingAppData = d;
			
			if(_friendsData)
			{
				sortData();
			}
		}
		
		
		private function set shareActions(o:Object) : void
		{

			if(o == null)
			{
				feedbackBox.t.visible = false;
				feedbackBox.check.visible = false;
				return;
			}
			
			trace("Setting action results:\r"+
			"\ro.postedToWall: "+o.postedToWall+
			"\ro.photoTagged: "+o.photoTagged+
			"\ro.photoUploadedToMudUAlbum: "+o.photoUploadedToMudUAlbum);

			
			feedbackBox.t.visible = true;
			feedbackBox.check.visible = true;
			var textArray = new Array();
			textArray.push("Your Mud U photo has been uploaded to your Mud U album");
			
			
			if (o.postedToWall) textArray.push("posted to your friend’s wall");
			if (o.photoTagged) textArray.push("tagged");
			if(o.photoUploadedToMudUAlbum) textArray.push("uploaded to the Mud U Application album");
			
			var statusText = textArray[0];
			
			if(textArray[1] && textArray[2]) statusText += ", "+textArray[1];
			if(textArray[1] && !textArray[2]) statusText += " and "+textArray[1];
			
			if(textArray[2] && textArray[3]) statusText += ", "+textArray[2];
			if(textArray[2] && !textArray[3]) statusText += " and "+textArray[2];
			
			
			statusText += ".";
			feedbackBox.t.text = statusText;
		}
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
	
		public function animateIn() : void
		{
			shareActions = _mediator.getAppProxy().shareActions;
			
			TweenMax.from(this, .1, {alpha:0});
			TweenMax.from(feedbackBox, .25, {scaleX:0, scaleY:0, alpha:0, ease:Back.easeOut});
			TweenMax.from(backBtn, .3, {y:"-100", ease:Bounce.easeOut});
			TweenMax.from(title, .25, {delay:.12, x:"-10", alpha:0, ease:Back.easeOut});
			TweenMax.from(friendBrowser, .25, {delay:.12, alpha:0, ease:Back.easeOut});
		}
		
		
		public function animateOut() : void
		{
			TweenMax.to(this, .39, {alpha:0,  onComplete:remove});
			TweenMax.to(feedbackBox, .25, {scaleX:0, scaleY:0, alpha:0, ease:Back.easeOut});
			TweenMax.to(backBtn, .3, {alpha:0});
			TweenMax.to(title, .25, {delay:.12, x:"-10", alpha:0, ease:Back.easeOut});
			TweenMax.to(friendBrowser, .25, {delay:.12, alpha:0, ease:Back.easeOut});	
		}
		

		public function remove() : void
		{
			parent.removeChild(this);
			alpha = 1;
			feedbackBox.scaleX = feedbackBox.scaleY = feedbackBox.alpha = 1;
			title.x = 32;
			title.alpha = 1;
			friendBrowser.alpha = 1;
			backBtn.alpha = 1;
			dispatchEvent(new Event("onScreenOut"));
		}


		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		private function onAdded(e:Event) : void
		{
			_mediator.getFriends();
			_mediator.getFriendsUsingApplication();
		}
		
		
		private function onFriendListClick(e:ListEvent) : void
		{
			_mediator.setFriendToMud(e.item.id);
			dispatchEvent(new Event("onMudSelectedFriend"));
		}
		
		
		private function onBackBtnClicked(e:MouseEvent) : void
		{
			dispatchEvent(new Event("onFinishScreenBack"));
		}
		
		
		private function mouseOverOutHandler(e:MouseEvent) : void
		{
			if(e.type == MouseEvent.MOUSE_OVER) TweenMax.to(e.target, .25, {scale:1.05});
			if(e.type == MouseEvent.MOUSE_OUT) TweenMax.to(e.target, .25, {scale:1});
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function initButtons() : void
		{
			feedbackBox.addEventListener(MouseEvent.CLICK, function(){dispatchEvent(new Event("onMudAgain"))});
			feedbackBox.mudAgain.addEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
			feedbackBox.mudAgain.addEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
			feedbackBox.mudAgain.mouseChildren = false;
			
			backBtn.addEventListener(MouseEvent.CLICK, onBackBtnClicked);
			backBtn.addEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
			backBtn.addEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
			
			backBtn.buttonMode = feedbackBox.buttonMode = true;
			
			homeBtn.addEventListener(MouseEvent.CLICK, function(){dispatchEvent(new Event("onMudAgain"))});
			homeBtn.buttonMode = feedbackBox.buttonMode = true;
			/*shareBtn.addEventListener(MouseEvent.CLICK, onShareIt);
			shareBtn.buttonMode = true;*/
		}
		
		
		private function getTextFormat() : TextFormat
		{
			var tf:TextFormat = new TextFormat();
			tf.font = _rockwell.fontName;
			tf.color = 0x362f2d;
			tf.bold =false;
			tf.size = 9;
			tf.align = "left";
			return tf;
		}
		
		
		private function sortData() : void
		{
			var currId;
			var func = function(o, i) 
			{ 
				if(o.id == currId) 
				{
					o.usesApp = "a";
				}
			}

			for(var i in _friendsUsingAppData)
			{
				currId = _friendsUsingAppData[i]
				_friendsData.forEach(func);
			}
			
			_friendsData.forEach(addReturn);
			
			addDataToList();
		}
		
		private function addReturn(o, i, a) : void
		{
			var n = o.name.split(" ");
			if(n[1]) o.name = n[0]+"\r"+n[1];
		}
		
		
		private function addDataToList()
		{
			var dp = new DataProvider(_friendsData);
			dp.sortOn("usesApp");
			_friendsList.labelField = "name";
			_friendsList.sourceField = "picture";
			_friendsList.setStyle('cellRenderer', BrowserImageCell);
			_friendsList.setStyle('contentPadding', 0);
			var renderer = _friendsList.getStyle('cellRenderer');
			renderer.scaleContent = false;
			_friendsList.setRendererStyle("textFormat", getTextFormat());
			_friendsList.setRendererStyle("imagePadding", 15);
			_friendsList.setRendererStyle("textOverlayAlpha", 0);
			_friendsList.setStyle("embedFonts", true);
			_friendsList.rowHeight = 90;
			_friendsList.columnWidth = 80;
			_friendsList.direction = "vertical";
			_friendsList.dataProvider = dp;
		}
		
		
		private function clone(source:Object) : *
		{
			var myBA:ByteArray = new ByteArray();
			myBA.writeObject(source);
			myBA.position = 0;
			return(myBA.readObject());
		}
	}

}


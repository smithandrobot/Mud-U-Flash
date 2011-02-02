package com.smithandrobot.mud_u.views.ui 
{

	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.*;
	import flash.external.*;
	
	import com.greensock.*;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	
	import com.smithandrobot.utils.*;
	
	public class StatusBar extends Sprite 
	{		
		 
		private var _rockwellBold = new RockwellBold();
		private var _rockwellReg = new RockwellRegular();
		private var _uID;
		private var _inviteStatusTimer : Timer;
		
		public function StatusBar()
		{
			status = 1;
			s1.embedFonts = true;
			s2.embedFonts = true;
			s3.embedFonts = true;
			TweenMax.from(this, .65, {delay:0, alpha:0, y:"-150", ease:Bounce.easeOut});
			_inviteStatusTimer = new Timer(100, 0);
			_inviteStatusTimer.addEventListener(TimerEvent.TIMER, checkInviteStatus);
			root.addEventListener("onMudvite", onMudvite)
			initBehaviors();
		}
		


		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		
		public function set status(sNum:int) : void
		{
			
			var bold = getTextFormat(true);
			var regular = getTextFormat();
			var i : int = 1;
			var total : int = 3;
			var txtField : TextField;
			
			for(i; i<= total; i++)
			{
				txtField = this["s"+String(i)];
				if(i == sNum) 
				{
					txtField.setTextFormat(bold);
					//txtField.text = "Hi Y'all";
					txtField.autoSize = "left";
				}
				if(i != sNum) txtField.setTextFormat(regular);
			}
		}


		public function set uID(s:String) : void { _uID = s; };
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
	
		public function animateIn() : void
		{

		}
		
		public function animateOut() : void
		{
			TweenMax.to(this, .25, {alpha:0});	
		}



		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		private function onMudvite(e:* = null) : void
		{
			trace("heard mudvite");
			if(Environment.IS_LOCAL)
			{
				dispatchEvent(new Event("onUserInvite", true));
				return;
			}
			
			ExternalInterface.call("showInvite", _uID);
			ExternalInterface.call("setInviteState", "open");
			_inviteStatusTimer.reset();
			_inviteStatusTimer.start();
		}
		
		
		
		private function mouseOverOutHandler(e:MouseEvent) : void
		{
			if(e.type == MouseEvent.MOUSE_OVER) TweenMax.to(e.target, .25, {scale:1.05});
			if(e.type == MouseEvent.MOUSE_OUT) TweenMax.to(e.target, .25, {scale:1});
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		
		private function checkInviteStatus(e:TimerEvent) : void
		{	
			
			var status = ExternalInterface.call("getInviteState");
 
			if(status == "closedSuccess")
			{
				_inviteStatusTimer.stop();
				ExternalInterface.call("setInviteState", "closed");
				dispatchEvent(new Event("onUserInvite", true));
			}
			 
			if(status == "closedCancel")
			{
				_inviteStatusTimer.stop();
				ExternalInterface.call("setInviteState", "closed");
			} 
		}
		
		
		private function getTextFormat(selected : Boolean = false) : TextFormat
		{
			var tf:TextFormat = new TextFormat();
			tf.font = (selected) ? _rockwellBold.fontName : _rockwellReg.fontName;
			/*tf.blockIndent = 15;*/
			tf.bold = (selected) ? true : false;
			tf.color = 0x4C4135;
			tf.size = 18;
			return tf;
		}
		
		private function initBehaviors() : void
		{
			postAmudvite.addEventListener(MouseEvent.CLICK, onMudvite);
			postAmudvite.addEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
			postAmudvite.addEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
			postAmudvite.mouseChildren = false;
			postAmudvite.buttonMode = true;
		}
		
	}

}


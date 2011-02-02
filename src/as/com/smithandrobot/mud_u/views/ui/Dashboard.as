package com.smithandrobot.mud_u.views.ui 
{

	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.Point;
	
	import com.greensock.*;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	
	public class Dashboard extends Sprite 
	{
		
		private var _scoreboardData;
		private var _scoreboardNoData;
                    
		private var _ribbonData;
		private var _ribbonNoData;
		            
		private var _friendStatsData;
		private var _friendStatsNoData;
		
		public function Dashboard()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			y = 643;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		
		public function set data(d) : void
		{
			setRibbon(d);
			setScoreboard(d);
			setFriendStatus(d);
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		private function onAdded(e:Event) : void
		{
			TweenMax.from(bkg, .5, {alpha:0});
			TweenMax.from(headline, .5, {x:"-5", alpha:0});
			TweenMax.from(scoreboard, .2, {delay:.2, ease:Back.easeOut, scaleX:.2, scaleY:.2, alpha:0});
			TweenMax.from(ribbon, .2, {delay:.25, ease:Back.easeOut, y:"-15", alpha:0});
			TweenMax.from(allTeamLeaders, .2, {delay:.3, ease:Back.easeOut, scaleX:.2, scaleY:.2, alpha:0});
			TweenMax.from(thisWksLeaders, .2, {delay:.4, ease:Back.easeOut, scaleX:.2, scaleY:.2, alpha:0});
			
			allTeamLeaders.addEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
			allTeamLeaders.addEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
			allTeamLeaders.addEventListener(MouseEvent.CLICK, mouseOverOutHandler);
			
			thisWksLeaders.addEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
			thisWksLeaders.addEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
			thisWksLeaders.addEventListener(MouseEvent.CLICK, mouseOverOutHandler);
		}
		
		
		private function mouseOverOutHandler(e:MouseEvent) : void
		{
			if(e.type == MouseEvent.MOUSE_OVER) TweenMax.to(e.target, .25, {scale:1.05});
			if(e.type == MouseEvent.MOUSE_OUT) TweenMax.to(e.target, .25, {scale:1});
		}
		
		
		public function openInviteModal(e=null) : void
		{
			dispatchEvent(new Event("onMudvite", true));
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function setRibbon(d)
		{
			var delay = 0;

			if(d.hasOwnProperty("rank"))
			{
				if(_ribbonNoData.hasOwnProperty("parent"))
				{
					delay = .2;
					TweenMax.to(_ribbonNoData, .2, {alpha:0, scaleX:.2, scaleY:.2, ease:Back.easeIn, onComplete:function(){removeView(_scoreboardNoData)}});
				}
				
				if(!_ribbonData)
				{
					_ribbonData = ribbon.addChild(new RibbonData()) as MovieClip;
					_ribbonData.y = -10;
					TweenMax.from(_ribbonData, .2, {delay:delay, alpha:0, scaleX:.2, scaleY:.2, ease:Back.easeOut});	
				}
					_ribbonData.overAllRank.text = addRankFormatting(formatNumber(d.rank));
					_ribbonData.thisWeekRank.text = addRankFormatting(formatNumber(d.weekRank))+"\rthis week";
			}else{
				
				_ribbonNoData = ribbon.addChild(new RibbonNoData()) as MovieClip;
				_ribbonNoData.x = 1;
				_ribbonNoData.y = -21;
				TweenMax.from(_ribbonNoData, .2, {alpha:0, scaleX:.2, scaleY:.2, ease:Back.easeOut});
			}
		}
		
		
		private function setScoreboard(d)
		{
			var delay = 0;
			if( d.hasOwnProperty("photosMudded") || d.hasOwnProperty("photosShared") ||
				d.hasOwnProperty("mudvites") || d.hasOwnProperty("mudprops"))
			{
				if(_scoreboardNoData.hasOwnProperty("parent"))
				{
					delay = .15;
					TweenMax.to(_scoreboardNoData, .2, {alpha:0, scaleX:.2, scaleY:.2, ease:Back.easeIn, onComplete:function(){removeView(_scoreboardNoData)}});
				}
				if(!_scoreboardData)
				{
					_scoreboardData = scoreboard.addChild(new ScoreboardData());
					_scoreboardData.x = -17;
					TweenMax.from(_scoreboardData, .2, {delay:delay, alpha:0, scaleX:.2, scaleY:.2, ease:Back.easeOut});
				}
			}else{
				_scoreboardNoData = scoreboard.addChild(new ScoreboardNoData());
				_scoreboardNoData.x = -26;
				_scoreboardNoData.y = -12;
				TweenMax.from(_scoreboardNoData, .2, {alpha:0, scaleX:.2, scaleY:.2, ease:Back.easeOut});
			}
		}
		
		
		private function setFriendStatus(d) : void
		{
			if( d.hasOwnProperty("numberOfFriendsUsing") )
			{
				var delay = 0;
				
				if(_friendStatsNoData.hasOwnProperty("parent"))
				{
					TweenMax.to(_friendStatsNoData, .2, {x:"-5", alpha:0, ease:Back.easeOut, onComplete:function(){removeView(_friendStatsNoData)}});
					delay = .15;
				}
				
				if(!_friendStatsData)
				{
					_friendStatsData = friendStats.addChild(new FriendsStatsData()) as MovieClip;
					_friendStatsData.x 	   	= 130;
					_friendStatsData.y 	   	= 94;
					TweenMax.from(_friendStatsData, .2, {delay:delay, alpha:0});
				}
			}else{
				_friendStatsNoData = friendStats.addChild(new FriendsStatsNoData()) as MovieClip;
				_friendStatsNoData.x = 133;
				_friendStatsNoData.y = 76;

				var b = _friendStatsNoData.getChildByName("postAmudvite") as MovieClip;
				b.addEventListener(MouseEvent.CLICK, openInviteModal);
				b.addEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
				b.addEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
				b.mouseChildren = false;
				b.buttonMode = true;
				
				TweenMax.from(_friendStatsNoData, .2, {x:"-5", alpha:0, ease:Back.easeOut});
			}
		}
		
		
		private function formatNumber(n) : String
		{
			var numString = String(n);
			numString = numString.replace(/(\d)(?=(\d\d\d)+$)/g, "$1,")
			return numString;
		}
		
		
		private function addRankFormatting(s) : String
		{
			var orgS = s;
			var total = s.length-1;
			var last = s.slice(-1);
			var fmt="";
			
			if(int(last) == 0 )fmt 	= "th";
			if(int(last) == 1) fmt  = "st";
			if(int(last) == 2) fmt  = "nd";
			if(int(last) == 3) fmt  = "rd";
			if(int(last) > 3 ) fmt  = "th";
			
			return orgS+fmt;
		}
		
		private function removeView(v) : void
		{
			trace('attempting to remove: '+v);
			if(v.parent)
			{
				v.parent.removeChild(v);
				trace('removing: '+v+' its parent is: '+v.parent);
			}
		}
	}

}


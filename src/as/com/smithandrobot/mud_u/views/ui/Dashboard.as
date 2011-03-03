package com.smithandrobot.mud_u.views.ui 
{

	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.Point;
	import flash.net.*;
	
	import com.greensock.*;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	
	import com.smithandrobot.mud_u.MudUGATracker;
	
	public class Dashboard extends Sprite 
	{
		
		private var _scoreboardData;
		private var _scoreboardNoData;
                    
		private var _ribbonData;
		private var _ribbonNoData;
		            
		private var _friendStatsData;
		private var _friendStatsNoData;
		
		private var _friends;
		private var _playerData;
		
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
			_playerData = d.data.stats;
			setRibbon(d.data.stats);
			setScoreboard(d.data.stats);
			if(_friends) setFriendStatus(d.data.stats);
		}
		
		
		public function set friends(d) : void
		{
			_friends = d;
			if(_playerData) setFriendStatus(_playerData);
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
			allTeamLeaders.addEventListener(MouseEvent.CLICK, onClick);
			
			thisWksLeaders.addEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
			thisWksLeaders.addEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
			thisWksLeaders.addEventListener(MouseEvent.CLICK, onClick);
			
			thisWksLeaders.buttonMode = true;
			allTeamLeaders.buttonMode = true;
		}
		
		
		private function mouseOverOutHandler(e:MouseEvent) : void
		{
			if(e.type == MouseEvent.MOUSE_OVER) TweenMax.to(e.target, .25, {scale:1.05});
			if(e.type == MouseEvent.MOUSE_OUT) TweenMax.to(e.target, .25, {scale:1});
		}
		
		private function onClick(e:MouseEvent) : void
		{
			MudUGATracker.trackOutboundClick("http://www.facebook.com/AdventureU?sk=app_4949752878");
			navigateToURL(new URLRequest("http://www.facebook.com/AdventureU?sk=app_4949752878"), "_blank");
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
				if(_ribbonNoData && _ribbonNoData.hasOwnProperty("parent"))
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
				if(_scoreboardNoData && _scoreboardNoData.hasOwnProperty("parent"))
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
				
				if(_scoreboardData)
				{
		   			_scoreboardData.photosMudded.text = d.photosMudded;
		   			_scoreboardData.photosShared.text = d.photosShared;
		   			_scoreboardData.mudvites.text = d.mudvites;
		   			_scoreboardData.mudProps.text = d.mudprops+" Mud Props";
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
			if( d.hasOwnProperty("friendsData") )
			{
				var total = 0;
				var delay = 0;
				var friendsUsingApp;
				var d;
				var offset = 90;
				var start = -90;
				var text1 = " of your friends is a Mud Challenger";
				var text2 = " of your friends are Mud Challengers";
				
				if(_friendStatsNoData && _friendStatsNoData.hasOwnProperty("parent"))
				{
					TweenMax.to(_friendStatsNoData, .2, {x:"-5", alpha:0, ease:Back.easeOut, onComplete:function(){removeView(_friendStatsNoData)}});
					delay = .15;
				}
				
				if(!_friendStatsData)
				{
					_friendStatsData = friendStats.addChild(new FriendsStatsData()) as FriendsStatsData;
					_friendStatsData.x 	   	= 130;
					_friendStatsData.y 	   	= 94;
					total 					= (d.friendsData.length-1 > 2) ? 2 : d.friendsData.length-1;
					TweenMax.from(_friendStatsData, .2, {delay:delay, alpha:0});
					var h1Text = (total > 0) ? "Top "+String(total+1)+" Friends" : "Top Friend";
					var h2Text = (d.friendsData.length > 1) ? String(d.friendsData.length)+text2 : String(d.friendsData.length)+text1;

					_friendStatsData.headline.text 	 	= h1Text;
			   		_friendStatsData.friendCount.text	= h2Text;
			   		friendsUsingApp 				 	= getFriendsUsingApp(d.friendsData);
			   		
			   		
			   		for(var i = 0; i<= total; i++)
			   		{
			   			d = _friendStatsData.addChild(new DashboardFriendModule(friendsUsingApp[i]));
			   			d.x = start + (i*offset);
			   			d.y = 38
			   		}
				}

				
			}else{
				trace("no friendsData property")
				if(_friendStatsNoData) return;
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
			var p = v.parent;
			if(p != null)
			{
				p.removeChild(v);
			}
		}
		
		private function clone(source:Object) : *
		{
			var myBA:ByteArray = new ByteArray();
			myBA.writeObject(source);
			myBA.position = 0;
			return(myBA.readObject());
		}
		
		private function getFriendsUsingApp(d) : Array
		{
			if(!_friends) return new Array();
			
			var currId;
			var currRank;
			var friends = new Array();
			var f;
			
			var func = function(o, i) 
			{ 
				if(o && o.id == currId) 
				{
					f = friends.push(clone(o));
					friends[f-1].name += "\r"+"#"+currRank;
					trace(friends[f-1].name)
				}
			}

			for(var i in d)
			{
				if(d[i].hasOwnProperty("id")) 
				{
					currId = d[i].id;
				}else{trace("no id on obj")}
				
				if(d[i].hasOwnProperty("rank")) 
				{
					currRank = d[i].rank;
				}else{trace("no rank on object")};
				
				_friends.forEach(func);
			}
			
			friends.forEach(addReturn);
			return friends;
		}
		
		private function addReturn(o, i, a) : void
		{
			var n = o.name.split(" ");
			if(n[1]) o.name = n[0]+"\r"+n[1];
		}
	}

}


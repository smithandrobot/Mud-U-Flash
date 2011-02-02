package com.smithandrobot.mud_u.views.ui.characterpanels
{

	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.Point;
	import flash.filters.*;
	
	import com.greensock.*;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	
	import com.smithandrobot.mud_u.interfaces.*;
	import com.smithandrobot.utils.*;
		
	public class SasplotchPanel extends Sprite implements ICharacterPanel
	{
		
		private var _locked : Boolean;
		private var _sasplotch : MovieClip;
		private var _ctaPanel : MovieClip;
		private var _game : SasplotchGame;
		private var _frame : MovieClip;
		private var _bf = new BlurFilter(10,0,1);
		private var _state = "closed";
		
		public function SasplotchPanel()
		{
			alpha = 0;
			_sasplotch = lockedSasplotch;
			_game = getChildByName("game") as SasplotchGame;
			addEventListener("onThrow", onThrow);
			addEventListener("sasplotchThrow", sasplotchThrow);
			locked = true;
			ctaPanelUnlocked.visible = false
			bkgPanel.visible = false;
			bkgPanel.closeBtn.addEventListener(MouseEvent.CLICK, close);
			bkgPanel.closeBtn.buttonMode = true;			
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get type() : String
		{
			return "sasplotch";
		}
		
		public function set frame(f) : void {_frame = f; };
		public function get locked() : Boolean { return _locked; };
		public function set locked(b:Boolean) : void 
		{ 
			_locked = b;
			enable(!_locked);
			enableSasplotch(_locked);
			if(!b)
				{
					if(_locked)TweenMax.to(ctaPanelLocked, .2, {scaleX: 0, scaleY: 0, alpha:0})
					//if(!_locked) TweenMax.to(ctaPanelUnlocked, .2, {autoAlpha:1})
					unlockedSasplotch.getChildByName("mud").alpha = 0;
				}
		};
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		
		public function open(e=null) : void
		{
			if(!_locked)
			{
				startGame();
				bkgPanel.x = -187.5;
				TweenMax.to(bkgPanel, .2, {x:"-10", autoAlpha:1});
				TweenMax.to(ctaPanelUnlocked, .2, {x: -66.35, autoAlpha:0, ease:Back.easeIn});
				enable(false);
			}

			_state = "open";
			dispatchEvent(new Event("characterPanelOpened", true));

		}
		
		public function close(e=null) : void
		{
			if(!_locked)
			{
				TweenMax.to(ctaPanelUnlocked, .2, {delay:.1, x: -76.35, autoAlpha:1, ease:Back.easeOut});
				TweenMax.to(bkgPanel, .2, {x:"-10", autoAlpha:0});

				stopGame();
			}
			_state = "closed";
			enable(true);
			dispatchEvent(new Event("characterPanelClosed", true));
		}
		
		
		public function openInviteModal(e=null) : void
		{
			/*locked = false;*/
			dispatchEvent(new Event("onMudvite", true));
		}
		
		/* INTERFACE METHODS*/
		public function openCTA(animate:Boolean) : void {}		
		public function closeCTA(animate:Boolean) : void {}
		
		
		public function animateIn(d:Number) : void
		{
			TweenMax.from(tree, .15, {delay:d, scaleY:0, ease:Back.easeOut});
			
			if(_locked)
			{
				ctaPanelUnlocked.visible = false;
				TweenMax.from( lockedSasplotch, .2, {delay:d+.1, alpha:0, x:"+100", ease:Back.easeOut});
				TweenMax.from( ctaPanelLocked, .2, {delay:d+.2, scaleX:0, scaleY:0, autoAlpha:0, ease:Back.easeOut});
			}
			
			if(!_locked)
			{
				trace("ctaPanelUnlocked alpha "+ctaPanelUnlocked.alpha);
				ctaPanelLocked.visible = false;
				ctaPanelUnlocked.visible = true;
				TweenMax.from( unlockedSasplotch, .2, {delay:d+.1, alpha:0, x:"+100", ease:Back.easeOut});
				TweenMax.from( ctaPanelUnlocked, .2, {delay:d+.2, alpha:0, x:"+10", ease:Back.easeOut});
				unlockedSasplotch.getChildByName("mud").alpha = 0;
			}
			
			alpha = 1;
		}
		
		public function animateOut(d:Number) : void
		{
			if(_locked)
			{
				TweenMax.to(tree, .15, {delay:d, scaleY:0, ease:Back.easeIn});
				TweenMax.to( lockedSasplotch, .2, {delay:d+.1, alpha:0, x:"+100", ease:Back.easeIn});
				TweenMax.to( ctaPanelLocked, .2, {delay:d+.2, scaleX:0, scaleY:0, alpha:0, ease:Back.easeIn, onComplete:animationFinished});	
			}
			
			if(!_locked)
			{
				TweenMax.to(tree, .15, {delay:d, scaleY:0, ease:Back.easeIn});
				TweenMax.to( unlockedSasplotch, .2, {delay:d+.1, alpha:0, x:"+100", ease:Back.easeIn});
				TweenMax.to( ctaPanelUnlocked, .2, {delay:d+.2, alpha:0, x:"+10", ease:Back.easeIn, onComplete:animationFinished});
			}

		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function animationFinished() : void
		{
			alpha = 0;
			tree.scaleX = tree.scaleY = .658;
			unlockedSasplotch.alpha = lockedSasplotch.alpha = 1;
			lockedSasplotch.x -= 100;
			unlockedSasplotch.x = 40;
			ctaPanelLocked.scaleX = ctaPanelLocked.scaleY = 1;
			ctaPanelLocked.alpha = 1;
			ctaPanelUnlocked.alpha = 1;
			ctaPanelUnlocked.x -= 10;
		}
		
		
		private function mouseHandler(e:MouseEvent = null) : void
		{
			if(e.target.name == "overlay") 
			{ 
				close(); 
				return;
			};
		}
		
		private function onThrow(e:Event) : void
		{
			_game.stop();
			_sasplotch.gotoAndPlay("throw");
		}
		
		private function sasplotchThrow(e:Event = null) : void
		{
			var head = addChild(new SquirrelHead());
			head.x   = -74;
			head.y   = -12;
			head.filters = [_bf];
			var fX   = RobotMath.randRange(0, 289);
			var fY   = RobotMath.randRange(0, 250);
			var variant = RobotMath.randRange(-20, 20);
			var p    = CoordinateTools.localToLocal(_frame.imgHolder, this, new Point(145+variant, 125+variant));

			TweenMax.to(head, .2, {x: p.x, y:p.y,ease:Strong.easeIn, 
				onComplete:function()
					{
						head.dispatchEvent(new Event("onSasplotchMudImpact", true));
						head.filters = [new BlurFilter(0, 20, 2)];
						TweenMax.to(head, .2, {y:100, alpha:0, ease:Strong.easeIn});
						if(_state == "open") _game.start();
						//removeChild(head);

					}
				});
		}
		
		
		
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		
		private function startGame() : void
		{
			unlockedSasplotch.x = -205;
			unlockedSasplotch.y = 70;
			unlockedSasplotch.rotation = 9;
			unlockedSasplotch.scaleX = unlockedSasplotch.scaleY = 1.4;
			
			TweenMax.to(unlockedSasplotch, .15, {x:-99, overwrite:1, ease:Back.easeOut});
			TweenMax.to(unlockedSasplotch.getChildByName("mud"), .15, {delay:.15, alpha:1});
			_game.start();
		}
		
		
		private function stopGame() : void
		{

			var onComplete = function()
			{
				unlockedSasplotch.x = 235;
				unlockedSasplotch.y = -29;
				TweenMax.to(unlockedSasplotch, .2, {alpha:1, x: 40, ease:Back.easeOut});	
			}
			
			TweenMax.to(unlockedSasplotch, .2, {x:-205, rotation:-7, scaleX:1, scaleY:1, ease:Back.easeIn, onComplete:onComplete});
			TweenMax.to(unlockedSasplotch.getChildByName("mud"), .05, {alpha:0});
			_game.stop();
		}
		
		
		private function enable(b:Boolean) : void
		{
			if(b)
			{
				if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP, mouseHandler);
				if(stage) stage.removeEventListener(MouseEvent.CLICK, mouseHandler);
			}else{
				if(stage) stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
				if(stage) stage.addEventListener(MouseEvent.CLICK, mouseHandler);
			}
		}
		
		
		private function enableSasplotch(b:Boolean) : void
		{
			if(!b)
			{
				unlockedSasplotch.visible 	= true;
				ctaPanelUnlocked.visible 	= true;
				
				unlockedSasplotch.addEventListener(MouseEvent.CLICK, open);
				ctaPanelUnlocked.addEventListener(MouseEvent.CLICK, open);
				unlockedSasplotch.buttonMode = ctaPanelUnlocked.buttonMode = true;
				
				lockedSasplotch.removeEventListener(MouseEvent.CLICK, openInviteModal);
				ctaPanelLocked.removeEventListener(MouseEvent.CLICK, openInviteModal);
				lockedSasplotch.visible = false;
				ctaPanelLocked.visible 	= false;
				
				_sasplotch = unlockedSasplotch;
				_ctaPanel = ctaPanelUnlocked;
			}
			
			if(b)
			{
				ctaPanelLocked.visible 	= true;
				lockedSasplotch.visible = true;
				ctaPanelLocked.addEventListener(MouseEvent.CLICK, openInviteModal);
				lockedSasplotch.addEventListener(MouseEvent.CLICK, openInviteModal);				
				lockedSasplotch.buttonMode = ctaPanelLocked.buttonMode = true;
				
				unlockedSasplotch.visible = false;
				ctaPanelUnlocked.visibile = false;
				
				unlockedSasplotch.removeEventListener(MouseEvent.CLICK, open);
				ctaPanelUnlocked.removeEventListener(MouseEvent.CLICK, open);
				_sasplotch = lockedSasplotch;
				_ctaPanel = ctaPanelLocked;
			}
		}
	}

}


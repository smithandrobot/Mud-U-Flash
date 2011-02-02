package com.smithandrobot.mud_u.views.ui 
{
	import fl.controls.List;
	import fl.controls.Button;
	import fl.controls.ScrollPolicy;
	import fl.controls.CheckBox;
	import fl.data.DataProvider;
	
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.Point;
	
	import com.greensock.*;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	
	import com.smithandrobot.mud_u.views.ui.MudviteCellRenderer;
	
	public class DialogMudvite extends Sprite 
	{
		
		private var _mediator;
		private var _friendsList : List;
		private var _rockwell = new RockwellBold();
		private var _selectAllBtn;
		
		public function DialogMudvite(m)
		{
			_mediator = m;
			_selectAllBtn = dialog.selectAll;
		
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			styleAndInitSelectAll();
			initClosBtn();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		
		public function open() : void
		{
			postBtn.alpha = overlay.alpha = dialog.alpha = 0;
			dialog.scaleX = dialog.scaleY = 0;
			postBtn.y = 456;
			TweenMax.to(overlay, .2, {alpha:1});
			TweenMax.to(postBtn, .2, {delay:.15, y:476, alpha:1, ease:Back.easeOut, easeParams:[5]});
			TweenMax.to(dialog, .2, {scaleX:1, scaleY:1, alpha:1, ease:Back.easeOut});
		}
		
		
		public function close(e:MouseEvent = null) : void
		{
			TweenMax.to(postBtn, .2, {delay:.2, y:456, ease:Back.easeIn, alpha:0});
			TweenMax.to(dialog, .2, {delay:.2, scaleX:0, scaleY:0, alpha:0, ease:Back.easeIn});
			TweenMax.to(overlay, .2, {delay:.3, alpha:0, onComplete:remove });
		}
		
		
		public function set friends(d) : void
		{
			var dp = new DataProvider(d);

 			_friendsList = dialog.getChildByName("friendsList") as List;
			_friendsList.labelField = "name";
			_friendsList.rowHeight = 30;
			_friendsList.setStyle('cellRenderer', MudviteCellRenderer);
			_friendsList.setRendererStyle("textFormat", getTextFormat());
			_friendsList.setStyle("embedFonts", true);
			_friendsList.setRendererStyle("upSkin",CellRenderer_upSkin);
			_friendsList.dataProvider = dp;

		}
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		private function onAdded(e:Event) : void
		{
			_mediator.getFriends();
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
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
		
		private function styleAndInitSelectAll() : void
		{
			_selectAllBtn.setStyle("embedFonts", true);
			_selectAllBtn.setStyle("textFormat", getTextFormat() );
			_selectAllBtn.label = "Select All";

			
			_selectAllBtn.addEventListener(MouseEvent.ROLL_OUT,fixText);
            _selectAllBtn.addEventListener(MouseEvent.MOUSE_OVER,fixText);
            _selectAllBtn.addEventListener(MouseEvent.MOUSE_DOWN,fixText);
            _selectAllBtn.addEventListener(MouseEvent.CLICK,selectAll);

			fixText();
		}
		
		
		private function fixText(e:MouseEvent = null)  :void
		{
			_selectAllBtn.drawNow();
			_selectAllBtn.textField.width = _selectAllBtn.textField.textWidth+30;	
		}
		
		
		private function selectAll(e:MouseEvent = null) : void
		{
			fixText();
		
			var arr = new Array();
			var total = _friendsList.dataProvider.length-1;
			var i = 0;
			
			if(e.target.selected)
			{
				for(i; i<= total; i++)
				{
					arr.push(i);
				}
			}
			_friendsList.selectedIndices = arr;
		}
		
		private function initClosBtn() : void
		{
			dialog.closeBtn.addEventListener(MouseEvent.CLICK, close)
			dialog.closeBtn.buttonMode = true;
		}
		
		public function remove() : void
		{
			dispatchEvent(new Event("onDialogOut"));
			parent.removeChild(this);
			overlay.alpha = dialog.alpha = 0;
			dialog.scaleX = dialog.scaleY = 0;
			postBtn.y = 426;
		}
		
		
	}

}


package com.smithandrobot.mud_u.views.ui.characterpanels 
{
	
	import flash.events.*;
	import flash.display.*;
	
	public class SquirrelColorPicker extends EventDispatcher 
	{
		
		private var _scope;
		private var _selected : Boolean = false;
		private var _highlight : MovieClip;
		private var _color : String = "0xB1ABA4";
		private static var _pickers = new Array();
		
		public function SquirrelColorPicker(scope)
		{
			_scope = scope;
			selected = _selected
			_pickers.push(this);
			initBehaviors()
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		
		public function set color(c:String) : void { _color = c; }
		public function get color() : String { return _color; }
		
		
		public function set selected(b:Boolean) : void 
		{ 
			_selected = b;			
			if(_selected)
			{
		   		for(var i in _pickers)
		   		{
		   			if(_pickers[i] != this)
					{
						_pickers[i].selected = false;
					}
		   		}
				_scope.highlight.visible = b;
				dispatchEvent(new Event("onColorChange", true));
			}else{
				_scope.highlight.visible = b;
			}
		}
		
		
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		private function toggle(e:MouseEvent = null) : void
		{
			if(_selected) return;
			selected = !_selected;
		}
		
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		

		private function initBehaviors() : void
		{
			_scope.addEventListener(MouseEvent.CLICK, toggle)
			_scope.buttonMode = true;
		}
	}
}


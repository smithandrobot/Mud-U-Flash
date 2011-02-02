package com.smithandrobot.mud_u.views.ui 
{

	import flash.events.*;
	
	import fl.controls.List;
	import fl.events.*;
	import fl.core.*;
	import fl.controls.listClasses.ICellRenderer;
	
	public class MudUList extends List 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		
		/**
		 *	@constructor
		 */
		public function MudUList()
		{
			super();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		override protected function handleCellRendererClick(event:MouseEvent):void 
		{
			if (!_enabled) { return; }
			var renderer:ICellRenderer = event.currentTarget as ICellRenderer;
			var itemIndex:uint = renderer.listData.index;
			// this event is cancellable:
			if (!dispatchEvent(new ListEvent(ListEvent.ITEM_CLICK,false,true,renderer.listData.column,renderer.listData.row,itemIndex,renderer.data)) || !_selectable) { return; }
			var selectIndex:int = selectedIndices.indexOf(itemIndex);
			var i:int;
			if (!_allowMultipleSelection) {
				if (selectIndex != -1) {
					return;
				} else {
					renderer.selected = true;
					_selectedIndices = [itemIndex];
				}
				lastCaretIndex = caretIndex = itemIndex;
			} else {
				if (event.shiftKey) {
					var oldIndex:uint = (_selectedIndices.length > 0) ? _selectedIndices[0] : itemIndex;
					_selectedIndices = [];
					if (oldIndex > itemIndex) {
						for (i = oldIndex; i >= itemIndex; i--) {
							_selectedIndices.push(i);
						}
					} else {
						for (i = oldIndex; i <= itemIndex; i++) {
							_selectedIndices.push(i);
						}
					}
					caretIndex = itemIndex;
				} else /*if (event.ctrlKey) */{
					if (selectIndex != -1) {
						renderer.selected = false;
						_selectedIndices.splice(selectIndex,1);
					} else {
						renderer.selected = true;
						_selectedIndices.push(itemIndex);
					}
					caretIndex = itemIndex;
				} /*else {
									_selectedIndices = [itemIndex];
									lastCaretIndex = caretIndex = itemIndex;
								}*/
			}
			dispatchEvent(new Event(Event.CHANGE));
			invalidate(InvalidationType.DATA);
		}
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}

}


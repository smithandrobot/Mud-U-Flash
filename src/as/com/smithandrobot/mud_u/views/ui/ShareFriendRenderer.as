package com.smithandrobot.mud_u.views.ui
{
	
    import fl.controls.CheckBox;
    import fl.controls.LabelButton;
    import fl.controls.listClasses.ICellRenderer;
    import fl.controls.listClasses.ListData;
	import fl.events.ComponentEvent;
	import fl.controls.ButtonLabelPlacement;
	
	import flash.events.*;
	
	public class ShareFriendRenderer extends CheckBox
	{
	    public function ShareFriendRenderer(){
	        super();
	        // ClassFactory
	        // => Add listener to detect change in selected
	        this.addEventListener(Event.CHANGE, onChangeHandler);
	    }
	    
	    // Override the set method for the data property.
		public function set data(value:Object):void {
	        super.data = value;
	        
	        // => Make sure there is data
	        if (value != null) {
	            // => Set the label
	            this.label = value.label;
	            
	            // => Set the selected property
	            this.selected = value.isSelected;
	        }
	        
	        // => Invalidate display list,
	        // => If checkbox is now selected, we need to redraw
	        super.invalidateDisplayList();
	    }
	    
	    // => Handle selection change
	    private function onChangeHandler(event:Event):void
	    {
	        super.data.isSelected = !super.data.isSelected;
	    }
	}
}
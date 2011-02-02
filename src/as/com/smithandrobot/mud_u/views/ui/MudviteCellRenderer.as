package com.smithandrobot.mud_u.views.ui
{
    import fl.controls.CheckBox;
    import fl.controls.LabelButton;
    import fl.controls.listClasses.ICellRenderer;
    import fl.controls.listClasses.ListData;
	import fl.events.ComponentEvent;
	import fl.controls.ButtonLabelPlacement;
	
	import flash.text.*;
	import flash.display.*;
		
    public class MudviteCellRenderer extends CheckBox implements ICellRenderer {
	
        private var _listData:ListData;
        private var _data:Object;
		private var _rockwell = new RockwellBold();
		
        public function MudviteCellRenderer() {
			//textField.defaultTextFormat = getTextFormat();
        }

        public function set listData(newListData:ListData):void {
            _listData = newListData;
            label = _listData.label;
			textField.width = textField.textWidth;

        }
		
        public function get listData():ListData {
            return _listData;
        }

        public function set data(newData:Object):void {
            _data = newData;
        }

        public function get data():Object {
            return _data;
        }

		
		override protected function drawLayout():void{
			super.drawLayout();	
			
			var textPadding:Number = Number(getStyleValue("textPadding"));
			switch(_labelPlacement){
				case ButtonLabelPlacement.RIGHT:
					icon.x = textPadding;
					textField.x = icon.x + (18+textPadding);
					textField.width = textField.textWidth+20;
					background.width = textField.x + textField.width + textPadding;
					background.height = Math.max(textField.height, icon.height)+textPadding*2;
					break;
				case ButtonLabelPlacement.LEFT:
					icon.x = width - icon.width - textPadding;
					textField.x = width - icon.width - textPadding*2 - textField.width;
					background.width = textField.width + icon.width + textPadding*3;
					background.height = Math.max(textField.height, icon.height)+textPadding*2;
					break;
				case ButtonLabelPlacement.TOP:
				case ButtonLabelPlacement.BOTTOM:
					background.width = Math.max(textField.width, icon.width) + textPadding*2;
					background.height = textField.height + icon.height + textPadding*3;
					break;
			}
			background.x = Math.min(icon.x-textPadding, textField.x-textPadding);
			background.y = Math.min(icon.y-textPadding, textField.y-textPadding);
		}

    }
}
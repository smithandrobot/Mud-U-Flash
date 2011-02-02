// Copyright 2007. Adobe Systems Incorporated. All Rights Reserved.
package com.smithandrobot.mud_u.views.ui 
{

	import fl.controls.listClasses.ImageCell;
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.listClasses.ListData;
	import fl.controls.listClasses.TileListData;
	import fl.controls.TextInput; //Only for ASDocs
	import fl.containers.UILoader;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	import flash.display.Graphics;
	import flash.display.Shape;	
	import flash.events.IOErrorEvent;

    //--------------------------------------
    //  Styles
    //--------------------------------------
	/**
	 * The skin that is used to indicate the selected state.
	 *
     * @default ImageCell_selectedSkin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 *  
	 *  @playerversion AIR 1.0
	 *  @productversion Flash CS3
	 */
	[Style(name="selectedSkin", type="Class")]
	/**
	 * The padding that separates the edge of the cell from the edge of the text, 
	 * in pixels.
	 *
     * @default 3
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 *  
	 *  @playerversion AIR 1.0
	 *  @productversion Flash CS3
	 */
	[Style(name="textPadding", type="Number", format="Length")]
	/**
	 * The padding that separates the edge of the cell from the edge of the image, 
	 * in pixels.
	 *
     * @default 1
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 *  
	 *  @playerversion AIR 1.0
	 *  @productversion Flash CS3
	 */
	[Style(name="imagePadding", type="Number", format="Length")]
	
	/**
	 * The opacity of the overlay behind the cell label.
	 *
	 * @default 0.7
	 * 
	 *  
	 *  @playerversion AIR 1.0
	 *  @productversion Flash CS3
	 */
	[Style(name="textOverlayAlpha", type="Number", format="Length")]

    //--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * The ImageCell is the default cell renderer for the TileList
     * component. An ImageCell class accepts <code>label</code> and 
	 * <code>source</code> properties, and displays a thumbnail and 
	 * single-line label.
	 *
	 * <p><strong>Note:</strong> When content is being loaded from a different 
	 * domain or <em>sandbox</em>, the properties of the content may be inaccessible
	 * for security reasons. For more information about how domain security 
	 * affects the load process, see the Loader class.</p>
     *
     * @see flash.display.Loader Loader
     *
	 * @includeExample examples/ImageCellExample.as
	 *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 *  
	 *  @playerversion AIR 1.0
	 *  @productversion Flash CS3
	 */
	public class BrowserImageCell extends ImageCell implements ICellRenderer {


		private static var defaultStyles:Object = {
												imagePadding:1,
												textOverlayAlpha:0.7
												};
												

		private var _badge : MudUBadge = new MudUBadge();
		/**
         * Creates a new ImageCell instance.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0
		 *  @productversion Flash CS3
		 */
		public function BrowserImageCell() {
			super();
			loader.scaleContent = true;
		}
			
		
		/**
         * Gets or sets an absolute or relative URL that identifies the 
		 * location of the SWF or image file to load, the class name 
		 * of a movie clip in the library, or a reference to a display 
		 * object.
		 * 
		 * <p>Valid image file formats include GIF, PNG, and JPEG.</p>
         *
         * @default null
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         *  
         *  @playerversion AIR 1.0
         *  @productversion Flash CS3
         */
		override public function get source():Object { 
			return loader.source;
		}
		
		public function get bmpData() : * {
			return loader.content;
		}
		/**
		 * @private (setter)
		 *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override public function set source(value:Object):void {
			loader.source = value;
			
		}
		
		public function set scaleContent(s:Boolean):void {
			loader.scaleContent = s;
		}
		
		override public function set data(value:Object):void {
			_data = value;
			
			if(_data.usesApp == "a")
			{
				addChild(_badge);
				_badge.x = 55;
				_badge.y = 55;
			}else{
				if(_badge.parent) removeChild(_badge);
			}
		}
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override protected function draw():void {
			super.draw();
		}

		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override protected function drawLayout():void 
		{
			super.drawLayout();
			
			var imagePadding:Number = getStyleValue("imagePadding") as Number;
			loader.move(imagePadding, imagePadding);
			/*loader.move(imagePadding, -10);*/
			
			var w:Number = width-(imagePadding*2);
			var h:Number = height-imagePadding*2;
			if (loader.width != w && loader.height != h) {
				//loader.setSize(w,h);
			}
			
			loader.drawNow(); // Force validation!
			
			if(textOverlay)
			{
				textField.x = 15;
				textField.y = 55;
				loader.y = 0;//loader.y+loader.height+10;
			}


		}
		
		
		private function setWidth() : void
		{
			
		}
		
	}
}
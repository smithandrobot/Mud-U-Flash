package com.smithandrobot.mud_u
{

	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.*;
	import flash.filters.*;
	
	import aether.effects.filters.*;
	import aether.utils.*;
	
	import com.smithandrobot.utils.*;
	
	public class ImageTests extends Sprite 
	{
		
		private var _splats = [MudSplatA, MudSplatB, MudSplatC, MudSplatD, MudSplatE, MudSplatF, MudSplatG, MudSplatH, MudSplatI, MudSplatJ, MudSplatK];
		
		public function ImageTests()
		{
			var bmd 		= new CData(288, 250);
			var bmd2 		= new CData(288, 250);
			var mudlayer	= new BitmapData(288, 250, true, 0x00FFFFFF);
			var mudBMD		= _splats[RobotMath.randRange(0, _splats.length-1)];
			
			var mudSprite   = new Sprite().addChild(new Bitmap(mudlayer));
			//mudSprite.x = 80;
			var m = new Matrix();
			m.tx = 80;
			mudlayer.draw(new MudSplatA(),m);
			
			m.tx = 120
			mudlayer.draw(new MudSplatK(), m);
			
			m.tx = 20
			mudlayer.draw(new MudSplatC(), m);

			var orgBMP = addChild(new Bitmap(bmd2));
			var bmp = new Bitmap(createHighLightBMD(bmd));
			var ms = addChild(mudSprite);
			ms.blendMode = "multiply";
			addChild(bmp);
			
			var me = new DData();
			Adjustments.desaturate(me, 1);
			/*Adjustments.setLevels(me, 0, 1, 170);*/
			Adjustments.adjustContrast(me, 2)
			me.threshold(me, me.rect, new Point(0,0), ">=", 0xFF999999, 0x7FFF0000, 0xFFFFFFFF, false);
			var dBMP = addChild(new Bitmap(me));
			dBMP.x = 289;
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
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function createHighLightBMD(org:BitmapData) : BitmapData
		{
			Adjustments.desaturate(org, 1);
			Adjustments.setLevels(org, 187, 1.16, 25);
			
			var bf = new BlurFilter(2,2,2);
			var targetBitmapData:BitmapData = new BitmapData(org.width, org.height, true, 0x00000000);
			/* applyFilter(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, filter:BitmapFilter):void */
			targetBitmapData.threshold(org, org.rect, new Point(0,0), ">=", 0xFFF4F4F4, 0x3FFFFFFF, 0xFFFFFFFF, false);
			targetBitmapData.applyFilter(targetBitmapData, targetBitmapData.rect, new Point(), bf);
			return targetBitmapData;
		}
	}

}


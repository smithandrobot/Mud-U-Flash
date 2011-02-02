package com.smithandrobot.mud_u.transform
{
	import com.senocular.display.TransformTool;
	import flash.geom.Matrix;
	
	public class MudUTransformTool extends TransformTool
	{
		
		protected var _minScaleX : Number = .01//Infinity;
		protected var _minScaleY : Number = .01//Infinity;
		
		public function MudUTransformTool()
		{
			super();
		}
		
		
		public function set minScaleY(n:Number) : void
		{
			/*_minScaleY = n;*/
		}
		
		public function set minScaleX(n:Number) : void
		{
			/*_minScaleX = n;*/
		}
	}
}
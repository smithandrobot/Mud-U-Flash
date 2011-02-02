

package com.smithandrobot.utils 
{

/**
 *	Class description.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0
 *	@author David Ford
 *	@since  01.04.2009
 */
	import flash.geom.Point;
	import flash.display.DisplayObject;
	
	public class RobotMath {
		
		/**
		 *	@constructor
		 */
		public function RobotMath()
		{
		}
		
		
		public static function randRange(min:Number, max:Number, float: Boolean = false):Number 
		{
		    var randomNum:Number;
			if(float) randomNum = Math.random() * (max - min) + min;
			if(!float) randomNum = Math.floor(Math.random() * (max - min + 1)) + min;
		    return randomNum;
		}
		
		
		public static function getPointsOnQuadCurve(t:Number, p1:Point, p2:Point, p3:Point):Point {
			var p:Point = new Point();
			p.x = p1.x + t*(2*(1-t)*(p2.x-p1.x) + t*(p3.x - p1.x));
			p.y = p1.y + t*(2*(1-t)*(p2.y-p1.y) + t*(p3.y - p1.y));
			return p;
		}
		
		public static function localToLocal(containerFrom:DisplayObject, containerTo:DisplayObject, origin:Point=null):Point
		{
			var point:Point = origin ? origin : new Point();
			point = containerFrom.localToGlobal(point);
			point = containerTo.globalToLocal(point);
			return point;
		}
		
	}

}


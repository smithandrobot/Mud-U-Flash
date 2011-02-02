package com.smithandrobot.mud_u.views.ui.characterpanels 
{
	
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.Point;
	
	import fl.ik.*;

	import com.greensock.*;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	
	
	public class SquirrelArm extends Sprite 
	{
		
		private var _fingerPosition : Point;
		private var _shoulderPosition : Point;
		private var _forearmPosition : Point;
		private var _ik : IKMover;
		private var _enabled : Boolean;
		private var _frame : MovieClip;
		private var _color : String;
		private var _mouseDown : Boolean;
		
		public function SquirrelArm()
		{
			TweenPlugin.activate([TintPlugin]);
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get color() : String { return _color; };
		public function set color(c:String) : void 
		{ 
			_color = c ;
			var tintHex = getHex(c);
			TweenMax.to(ikNode_17.finger, .2, {tint: tintHex});
		};
		
		public function set frame(f) : void
		{
			_frame = f;
		}
		
		
		public function set enabled(b:Boolean) : void 
		{ 
			if(_enabled == b) return;
			
			if(b)
			{
				_enabled = true;
				addEventListener(Event.ENTER_FRAME, frameFunc);
				stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
				stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
			}else{
				_enabled = false;
				removeEventListener(Event.ENTER_FRAME, frameFunc);
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP, mouseHandler);	
				_ik.moveTo(new Point(424,-120));
			}
		}
		
		
		public function get drawingPoints() : Point
		{
			return _fingerPosition;
		}
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		private function onAdded(e:Event) : void
		{
			initIK();

		}
		
		
		private function mouseHandler(e:MouseEvent = null) : void
		{
			if (e.type == MouseEvent.MOUSE_DOWN) { _mouseDown = true; };
			if(e.type == MouseEvent.MOUSE_UP) { _mouseDown = false; };
		}
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		
		private function frameFunc(e:Event = null) 
		{  
			var p = this.localToGlobal(new Point(mouseX, mouseY));

			if(!_frame.hitTestPoint(p.x, p.y, true)) 
			{
				TweenMax.to(_fingerPosition, .7, {x:226, y:189, onUpdate:update, ease:Back.easeOut, overwrite:1});
				return;
			}
			
			if(_mouseDown) dispatchEvent(new Event("onSquirrelDraw",true));
			
			TweenMax.to(_fingerPosition, .7, {x:mouseX, y:mouseY, onUpdate:update, ease:Back.easeOut, overwrite:1});
		}

		private function update()
		{
			_ik.moveTo(_fingerPosition);
		}
		
		
		private function initIK()
		{
			IKManager.trackAllArmatures(false);
			var arm = IKManager.getArmatureByName("squirrelArm");
			
			var finger:IKBone = arm.getBoneByName("finger");
			var forearm:IKBone = arm.getBoneByName("forearm");
			var shoulder:IKBone = arm.getBoneByName("shoulder");
			
			var forearmTJ:IKJoint = forearm.tailJoint;
			var shoulderTJ:IKJoint = shoulder.tailJoint;
			var endEffector:IKJoint = finger.tailJoint;
			
			_shoulderPosition = shoulderTJ.position;
			_forearmPosition = forearmTJ.position;
			_fingerPosition = endEffector.position;

			// cos
			_ik = new IKMover(endEffector, _fingerPosition); 
			_ik.limitByDistance = true; 
			_ik.distanceLimit = 10; 
			_ik.limitByIteration = true; 
			_ik.iterationLimit = 20;
			
			_ik.moveTo(new Point(424,-120));
		}
		
		private function getHex(c:String) : uint
		{
			var hex;
			
			switch(c)
			{
				case "gray" :
					hex = 0x473019;
					break;
				case "chocolate" : 
					hex = 0x84623F;
					break;
				case "tan" : 
					hex = 0xBE9B73;
					break;
				default : 
					hex = 0xB1ABA4;
					break;
			}
			
			return hex;
		}
	}
}


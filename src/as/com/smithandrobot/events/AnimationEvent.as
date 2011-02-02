package com.smithandrobot.events {

import flash.events.Event;


public class AnimationEvent extends Event 
{
	
	public static const EVENT_NAME:String = "onAnimationStart";
	public static const EVENT_NAME:String = "onAnimationOver";
	
	//--------------------------------------
	//  CONSTRUCTOR
	//--------------------------------------
	
	/**
	 *	@constructor
	 */
	public function AnimationEvent( type:String, bubbles:Boolean=true, cancelable:Boolean=false )
	{
		super(type, bubbles, cancelable);
	}
	
	//--------------------------------------
	//  GETTER/SETTERS
	//--------------------------------------
	
	//--------------------------------------
	//  PUBLIC METHODS
	//--------------------------------------

	override public function clone():Event
	{
		return new AnimationEvent(type, bubbles, cancelable);
	}
	
	//--------------------------------------
	//  EVENT HANDLERS
	//--------------------------------------
	
	//--------------------------------------
	//  PRIVATE VARIABLES
	//--------------------------------------
	
	//--------------------------------------
	//  PRIVATE & PROTECTED INSTANCE METHODS
	//--------------------------------------
	
}

}


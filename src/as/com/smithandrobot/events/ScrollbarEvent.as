//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright 2010 Smith & Robot
// 
////////////////////////////////////////////////////////////////////////////////

package com.smithandrobot.events {

import flash.events.Event;

/**
 *	Event subclass description.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0
 *
 *	@author David Ford
 *	@since  24.03.2010
 */
public class ScrollbarEvent extends Event {
	
	//--------------------------------------
	// CLASS CONSTANTS
	//--------------------------------------
	
	public static const SCROLL:String = "onScroll";
	private var _percentScrolled : Number;
	
	/**
	 *	@constructor
	 */
	public function ScrollbarEvent( type:String, percentScrolled: Number, bubbles:Boolean=true, cancelable:Boolean=false )
	{
		super(type, bubbles, cancelable);
		_percentScrolled = percentScrolled;
	}
	
	//--------------------------------------
	//  GETTER/SETTERS
	//--------------------------------------
	public function get percentScrolled() :Number
	{
		return _percentScrolled;
	}
	//--------------------------------------
	//  PUBLIC METHODS
	//--------------------------------------

	override public function clone():Event
	{
		return new ScrollbarEvent(type, percentScrolled, bubbles, cancelable);
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


package com.smithandrobot.mud_u.interfaces {

/**
 *	Description
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0
 *
 *	@author David Ford
 *	@since  07.12.2010
 */

public interface IScreen 
{
	
	//--------------------------------------
	//  PUBLIC METHODS
	//--------------------------------------
	
	function animateIn() : void; 
	function animateOut() : void;
	function remove() : void;
	
	//--------------------------------------
	//  GETTER/SETTERS
	//--------------------------------------
	
	function set data(d:*) : void;
	
}

}


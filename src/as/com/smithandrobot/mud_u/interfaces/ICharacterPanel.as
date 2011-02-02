package com.smithandrobot.mud_u.interfaces 
{

public interface ICharacterPanel 
{
	
	//--------------------------------------
	//  PUBLIC METHODS
	//--------------------------------------
	
	function open(e=null) : void;
	function close(e=null) : void;
	
	//--------------------------------------
	//  GETTER/SETTERS
	//--------------------------------------
	
	function get type() : String;
	function openCTA(animate:Boolean) : void;
	function closeCTA(animate:Boolean) : void;
	function animateIn(d:Number) : void;
	function animateOut(d:Number) : void;
	}
}

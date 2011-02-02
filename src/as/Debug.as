package
{
	
	import flash.events.EventDispatcher;
	import nl.demonsters.debugger.MonsterDebugger;
	
	public class Debug extends EventDispatcher 
	{
		
		public function Debug(scope)
		{
			// Init the debugger
			var debugger = new MonsterDebugger(this);
		}
		
		public static function trace(o: Object = null, m:String = "") : void
		{
			MonsterDebugger.trace(o, m)
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
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
		
	}
}


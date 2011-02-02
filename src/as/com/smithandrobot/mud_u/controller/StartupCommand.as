package com.smithandrobot.mud_u.controller
{
    import flash.display.Sprite;
    import org.puremvc.as3.interfaces.ICommand;
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import com.smithandrobot.mud_u.ApplicationFacade;
	import com.smithandrobot.mud_u.model.*;
	import com.smithandrobot.mud_u.views.StageMediator;
	
    public class StartupCommand extends SimpleCommand implements ICommand
    {
        override public function execute( note:INotification ) : void    
        {
	    	var scope:Sprite = note.getBody() as Sprite;
			facade.registerProxy( new ApplicationDataProxy( scope ) );
            facade.registerMediator( new StageMediator( scope ) );
			facade.registerProxy( new ApplicationLogin( scope ) );

        }
    }
}
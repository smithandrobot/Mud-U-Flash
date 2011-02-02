<?php
	$uid = $_GET['uid'];
	$appType 	=  getAppType();
	$appID 		= getAppID($appType);
	$appURL 	= getAppURL($appType);
	$inviteURL 	= getInviteURL($appType);
	
	function getAppType()
	{
		$directories = array("mudev", "mudstaging", "/");
		$appTypes = array("dev", "staging", "live");
		$location = $_SERVER['REQUEST_URI'];
		
		for($i=0; $i<=count($directories)-1; $i++)
		{
			if(strpos ( $location ,  $directories[$i]) > 0 )
			{
				return $appTypes[$i];
			};
		}
		return FALSE;
	}
	
	
	function getAppID($type)
	{
		switch($type)
		{
			case "dev":
			$id = "131296520253246";
			break; 
			case "staging":
			$id = "172785809421346";
			break;
			case "live":
			$id = "101069723301943";
			break;
			default:
			$id = "101069723301943";
			break;
		}
		return $id;
	}
	
	function getAppURL($type)
	{
		switch($type)
		{
			case "dev":
			$url = "mudev";
			break; 
			case "staging":
			$url = "mudstaging";
			break;
			case "live":
			$url = "mudu";
			break;
			default:
			$url = "mudu";
			break;
		}
		return $url;
	}
	
	function getInviteURL($type)
	{
		switch($type)
		{
			case "dev":
			$url = "http://smithandrobot.com/df/mudev/invite_callback.php";
			break; 
			case "staging":
			$url = "http://smithandrobot.com/df/mudstaging/invite_callback.php";
			break;
			case "live":
			$url = "http://mudu.srsc.us/invite_callback.php";
			break;
			default:
			$url = "http://mudu.srsc.us/invite_callback.php";
			break;
		}
		return $url;
	}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">    
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:fb="http://www.facebook.com/2008/fbml">
<head>
    <style type='text/css'>
    <!--
        body {margin:0px;padding:0px;}
        body,html {outline:none;}
			
		#fb_bkg
		{
			-ms-filter:"progid:DXImageTransform.Microsoft.Alpha(Opacity=50)";
			filter: alpha(opacity=50);
			opacity:.5;
			width:760px; 
			height:670px; 
			display:block; 
			background-color:#897B6A;
		}
     </style> 
</head>
<body>

	<script src="http://connect.facebook.net/en_US/all.js"></script>
	
	<script type="text/javascript">
	    window.onload = function()
	    {
				
			  FB.init({
			    appId  : '<?php echo $appID; ?>',
			    status : true,
			    cookie : true,
			    xfbml  : true  
			  });
	    };
	</script>
	
	<div id="fb_bkg">
	</div>
	<div id="fb-root" style="overflow:hidden;margin-left:70px; position:absolute; top:60px;">
				<fb:serverfbml width="625px" height="550px"> 
				<script type="text/fbml">
				    <fb:fbml> 
				    	<fb:request-form
				    		action="<?php echo $inviteURL.'?uid='.$uid; ?>"
				    		method="POST"
				    		invite="true"
				    		type="Mud U"
				    		content="I'm mudding photos at <a href='http://apps.facebook.com/muduapp/'>Mud U</a>. You should too. It's really funny and you can mud any photo you want - including mine.
				    			<fb:req-choice url='http://apps.facebook.com/muduapp/' label='Get Started Mudding with the Mud U App'/> ">
				    		<fb:multi-friend-selector
								condensed = "false"
								width="750px"
				    			showborder="true"
				    			actiontext="Invite your friends to use Mud U."
				    			rows="5"
								cols="5"
								bypass="cancel"               
								email_invite="false"
								invite_preview="false"
								import_external_friends="false"
				    		/> 
				    	</fb:request-form> 
				    </fb:fbml>
				</script> 
			</fb:serverfbml>
	   </div>        
</body>
</html>
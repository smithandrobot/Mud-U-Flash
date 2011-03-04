<?php
	
	$session 	= '';
	$appType 	=  getAppType();
	$appID 		= getAppID($appType);
	$appURL 	= getAppURL($appType);
	$swfBase	= getSWFBase($appType);
	srand ((double) microtime( )*1000000);
	$cache = rand();
	// echo 'location: '.$location = $_SERVER['REQUEST_URI'];
	//    echo'<br />appType: '.$appType;
	//    echo'<br />appID: '.$appID;
	//    echo'<br />appURL: '.$appURL;
	//    echo'<br />swf base: '.$swfBatrase;
	if( isset( $_GET["session"] ) )
	{
		$session = urldecode( $_GET["session"] );
		if( strpos( $_SERVER['HTTP_USER_AGENT'], 'MSIE') )
		{
			$session = htmlspecialchars( $session );
		}
	}else{
		$base_url = "https://graph.facebook.com/oauth/authorize?";
		$scope = "manage_pages, user_birthday, user_location, email, read_stream, friends_photos, user_photos,publish_stream, friends_photo_video_tags, user_photo_video_tags,offline_access";
		$redirect_uri = "http://apps.facebook.com/".getAppURL($appType)."/";
		$client_id = getAppID($appType);
		$display = "page";
		$url = $base_url.'client_id='.$client_id.'&redirect_uri='.$redirect_uri.'&type=user_agent'.'&scope='.$scope.'&display='.$display;
		echo "<script type='text/javascript'>top.location.href = '$url';</script>";
		exit;         
	}
	
	// 
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
	
	
	// 
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
			$url = "pinkiering";
			break; 
			case "staging":
			$url = "mudu_dev";
			break;
			case "live":
			$url = "muduapp";
			break;
			default:
			$url = "muduapp";
			break;
		}
		return $url;
	}
	
	function getSWFBase($type)
	{
		switch($type)
		{
			case "dev":
			$url = "http://c0374943.cdn2.cloudfiles.rackspacecloud.com/";
			break; 
			case "staging":
			$url = "http://c0381025.cdn2.cloudfiles.rackspacecloud.com/";
			break;
			case "live":
			$url = "http://c0387328.cdn2.cloudfiles.rackspacecloud.com/";
			break;
			default:
			$url = "http://mud-u.s3.amazonaws.com/app/";
			break;
		}
		return $url;
	}
	
	
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>	
<head>
	<meta http-equiv="Content-type" content="text/html; charset=utf-8">
	<title>Facebook - OAuthBridge</title>
	
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<meta name="distribution" content="global">
	<meta name="robots" content="follow, all">
	<meta name="language" content="en">
	<meta name="googlebot" content="index, follow">
	<meta name="revisit-after" content="20 days">
	<meta name="description" content="">
	<meta name="content" content="">
	<meta name="keywords" content="">
	<link rel="stylesheet" type="text/css" href="default.css">
	<script src="http://connect.facebook.net/en_US/all.js"></script>
	<script src="js/swfobject.js" type="text/javascript" charset="utf-8"></script>
  	<script type="text/javascript" charset="utf-8">
	
		inviteState = "closed";  
		
		
		function showInvite(uid)
		{     
           
		   	if(!uid) return;
			inviteState = "open";
    	    document.getElementById('invite').style.display = 'block';
    	    document.getElementById('invite').src = "invite.php?uid="+uid;

		}
		 
		
    	function hideInvite(b)
		{                                 
    	    document.getElementById('invite').style.display = 'none';
    	    document.getElementById('invite').src = "about:blank";
			
			if(b) 
			{ 
				inviteState = "closedSuccess";
			}else{
				inviteState = "closedCancel";
			}
    	}
		
		function getInviteState() { return inviteState; };
		
		function setInviteState(s) { inviteState = s; };

		window.fbAsyncInit = function() 
		{
				FB.Canvas.setSize( {height:1125} );
				//FB.Canvas.setAutoResize();
			  	FB.init({
			    appId  : '<?php echo $appID; ?>',
			    status : true, // check login status
			    cookie : true, // enable cookies to allow the server to access the session
			    xfbml  : true  // parse XFBML
			  	});
				//FB.Canvas.setSize( {height:1125} );
				//FB.Canvas.setAutoResize();

		};
	</script>
	
	<script type="text/javascript">
				
		var swf_file =  	   "<?php echo $swfBase.'mud_u_app_loader.swf?cache='.$cache; ?>";
		var swf_div =  		   "swfContainer";
		var swf_div_width =    "760px";
		var swf_div_height =   "1125px";
		var swf_install =  	   "http://c0374997.cdn2.cloudfiles.rackspacecloud.com/expressInstall.swf";
		var swf_redirect_ver = "10.0.0"
		var swf_redirect =     "./";
		
		
		var flashvars = { fb_app_id: "<?php echo $appID; ?>",
						   session: '<?php echo $session; ?>'
						 }

		var params = { menu: false, scale:"noscale", quality:"high", allowScriptAccess:"always", wmode:"transparent", base:"<?php echo $swfBase; ?>" };
		var attributes = { id:"mud_u_app", name:"mud_u_app" };
		swfobject.embedSWF( swf_file, swf_div, swf_div_width, swf_div_height, swf_redirect_ver, swf_install, flashvars, params, attributes );

	</script>
</head>

<body>
	<div id="fb-root">
		<div id="flashContainer">
		    <div id="swfContainer">
		        <p>Mud U Application</p>
		    </div>
		    <noscript> Get Flash and/or enable Javascript. </noscript>
		</div>
	</div>
	<iframe id="invite" scrolling="no" allowtransparency="true" frameborder="0" style="border:none; width:760px; height:1125px; margin:0px; padding:0px; overflow:hidden; position:absolute; top:0px; left:0px;"></iframe>
	<script type="text/javascript">
	    window.onload = function()
	    {   			
			hideInvite();
			inviteState = "closed";
			FB.Canvas.setSize( {height:1125} );
	    }
	</script>
<fb:serverfbml> 
	<script type="text/fbml">
	    <fb:fbml>
			<fb:google-analytics uacct="UA-16638319-3" />
	    </fb:fbml>
	</script> 
</fb:serverfbml>
<!-- end analytics -->
</body>
</html>
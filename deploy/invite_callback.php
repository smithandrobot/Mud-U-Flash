<?php

	$invited = FALSE;
	$uid = null; 
	$ids = '';
	
	if( isset( $_POST ) )
	{   
		if(count($_POST['ids']) > 0) 
		{
			$uid 		= $_GET['uid'];
			$invited 	= true;
			$uIDArray 	= $_POST['ids'];
			$ids 		= implode(",", $uIDArray);
 			$ch 		= curl_init('184.106.82.125/api/interactions/create/');

 			curl_setopt ($ch, CURLOPT_POST, 1);
 			curl_setopt ($ch, CURLOPT_POSTFIELDS, "facebookId=".$_GET['uid']."&interactionId=3&interactionValue=".$ids);
 			curl_exec ($ch);
 			curl_close ($ch);
		}
		
		
	}

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" dir="ltr">
<head>
    <script type="text/javascript">
    <!--
		
        <?php 
			if(isset($uid) && $invited === TRUE) 
			{
				echo 'window.parent.hideInvite('.json_encode($_POST['ids']).')';
			}else{
				echo 'window.parent.hideInvite()';
			}
		 ?> 
    //-->
    </script>
</head>
<body></body>
</html>
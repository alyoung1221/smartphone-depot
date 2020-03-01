<?php 
include('phpmaincode.php');

if (!isAdmin()) {
	$_SESSION['msg'] = "You must log in first to be managed";
	header('location: adminlogin.php');
}

if (isset($_GET['logout'])) {
	session_destroy();
	unset($_SESSION['user']);
	header("location: adminlogin.php");
}
?>
<?php

	$idonlinesale = $_GET["idonlineSaleHistory"];
	//$username = $_GET["adminUsername"];
	
	$connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");


		if (!@mysqli_query($connection, "DELETE FROM SP_phone_onlinesell_record WHERE idonlineSaleHistory ='$idonlinesale'")) {
		echo "Fail to add the ordered to process. please try again";
	} else {
		$rows = mysqli_affected_rows($connection);
		echo "Success Adding to Order Process $rows rows";
		
	}
		
	@mysqli_close($connection);

?>
<div>
<a href="onlinesellordered.php">Go Back</a>
</div>
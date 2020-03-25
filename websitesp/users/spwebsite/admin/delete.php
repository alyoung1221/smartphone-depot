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

	$iduser = $_GET["idadmin"];
	$username = $_GET["adminUsername"];
	
	$connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");


		if (!@mysqli_query($connection, "DELETE FROM loginadmin WHERE idadmin='$iduser' AND adminUsername='$username'")) {
		echo "Error doing delete";
	} else {
		$rows = mysqli_affected_rows($connection);
		echo "Success, deleted $rows rows";
		
	}
		
	@mysqli_close($connection);

?>
<div>
<a href="index.php">Home</a>
</div>
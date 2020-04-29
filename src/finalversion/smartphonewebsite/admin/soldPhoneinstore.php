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
<!DOCTYPE html>
<html lang="en">
<head>
<title>Instore Sale Page</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="css/bootstrap-4.3.1.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="css/mystyle.css">

</head>
<body>
<?php if (isset($_SESSION['success'])) : ?>
			<div class="error success" >
				<h3>
					<?php 
						echo $_SESSION['success']; 
						unset($_SESSION['success']);
					?>
				</h3>
			</div>
		<?php endif ?>
<div>
		<?php require 'includes/sidenav.php';?>
		<?php require 'includes/header.php';?>
		<div id = "content">
		
		<h1>Ordered (Instore) to be Process</h1>
				<?php

	$idphoneposed = $_GET["idphonepos"];
	//$username = $_GET["adminUsername"];
	
	$connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");


		if (!@mysqli_query($connection, "DELETE FROM SP_phonespos WHERE idphonepos ='$idphoneposed'")) {
		echo "Fail to pack the ordered to process. please try again";
	} else {
		$rows = mysqli_affected_rows($connection);
		echo "Success Pack  $rows Phones";
		
	}
		
	@mysqli_close($connection);

?>
<div>
<?php $connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");
	$nameUser =  $_SESSION['user']['adminUsername'];
	
		if (!@mysqli_query($connection, "INSERT INTO SP_trans_log values (null,'$nameUser', SYSDATE(),'This user process In-Store sale')")) {
		//echo "Fail to add user action into logs. please try again";
	} else {
		$rows = mysqli_affected_rows($connection);
		
		
	}
		
	@mysqli_close($connection);?>
<a href="packprocessorder.php">Go Back</a>
</div>
		</div>
		<?php require 'includes/footer.php';?>
</div>
<!-- jQuery (necessary for Bootstrap's JavaScript plugins) --> 
	<script src="js/jquery-3.3.1.min.js"></script>

	<!-- Include all compiled plugins (below), or include individual files as needed -->
	<script src="js/popper.min.js"></script> 
	<script src="js/bootstrap-4.3.1.js"></script>
</body>
</html>

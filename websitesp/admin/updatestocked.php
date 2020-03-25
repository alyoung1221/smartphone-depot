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
<title>CSS Website Layout</title>
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
		
		<h1>Update Stock</h1>
		<?php
	$quantities = $_POST["quantity"];
	
				$phoneID = $_GET["idSmartphones"];
				$connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");
				$result = mysqli_query($connection, 
				"SELECT idSmartphones,Productname,Description,PhoneType,StorageGB,grade,price, stock
				FROM sp_phones
				WHERE idSmartphones = '$phoneID';");
	

	if (!@mysqli_query($connection, "UPDATE sp_phones SET stock = $quantities WHERE idSmartphones ='$phoneID'")) 
	{
		echo "Error doing update";
	} 
	else 
	{
		$rows = mysqli_affected_rows($connection);
		echo "Success, update $rows Phone's Quantity";
	}
		
	@mysqli_close($connection);
?>
		<?php $connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");
	$nameUser =  $_SESSION['user']['adminUsername'];
	
		if (!@mysqli_query($connection, "INSERT INTO SP_trans_log values (null,'$nameUser', SYSDATE(),'this user manualy updated stock quantity of phones ID :$phoneID')")) {
		//echo "Fail to add user action into logs. please try again";
	} else {
		$rows = mysqli_affected_rows($connection);
		
		
	}
		
	@mysqli_close($connection);?>
		<a href="stock.php">Go Back</a>
		
		</div>
		<?php require 'includes/footer.php';?>
</div>

</body>
</html>

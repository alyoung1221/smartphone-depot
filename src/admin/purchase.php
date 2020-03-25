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
<link rel="stylesheet" type="text/css" href="css/mystyle.css">
<link href="css/bootstrap-4.3.1.css" rel="stylesheet">

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
		
		<h1>Add New Purchase</h1>
		
			<form method="post" action="addnewpurchase.php">
	
			<label for="formGroupExampleInput">Customers Name:</label></br>
			<input class="form-control" type="text" name = "customername" id = "cusname" placeholder="Enter Customer Name"></br>
		   <label for="formGroupExampleInput">Invoice:</label></br>
			<input type="text" class="form-control" name ="invoice" placeholder="Invoice"></br>
		  <label for="formGroupExampleInput">Description:</label></br>
			<input type="text" class="form-control" name ="description" placeholder="Description"></br>
			<label for="formGroupExampleInput">Quantity:</label></br>
		<input type="text" class="form-control" name ="quantity" placeholder="quantity"></br>
		  <label for="formGroupExampleInput">ToTal:</label></br>
		<input type="text" class="form-control" name ="total" placeholder="Total pay"></br>
		<label for="formGroupExampleInput">Status:</label></br>
		<input type="text" class="form-control" name ="status" placeholder="Status"></br>


</br>
			
	
	
  <button type="submit" class="btn btn-info">Add New Purchase</button>
</form>

		</div>
		<?php require 'includes/footer.php';?>
</div>

</body>
</html>

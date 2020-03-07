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
		
		<h1>ADD New Expense</h1>
		
			<form method="post" action="addnewexpense.php">
	
			<label for="formGroupExampleInput">Expense:</label></br>
			<input class="form-control" type="text" name = "expense" id = "expensed" placeholder="Enter Expensed"></br>
		  <label for="formGroupExampleInput">Description:</label></br>
			<input type="text" class="form-control" name ="description" placeholder="Description"></br>
		  <label for="formGroupExampleInput">ToTal:</label></br>
		<input type="text" class="form-control" name ="total" placeholder="Total Expense"></br>


</br>
			
	
	
  <button type="submit" class="btn btn-info">Add New Expense</button>
</form>

		</div>
		<?php require 'includes/footer.php';?>
</div>

</body>
</html>

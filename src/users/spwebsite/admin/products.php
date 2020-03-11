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
		
		<h1>ADD New Phones</h1>
		
			<form method="post" action="addnewPhones.php">
			
			<label for="formGroupExampleInput">IMEI:</label></br>
			<input class="form-control" type="text" name = "imeinumber" id = "imeiNumber" placeholder="Scan/Enter IMEI number"></br>
		  <label for="formGroupExampleInput">Phone Name:</label></br>
			<input type="text" class="form-control" placeholder="phone name"></br>
		  <label for="formGroupExampleInput">Phone Type:</label></br>
		 
			<select class="form-control">
  <option>1</option>
  <option>2</option>
  <option>3</option>
  <option>4</option>
  <option>5</option>
</select></br>
		 <label for="formGroupExampleInput">Color:</label></br>
	
			<input type="text" class="form-control" placeholder=".col-xs-4"></br>
		  <label for="formGroupExampleInput">Grade:</label></br>
	
			<input type="text" class="form-control" placeholder=".col-xs-4"></br>
			<label for="formGroupExampleInput">Price:</label></br>
	
			<input type="text" class="form-control" placeholder=".col-xs-4"></br>
			</form>
		</div>
		<?php require 'includes/footer.php';?>
</div>

</body>
</html>

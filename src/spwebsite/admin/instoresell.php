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
		
		<h1>Instore Sale</h1>
		<form class="form-group" method="post" action="showinstoresale.php">
				</br></br>
				<label for="formGroupExampleInput">Phone lookup</label></br>
				<input class="form-control" type="text" name = "imeinumbers" id = "imeiNum" placeholder="Scan/Enter IMEI number">
				<button type="submit" class="btn btn-info">Search</button>
				
			</form>
		</div>
		<?php require 'includes/footer.php';?>
</div>

</body>
</html>

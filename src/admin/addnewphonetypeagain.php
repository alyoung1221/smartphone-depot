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
		<?php 
	
	$PhoneTypes = $_POST["phonetypeses"];
	$phonetypesName = $_POST["phonetypename"];
	
	
	$connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");

	// create table sp_phonespos to hold the data

	if (!@mysqli_query($connection, "INSERT INTO sp_phonetype (idphonetype,PhoneType, PhonetypeName) 
		VALUES (null,'$PhoneTypes', '$phonetypesName')")) {
		echo "Error doing Add new phone type";
	} else {
		$rows = mysqli_affected_rows($connection);
		echo "Success, Add new $rows phone type";
	}
		
	@mysqli_close($connection);
		?>
		<div id = "content">
	
		<h1>ADD New Phones Type</h1>
		
			<form method="post" action="addnewphonetypeagain.php">
	
			<label for="formGroupExampleInput">Phone Types:</label></br>
			<input class="form-control" type="text" name = "phonetypeses" id = "phonetypes" placeholder="Enter Phone Type"></br>
		  <label for="formGroupExampleInput">Phone Type Name:</label></br>
			<input type="text" class="form-control" name ="phonetypename" placeholder="phone Type name"></br>

</br>
			
		
  <button type="submit" class="btn btn-info">Add Phone Type</button>
</form>
		</div>
		<?php require 'includes/footer.php';?>
</div>

</body>
</html>

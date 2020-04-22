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
	$expensename = $_POST["expense"];
	$description = $_POST["description"];
	
	$total = $_POST["total"];
	
	
	$connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");

	// create table sp_phonespos to hold the data

	if (!@mysqli_query($connection, "INSERT INTO sp_expense (idexpense, expensename, description, totalexpense, currentdate) 
		VALUES (null,'$expensename', '$description', $total, SYSDATE() )")) {
		echo "Error doing Add new expense";
	} else {
		$rows = mysqli_affected_rows($connection);
		echo "Success, Add new $rows expense";
	}
		
	@mysqli_close($connection);
		?>
		<div id = "content">
		<h2> New Expenses Added</h2>
		

		</div>
		<?php require 'includes/footer.php';?>
</div>

</body>
</html>

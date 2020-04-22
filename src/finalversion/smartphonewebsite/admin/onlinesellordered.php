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
<title>Online | Process</title>
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
			<div class = "contain2">
			<table class = "customtable">
			<form method="post" action="showOnlineorder.php">
			<tr>
				<td> 
					<h2>New Ordered</h2>
					<a href="#" style="color: White;" >Advanced Search</a></br></br>
					<label>New Online Order: (<?php $connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");
				$result = mysqli_query($connection, 
				"select count(*) FROM SP_phone_onlinesell_record;");
				while ($row = mysqli_fetch_row($result)){
				echo $row[0];}
				mysqli_free_result($result);
				mysqli_close($connection);?>)</label></br>
					<button type="submit" name="show_btn" class = "btn btn-secondary btn-lg btn-block"> Show Online Ordered</button>
				</td>
			</tr>
			</table>
			</form>
			<form method="post" action="packprocessorder.php">
			</div>
			<div class = "contain2">
			<table class = "customtable">
			<tr>
			<td> 
				<h2>Process Ordered</h2>
				<a href="#" style="color: White;" >Advanced Search</a></br></br>
				<label>Order To Be Processed :(<?php $connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");
				$result = mysqli_query($connection, 
				"select count(*) FROM SP_Online_orderprocess_record;");
				while ($row = mysqli_fetch_row($result)){
				echo $row[0];}
				mysqli_free_result($result);
				mysqli_close($connection);?>)</label></br>
				<button type="submit" name="show_btn" class = "btn btn-secondary btn-lg btn-block"> Pack</button>
			</td>
			</tr>
			</form>
			</table>
			
			</div>
			<div class = "contain2">
			<table class = "customtable">
			<tr>
			<td> 
				<h2>Ship Packages</h2>
				<a href="#" style="color: White;" >Advanced Search</a></br></br>
				<label>carrier :</label><input type="text" name="carries" id ="carrier" class="form-control"></br>
				<button type="submit" name="show_btn" class = "btn btn-secondary btn-lg btn-block"> Go</button>
			</td>
			</tr>
			</table>
			
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

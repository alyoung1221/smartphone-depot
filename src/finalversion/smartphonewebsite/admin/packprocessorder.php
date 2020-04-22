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
<title>Home Website</title>
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
		
		<h1>Ordered to be Process</h1>
		<table border="1" width = 100%>
			<tr padding: 5px;>
				<th>Cart#</th>
				<th>First Name</th>
				<th>Last Name</th>
				<th>Address</th>
				<th>Ordered Date</th>
				<th>Product</th>
				<th>Description</th>
				<th>Model</th>
				<th>Storage</th>
				<th>Colors</th>
				<th>Grades</th>
				<th>Qtys</th>
				<th>ID</th>
				
			</tr>
			<?php
				$connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");
				$result = mysqli_query($connection, 
				"SELECT idBasket,CustomerFName,customerLName,address,dtcreated,
productname,description,phonetype,storageGB,color,grade,quantities,idonlineProcess
FROM SP_Online_orderprocess_record;");
				
				while ($row = mysqli_fetch_row($result)) {
			?>
			<tr>
				
				<td><?php echo $row[0];?></td>
				<td><?php echo $row[1];?></td>
				<td><?php echo $row[2];?></td>
				<td><?php echo $row[3];?></td>
				<td><?php echo $row[4];?></td>
				<td><?php echo $row[5];?></td>
				<td><?php echo $row[6];?></td>
				<td><?php echo $row[7];?></td>
				<td><?php echo $row[8];?></td>
				<td><?php echo $row[9];?></td>
				<td><?php echo $row[10];?></td>
				<td><?php echo $row[11];?></td>
				<td><?php echo $row[12];?></td>				
			</tr>
			<?php
				
				}
				mysqli_free_result($result);
				mysqli_close($connection);
			?>
		</table>
			<?php $connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");
				$phonetype = mysqli_query($connection, 
				"SELECT phonetype,storageGB, color, grade FROM SP_Online_orderprocess_record;");
				
				$result2 = mysqli_fetch_row($phonetype);
				
				$typeofphone =  $result2[0];
				$storageofphone = $result2[1];
				$colorofphone =  $result2[2];
				$gradeofphone =  $result2[3];
				?>
			<form class="form-group" method="post" action="searchPhoneOrderProcess.php">
				</br></br>
				<label for="formGroupExampleInput">Phone lookup</label></br>
				<input class="form-control" type="text" name = "imeinumbers" id = "imeiNum" placeholder="Scan/Enter IMEI number">
				<button type="submit" class="btn btn-info">Search</button>
				
			</form>
			
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

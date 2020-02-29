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
<title>show online order</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
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
		
		<h1>Online Ordered</h1>
		<table border="1" width = 100%>
			<tr padding: 5px;>
				<th>Cart#</th>
				<th>First Name</th>
				<th>Last Name</th>
				<th>Address</th>
				<th>Ordered Date</th>
				<th>Product</th>
				<th>Description</th>
				<th>Phone Type</th>
				<th>StorageGB</th>
				<th>Colors</th>
				<th>Grades</th>
				<th>Qtys</th>
				<th>ID#</th>
				<th>Add to Process</th>
			</tr>
			<?php
				$connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");
				$result = mysqli_query($connection, 
				"SELECT idBasket,CustomerFName,customerLName,address,dtcreated,
productname,description,phonetype,storageGB,color,grade,qtys,idonlineSaleHistory
FROM SP_phone_onlinesell_record;");
				
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
				<td><a href="ordertobeprocess.php?idonlineSaleHistory=<?php echo $row[12]?>">Add to Process</a></td>

			</tr>
			<?php
				
				}
				mysqli_free_result($result);
				mysqli_close($connection);
			?>
		</table>
		</div>
		<?php require 'includes/footer.php';?>
</div>

</body>
</html>


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
				<th>StorageGB</th>
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
			<?php 
			
			
			?>
			<form class="form-group" method="post" action="searchPhoneOrderProcess.php">
				</br></br>
				<label for="formGroupExampleInput">Phone lookup</label></br>
				<table border="1" width = 100%>
			<tr padding: 3px;>
				<th>ID#</th>
				<th>IMEI</th>
				<th>Phone Name</th>
				<th>Description</th>
				<th>Model</th>
				<th>StorageGB</th>
				<th>Colors</th>
				<th>Grades</th>
				<th>Price</th>
				
				<th>Pack</th>
			</tr>
			<?php 
				$connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");

				$phonetype = mysqli_query($connection, 
				"SELECT phonetype, storageGB,color, grade FROM SP_Online_orderprocess_record;");
				
				//===============================
				$typephone =  "test";
				$imeiNumer = $_POST["imeinumbers"];
				$phonetype10 = mysqli_query($connection, 
				"SELECT phonetype, storageGB,color,grade FROM sp_phonespos
				WHERE imei = $imeiNumer;");
				
				$result30 = mysqli_fetch_row($phonetype10);
				
				$typeofaphone =  $result30[0];
				$storageofaphone =  $result30[1];
				$colorofaphone =  $result30[2];
				$gradeofaphone =  $result30[3];
				//===============================
				while($result2 = mysqli_fetch_row($phonetype)){
				
				
				$typeofphone =  $result2[0];
				$storageofphones =  $result2[1];
				$colorofphones =  $result2[2];
				$gradeofphones =  $result2[3];
				if($typeofphone == $typeofaphone and $storageofphones == $storageofaphone and $gradeofphones == $gradeofaphone and $colorofphones == $colorofaphone )
				{
				$typephone =  $result2[0];
				$storagephones =  $result2[1];
				$colorphones =  $result2[2];
				$gradephones =  $result2[3];
				echo $typephone;
				echo $storagephones;
				echo $colorphones;
				echo $gradephones;
				}
				
				
				
				}
				mysqli_free_result($phonetype);
			?>
				<?php 
				$imeiNumer = $_POST["imeinumbers"];
				$phonetype1 = mysqli_query($connection, 
				"SELECT phonetype, storageGB,color,grade FROM sp_phonespos
				WHERE imei = $imeiNumer;");
				
				$result3 = mysqli_fetch_row($phonetype1);
				
				$typeofphones =  $result3[0];
				$storageofphoness =  $result3[1];
				$colorofphoness =  $result3[2];
				$gradeofphoness =  $result3[3];
				echo "Messege: ";
				echo $typeofphones;
				echo $storageofphoness;
				echo $colorofphoness;
				echo $gradeofphoness;
				$phonetype2 = mysqli_query($connection, 
				"SELECT imei FROM sp_phonespos
				WHERE imei = $imeiNumer;");
				
				$result4 = mysqli_fetch_row($phonetype2);
				
				$phoneimei =  $result4[0];
				//===============================
				
				
				//==============================
				if($phoneimei == $imeiNumer)
				{
				
				if($typephone == $typeofphones  AND $storagephones == $storageofphoness and $colorphones ==$colorofphoness and $gradephones == $gradeofphoness)
				{
				?>
				<?php 
				
				$connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");
				$result1 = mysqli_query($connection, 
				"SELECT idphonepos,imei,phonename,description,phonetype,storageGB,color,grade,price
				 FROM sp_phonespos
				 WHERE imei = $imeiNumer;");
				 while ($row = mysqli_fetch_row($result1)) {
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
				<td><a href="orderprocessed.php?idphonepos=<?php echo $row[0]?>">Pack</a></td>

			</tr>
			<?php
				 
				}
				mysqli_free_result($result1);
				}
				else 
				{
					echo "The Phone is not in the order, please scan other Phone!";
				}
				}
				else{
					echo "There is no Phone that match IMEI number. please add the phone you want to sell first";
				}
				//mysqli_free_result($result1);
				mysqli_close($connection);
			?>
			</table>
			
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

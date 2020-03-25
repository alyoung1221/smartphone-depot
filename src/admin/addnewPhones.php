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
	$IMEI = $_POST["imeinumber"];
	$PhoneNames = $_POST["phonename"];
	
	$phonetypes = $_POST["phonetype"];
	$storage = $_POST["storagegbs"];
	$colors = $_POST["color"];
	$grades = $_POST["grade"];
	$prices = $_POST["price"];
	
	$connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");

	// create table sp_phonespos to hold the data

	if (!@mysqli_query($connection, "INSERT INTO sp_phonespos (idphonepos, IMEI, PhoneName, PhoneType, storageGB, color, grade, price) 
		VALUES (null,'$IMEI', '$PhoneNames', '$phonetypes', $storage, '$colors','$grades', $prices )")) {
		echo "Error doing Add new inventory";
	} else {
		$rows = mysqli_affected_rows($connection);
		echo "Success, Add new $rows inventory";
	}
		
	@mysqli_close($connection);
		?>
		<div id = "content">
		
		<h1>ADD New Phones</h1>
		
			<form method="post" action="addnewPhones.php">
	
			<label for="formGroupExampleInput">IMEI:</label></br>
			<input class="form-control" type="text" name = "imeinumber" id = "imeiNumber" placeholder="Scan/Enter IMEI number"></br>
		  <label for="formGroupExampleInput">Phone Name:</label></br>
			<input type="text" class="form-control" name ="phonename" placeholder="phone name"></br>
		  <label for="formGroupExampleInput">Phone Type:</label></br>
		 <?php
				$columnPhonetype = "phonetype";
				$columnPhoneName = "PhonetypeName";
				$connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");
				$result = mysqli_query($connection, 
				"SELECT * from sp_phonetype");
				
				
			?>
<select class="customdrop" name = "phonetype">
<option value="#">-Choose One-</option>
<?php while ($row = mysqli_fetch_array($result)) 
{
	
	$columnPhonetypeName = $row["$columnPhoneName"];
	$columnPhonetypes = $row["$columnPhonetype"];
   echo "<option value='".$columnPhonetypes."'>$columnPhonetypeName</option>";
}
  ?>
</select>
<label for="inputstorage">Storage GB</label>
      <input type="text" class="form-control" name = "storagegbs" id="inputstorage" placeholder="Storage GB">
</br>
			<?php
				
				
				mysqli_free_result($result);
				mysqli_close($connection);
			?>
	
		 <div class="form-row">
    <div class="form-group col-md-4">
      <label for="inputcolor">Color</label>
      <input type="text" class="form-control" name = "color" id="inputcolor" placeholder="Color">
    </div>
    <div class="form-group col-md-4">
      <label for="inputgrade">Grade</label>
      <input type="text" class="form-control" name = "grade" id="inputgrade" placeholder="Grade">
    </div>
	<div class="form-group col-md-4">
      <label for="inputprice">Prices</label>
      <input type="text" class="form-control" name = "price" id="inputprice" placeholder="Price">
    </div>
  </div>
  <button type="submit" class="btn btn-info">Add To Inventory</button>
</form>
<?php $connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");
	$nameUser =  $_SESSION['user']['adminUsername'];
	
		if (!@mysqli_query($connection, "INSERT INTO SP_trans_log values (null,'$nameUser', SYSDATE(),'this user Add a new Phone: imei# : $IMEI')")) {
		//echo "Fail to add user action into logs. please try again";
	} else {
		$rows = mysqli_affected_rows($connection);
		
		
	}
		
	@mysqli_close($connection);?>
		</div>
		<?php require 'includes/footer.php';?>
</div>

</body>
</html>

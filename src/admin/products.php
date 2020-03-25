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

		</div>
		<?php require 'includes/footer.php';?>
</div>

</body>
</html>

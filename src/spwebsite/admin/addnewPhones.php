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
	$colors = $_POST["color"];
	$grades = $_POST["grade"];
	$prices = $_POST["price"];
	
	$connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");

	// create table sp_phonespos to hold the data

	if (!@mysqli_query($connection, "INSERT INTO sp_phonespos (idphonepos, IMEI, PhoneName, PhoneType, color, grade, price) 
		VALUES (null,'$IMEI', '$PhoneNames', '$phonetypes','$colors','$grades', $prices )")) {
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
		 
<select class="customdrop" name = "phonetype">
<option value="#">-Phone Type-Choose One-</option>
   <option value="iphoneX64orange">iphoneX-64GB-orange</option>
  <option value="iphoneX64green">iphoneX-64GB-green</option>
  <option value="iphoneX64yellow">iphoneX 64GB yellow</option>
  <option value="iphoneX128orange">iphoneX-128GB-orange</option>
  <option value="iphoneX128green">iphoneX-128GB-green</option>
   <option value="iphoneX128yellow">iphoneX-128GB-yellow</option>
  <option value="iphoneX256orange">iphoneX-256GB-orange</option>
  <option value="iphoneX256green">iphoneX-256GB-green</option>
  <option value="iphoneX256yellow">iphoneX-256GB-yellow</option>
  <option value="iphoneXS64orange">iphoneXS-64Gb-orange</option>
   <option value="iphoneXS64green">iphoneXS-64Gb-green</option>
  <option value="iphoneXS64yellow">iphoneXS-64Gb-yellow</option>
  <option value="iphoneXS128orange">iphoneXS-128Gb-orange</option>
  <option value="iphoneXS128green">iphoneXS-128Gb-green</option>
  <option value="iphoneXS128yellow">iphoneXS-128Gb-yellow</option>
   <option value="iphoneXS256orange">iphoneXS-256Gb-orange</option>
  <option value="iphoneXS256green">iphoneXS-256Gb-green</option>
  <option value="iphoneXS256yellow">iphoneXS-256Gb-yellow</option>
  <option value="iphoneXR64orange">iphoneXR-64Gb-orange</option>
  <option value="iphoneXR64green">iphoneXR-64Gb-green</option>
</select></br>
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

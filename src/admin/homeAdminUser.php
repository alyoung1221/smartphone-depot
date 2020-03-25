<?php 
include('phpmaincode.php');


if (!isLoggedIn()) {
	$_SESSION['msg'] = "You must log in first to be continue!";
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
<style>
* {
  box-sizing: border-box;
}

body {
  margin: 0;
}

/* Style the header */
.header {
  background-color:#B6F5B1;
  padding: 20px;
  text-align: center;
}

/* Style the top navigation bar */
.topnav {
  overflow: hidden;
  background-color: #333;
  
}

/* Style the topnav links */
.topnav a {
  float: left;
  display: block;
  color: #f2f2f2;
  text-align: center;
  padding: 14px 16px;
  text-decoration: none;
}
	.detail{
		background-color:#C2E0F7;
		font-size: 15pt;
	}
/* Change color on hover */
.topnav a:hover {
  background-color: #ddd;
  color: black;
}

/* Create three equal columns that floats next to each other */
.column {
  float: left;
  width: 25%;
  padding: 15px;
  background-color: #457575;
}
.column2 {
  float: left;
  width: 25%;
  padding: 15px;
  background-color:#E0F2A1;
}
	.column3 {
  float: left;
  width: 25%;
  padding: 15px;
  background-color:#46AB48;
}
/* Clear floats after the columns */
.row:after {
  content: "";
  display: table;
  clear: both;
}

/* Responsive layout - makes the three columns stack on top of each other instead of next to each other */
@media screen and (max-width:600px) {
  .column {
    width: 100%;
  }
}
</style>
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
<div class="header">
  <h1> Employee Dashboard</h1>
	<?php  if (isset($_SESSION['user'])) : ?>
					<strong><?php echo" Hi. ", $_SESSION['user']['adminUsername']; ?></strong>

					<small>
						<i  style="color: #888;">(<?php echo ucfirst($_SESSION['user']['adminLevel']); ?>)</i> 
	
	<?php endif ?>
		<h3>Welcome to Admin Management</h3>
  
</div>

<div class="topnav">
  <a href="#"></a>
  <a href="#"></a>
  <a href="#"></a>
</div>

<div class="row">
  <div class="column">
    <h2>Visitors:</h2>
    <a href="#" class="detail">Detail:>>></a>
  </div>
  
  <div class="column">
    <h2>New Order: </h2>
    <a href="#" class="detail">Detail >>></a>
  </div>
  
  <div class="column">
    <h2>Status</h2>
    <a href="#" class="detail">Detail >>></a>
  </div>
	<div class="column">
    <h2>New Ticket</h2>
    <a href="#" class="detail">Detail >>></a>
  </div>
</div>
<div class="row">
  <div class="column2">
    <h2>Report</h2>
    <a href="#" class="detail">Detail >>></a>
  </div>
  
  <div class="column2">
    <h2>Option</h2>
    <a href="homeAdminUser.php?logout='1'" class="detail">logout</a>
                       
  </div>
  
  <div class="column2">
    <h2>Option</h2>
    <a href="#" class="detail">Detail >>></a>
  </div>
	<div class="column2">
    <h2>Print</h2>
    <a href="#" class="detail">Detail >>></a>
  </div>
</div><div class="row">
  <div class="column3">
    <h2>Add New Inventory</h2>
    <a href="#" class="detail">Detail >>></a>
  </div>
  
  <div class="column3">
    <h2>Update Inventory</h2>
    <a href="#" class="detail">Detail >>></a>
  </div>
  
  <div class="column3">
    <h2>Manage Comment</h2>
    <a href="#" class="detail">Detail >>></a>
  </div>
	<div class="column3">
    <h2>Order Processed</h2>
    <a href="#" class="detail">Detail >>></a>
  </div>
</div>
</body>
</html>

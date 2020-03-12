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
<link href="http://code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css" rel="stylesheet" type="text/css">
<script src="http://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="http://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
  <link rel="stylesheet" href="/resources/demos/style.css">
  <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
 <script>
  $( function() {
    $( "#datepicker" ).datepicker();
	$( "#todaypicker" ).datepicker();
  } );
  </script>
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
		
		<h1>Sale Report</h1>
		
			<form method="post" action="showsalereport.php">
	
			<label for="dateinput">From:</label></br>
			<input class="form-control" type="text" name = "dateinput" id = "datepicker" placeholder="From Date"></br>
		  <label for="todate">To:</label></br>
			<input type="text" class="form-control" name ="todateinput" id = "todaypicker" placeholder="To Date"></br>
		  </br>
			
	
		
  <button type="submit" class="btn btn-info">Report</button> </br>
  <table border="1" width = 100%>
			<tr padding: 5px;>
				
				<th>IMEI#</th>
				<th>Phone Name</th>
				<th>Storage GB</th>
				<th>Model</th>
				<th>Phone Color</th>
				<th>Grade</th>
				<th>Price</th>
				<th>Date Sold</th>
				<th>Action</th>
				
				
			</tr>
			<?php
				$startdate = $_POST["dateinput"];
				$enddate = $_POST["todateinput"];
				$newstartdate = date("Y-m-d", strtotime($startdate));
				$newenddate = date("Y-m-d", strtotime($enddate));
				echo $newstartdate;
				$connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");
				
				$result = mysqli_query($connection, 
				"SELECT idSmartPhones, ProductName, storageGB, PhoneType, sphonecolor, grade, price, datesold, actionTaken
				FROM SP_phone_sales_history
				WHERE CAST(currentdate AS DATE) BETWEEN '$newstartdate' AND '$newenddate';");
				
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
				
				
				

			</tr>
			<?php
				
				}
				$result1 = mysqli_query($connection, 
				"SELECT SUM(price)
				FROM SP_phone_sales_history
				WHERE CAST(currentdate AS DATE) BETWEEN '$newstartdate' AND '$newenddate';");
				$rowes = mysqli_fetch_row($result1);
				
				$result2 = mysqli_query($connection, 
				"SELECT count(idsalehistory)
				FROM SP_phone_sales_history
				WHERE CAST(currentdate AS DATE) BETWEEN '$newstartdate' AND '$newenddate';");
				$rowess = mysqli_fetch_row($result2);
				
				echo "Total Number of Phone Sale in $startdate and $enddate is : ", $rowess[0];?> </br><?php
				echo "Total Sales : $", $rowes[0];
				
				
				mysqli_free_result($result);
				mysqli_close($connection);
			?>
		</table>
</form>
		</div>
		<?php require 'includes/footer.php';?>
</div>

</body>
</html>

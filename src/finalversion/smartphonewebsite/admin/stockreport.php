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
<title>Stock report</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="css/bootstrap-4.3.1.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="css/mystyle.css">
<link href="css/styles.css" rel="stylesheet" type="text/css">
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
		
		<h1>Stock Report</h1>
		
		
		<table border="1" width = 100%>
			<tr padding: 5px;>
				
				<th>IMEI</th>
				<th>Phone Name</th>
				<th>Description</th>
				<th>Model</th>
				<th>StorageDB</th>
				<th>Color</th>
				<th>grade</th>
				<th>price</th>
				
				
				
				
			</tr>
			<?php
				
				$connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");
				//===========================================================================
				$reclimit = 5;
				 if( isset($_GET["page"] ) )
				{
					$page = $_GET["page"];
					
				}
				else
				{
					$page = 1;
					
				}
				$startfrom = ($page-1) * $reclimit;
				
				
				//echo $rec_count;
				
				 //$left_rec = $rec_count - ($page * $reclimit);
				//==================================================================
				$result = mysqli_query($connection, 
				"SELECT IMEI,phonename,P_OPT_ID,PhoneType,StorageGB,color, grade,price
				FROM sp_phonespos LIMIT $startfrom, $reclimit;");
				
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
				
			</tr>
			<?php
				}
					
				$result = mysqli_query($connection, 
				"SELECT count(idphonepos)
				FROM sp_phonespos;");
				
				if(!$result) 
				{
					die('Could not get data: ' . mysql_error());
				}
				$row = mysqli_fetch_row($result);
				$rec_count = $row[0];
				echo "Total Phone In stock are: ",$rec_count; ?> </br><?php
				// Number of pages required. 
        $total_pages = ceil($rec_count / $reclimit);   
        $pagLink = "";                         
        for ($i=1; $i<=$total_pages; $i++) { 
          if ($i==$page) { 
              $pagLink .= " Page: <a href='stockreport.php?page=".$i ."'> ".$i." , </a>"; 
          }             
          else  { 
              $pagLink .= "<a href='stockreport.php?page=".$i."'> ".$i.", </a>";   
          } 
        };   
        echo $pagLink; 
				
				
				
				
			?>
		</div>
		<div>
<?php 
		 /* $pagelink = "";	
		  for ($j=1; $j<=$total_pages; $j++) { 
          if ($j==$page) { 
              $pagelink .= "<a href='stockreport.php?page="
                                                .$j."'>".$j."</a>"; 
          }             
          else  { 
              $pagelink .= "<a href='stockreport.php?page=".$j."'> 
                                                ".$j."</a>";   
          } 
        }
        echo $pagelink; */
				mysqli_free_result($result);
				mysqli_close($connection);
?>



</div>
		<?php require 'includes/footer.php';?>
</div>

</body>
</html>

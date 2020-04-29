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
<title>Smartphone Depot</title>
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
		
		<h1>Training Help Tools</h1>
		
		<p>* User Management: The User Management page is for Admin to manage the account of Employees, including Created and Delete the account </p>	
		<p>* Online Sale: Admin can manage the online ordered and process the customers online orders of the website</p>	
		<p>* In-Store Sale: Admin can manage the order for customers who walk-in the store to buy the products</p>	
		<p>* Product: This tab for add a new inventory into the database</p>	
		<p>* ADD New Phone Model: This tab for adding the new model of the products that the company want to sale</p>	
		<p>* Purchase: This tab is adding the company purchase the new inventory from vendor into the database</p>	
		<p>* Expense: This tab is adding the company expense into the database for the report purpose</p>	
		<p>* Stock: this tab for Admin can see the quantity of the each type of products, and manage the quantity on hand</p>	
		<p>* Add Product Model Detail: This tab for adding the detail of the new product into the database </p>	
		<p>* Report: All report for company for audit purpose </p>	

		</div>
		<?php require 'includes/footer.php';?>
</div>

</body>
</html>

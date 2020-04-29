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
		
		<div id="content">
		<h2>Create User Account for POS</h2>
		<form method="post" action="createUserAccount.php">

		<?php echo display_error(); ?>

		<div class="#">
			<label>Username</label></br>
			<input type="text" name="username" value="<?php echo $username; ?>" placeholder = "Enter Username">
		</div>
		<div>
			<label>Email</label></br>
			<input type="email" name="email" value="<?php echo $email; ?>" placeholder = "Enter Email Address">
		</div>
		<div>
			<label>User type</label></br>
			<select name="adminlevel" id="adminlevel" class="customerSelect">
				<option value="">Choose one</option>
				<option value="admin">Admin</option>
				<option value="user">User</option>
			</select></br>
		</div>
		<div class="">
			<label>Password</label></br>
			<input type="password" name="password_1" placeholder = "Enter Password"></br>
		</div>
		<div class="">
			<label>Confirm password</label></br>
			<input type="password" name="password_2" placeholder = "Confirm Password"></br>
		</div>
		<div class="customBtn">
			<button type="submit" name="register_btn" class = "customBtn">  Create user</button>
			<button type="submit" name="show_btn" class = "customBtnshow">  Show All Users</button>
		</div>
	</form>
	
	<div class = "customContent">
	
	<table border="1" width ="600px;">
			<tr padding: 5px;>
				
				<th>ID admin</th>
				<th>Username</th>
				<th>admin level</th>
				<th>Delete</th>
			</tr>
			<?php
				$connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");
				$result = mysqli_query($connection, "SELECT 	idadmin, 	adminUsername, adminLevel FROM loginadmin");
				
				while ($row = mysqli_fetch_row($result)) {
			?>
			<tr>
				<td><?php echo $row[0];?></td>
				<td><?php echo $row[1];?></td>
				<td><?php echo $row[2];?></td>
				<td><a href="delete.php?idadmin=<?php echo $row[0]?>&adminUsername=<?php echo $row[1]?>">Delete</a></td>

			</tr>
			<?php
				
				}
				mysqli_free_result($result);
				mysqli_close($connection);
			?>
		</table>
	
	</div>
  
		<a href="index.php?logout='1'" style="color: red;">logout</a>
		</div>
		<?php require 'includes/footer.php';?>
</div>

</body>
</html>

<?php include('phpmaincode.php') ?>
<!DOCTYPE html>
<html>
<head>
	<title>Registration system PHP and MySQL</title>
	<link rel="stylesheet" type="text/css" href="css/mystyle.css">
	
</head>
<body>
<div class = "login">
	<div>
		<h1>Login to POS</h1>
	</div>
	<form method="post" action="adminlogin.php">

		<?php echo display_error(); ?>

		<div >
			<label>Username</label>
			<input type="text" name="username" >
		</div>
		<div>
			<label>Password</label>
			<input type="password" name="password">
		</div>
		<div ">
			<button type="submit" class="customBtn" name="login_btn">Login</button>
		</div>
		<p>
			Not yet a member? <a href="adminregister.php">Sign up</a>
		</p>
	</form>
	</div>
</body>
</html>
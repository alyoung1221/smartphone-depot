<?php include('phpmaincode.php') ?>
<!DOCTYPE html>
<html>
<head>
	<title>Registration system PHP and MySQL</title>
	<link href="css/mystyles.css" rel="stylesheet" type="text/css">
</head>
<body>
<div class="header">
	<h2>Register</h2>
</div>
<form method="post" action="adminregister.php">
	<?php echo display_error(); ?>
	<div class="input-group">
		<label>Username</label>
		<input name="username" value="<?php echo $username; ?>">
	</div>
	<div class="input-group">
		<label>Email</label>
		<input type="email" name="email" value="<?php echo $email; ?>">
	</div>
	<div class="input-group">
		<label>Password</label>
		<input type="password" name="password_1">
	</div>
	<div class="input-group">
		<label>Confirm password</label>
		<input type="password" name="password_2">
	</div>
	<div class="input-group">
		<button type="submit" class="btn" name="register_btn">Register</button>
	</div>
	<p>
		Already a member? <a href="adminlogin.php">Sign in</a>
	</p>
</form>
</body>
</html>
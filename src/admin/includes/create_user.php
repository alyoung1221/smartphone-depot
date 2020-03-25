<?php 
include('phpmaincode.php');
if (!isAdmin()) {
	$_SESSION['msg'] = "You must log in first";
	header('location: adminlogin.php');
}

if (isset($_GET['logout'])) {
	session_destroy();
	unset($_SESSION['user']);
	header("location: adminlogin.php");
}
?>

	<div id="content">
	<form method="post" action="create_user.php">

		<?php echo display_error(); ?>

		<div class="input-group">
			<label>Username</label>
			<input type="text" name="username" value="<?php echo $username; ?>"></br>
		</div>
		<div class="input-group">
			<label>Email</label>
			<input type="email" name="email" value="<?php echo $email; ?>"></br>
		</div>
		<div class="input-group">
			<label>User type</label>
			<select name="adminlevel" id="adminlevel" >
				<option value=""></option>
				<option value="admin">Admin</option>
				<option value="user">User</option>
			</select></br>
		</div>
		<div class="input-group">
			<label>Password</label>
			<input type="password" name="password_1"></br>
		</div>
		<div class="input-group">
			<label>Confirm password</label>
			<input type="password" name="password_2"></br>
		</div>
		<div class="input-group">
			<button type="submit" class="btn" name="register_btn"> + Create user</button>
		</div>
	</form>
</div>

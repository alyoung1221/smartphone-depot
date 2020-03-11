<!DOCTYPE HTML>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title> My Account | Smartphone Depot</title>
	<link href="css/styles.css" rel="stylesheet" type="text/css">
	<link rel="icon" href="assets/favicon.png" type="image/x-icon">
</head>
<body>
	<?php 
		include("components/header.php");
	?>
	<main>
		<section id="acct">
			<h1 tabindex="0">My Account</h1>
			<div class="flex-container">
				<form action="<?php echo ($_SERVER["PHP_SELF"]);?>" method="post" id="login">
					<fieldset>
						<legend>Login</legend><br><br>
						<label>Username or E-mail Address<span class="required">*</span></label><br><br>
						<div class="form-group <?php echo (!empty($username_error)) ? 'has-error' : '';?>">
							<input type="text" name="username" data-validation="required" data-validation-error-msg="Username is required"><br><br>
							<span class="help-block"></span>
						</div>
						<div class="form-group">
							<label for="password">Password<span class="required">*</span></label><br><br>
							<input type="password" name="password" data-validation="required" data-validation-error-msg="Password is required"><br><br>
							<span class="help-block"></span>
						</div>
						<button type="submit" name="login">Log In</button>
					</fieldset>
				</form>
				<form method="post" id="register">
					<fieldset>
						<legend>Register</legend><br><br>
						 <div class="form-group">
							<label for="username">Email Address<span class="required">*</span></label>
							<br><br>
							<input type="email" id="username" name="email" placeholder="E-mail*" title="Please enter your e-mail." maxlength="60"><br><br>
							<span class="help-block"></span>
						</div>
						<div class="form-group">
							<label for="password">Password<span class="required">*</span></label>
							<br><br>
							<input type="password" name="password" id="password" class="form-control">
							<span class="help-block"></span>
           				</div>
						<br>
           				<div class="form-group">
                			<label for="password2">Confirm Password</label>
							<br><br>
               				<input type="password" name="confirm_password" id="password2" class="form-control" data-validation="confirmation" data-validation-confirm="password">
                			<span class="help-block"></span><br><br>
            			</div>
							<label for="fname">First Name<span class="required">*</span></label>
							<br><br>
							<input type="text" id="fname" name="fname" placeholder="First Name" maxlength="50" data-validation="required"><br><br>
							<label for="lname">Last Name<span class="required">*</span></label>
							<br><br>
							<input type="text" id="lname" name="lname" placeholder="Last Name" maxlength="50" data-validation="required"><br><br>
							<label for="address">Address 1<span class="required">*</span></label>
							<br><br>
							<input type="text" id="address" name="address" placeholder="Address" maxlength="50" data-validation="required"><br><br>
							<label for="address2">Address 2</label>
							<br><br>
							<input type="text" id="address2" name="address" placeholder="Address 2" maxlength="50"><br><br>
							<label for="city">City<span class="required">*</span></label>
							<br><br>
							<input type="text" id="city" name="city" placeholder="City" maxlength="50" data-validation="required"><br><br>
							<!--<input type="city" name="city" class="form-control" value="">-->
							<label>State<span class="required">*</span></label>
							<br><br>
							<input type="text" name="state" placeholder="State" data-validation="federatestate">
							<br><br>
							<label for="zipcode">Zipcode<span class="required">*</span></label>
							<br><br>
							<input type="text" id="zipcode" name="zip" placeholder="Zipcode" maxlength="50" data-validation="number" data-validation-allowing="range[10000;99999]" data-validation-error-msg="Invalid zipcode"><br><br>
							<label for="country">Country<span class="required">*</span></label> 
							<br><br>
							<input type="text" id="country" name="country" placeholder="Country" maxlength="50" data-validation="country">
							<br><br>
							<label for="phone">Phone<span class="required">*</span></label>
							<br><br>
							<input type="tel" id="phone" name="phone" placeholder="Phone Number" maxlength="50" data-validation="required"><br><br>
							<p>Your personal data will be used to support your experience throughout this website,
							to manage access to your account, and for other purposes as described in our <a href="privacy-policy.html">privacy policy</a>.</p><br>
							<button type="submit" name="register">Register</button>
					</fieldset>
				</form>		
			</div>
		</section>
	</main>
	
	<!--Footer-->
	<?php 
		readfile("components/footer.html");
	?>
	
	<!--Scripts-->
	<?php 
		readfile("js/scripts.html");
	?>
	<script src="js/script.js"></script>
	<script src="//cdnjs.cloudflare.com/ajax/libs/jquery-form-validator/2.3.26/jquery.form-validator.min.js"></script>
	<script>	
		$.validate({
			modules: 'security, location',
			borderColorOnError: "#E60000",
			errorMessagePosition: 'bottom', 
			onModulesLoaded : function() {
				$('input[name="state"]').suggestState();
				$('#country').suggestCountry();
				 
			}// end onmodulesloaded
		});// end validate module
	</script>
</body>
</html>
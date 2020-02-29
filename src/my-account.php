<!DOCTYPE HTML>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" query="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta http-equiv="X-UA-Compatible" query="IE=edge">
	<title> My Account | Smartphone Depot</title>
	<link href="css/styles.css" rel="stylesheet" type="text/css">
	<link rel="icon" href="images/favicon.png" type="image/x-icon">
</head>
<body>
	<?php 
		readfile("header.html");
	?>
	<main>
		<h1>MY ACCOUNT </h1><br><br><br><br>
		<div class="flex-container">
			<form id="acct">
				<h2> LOGIN </h2> <br><br>
				<p>USER NAME OR E-MAIL ADDRESS * </p><br>
				<input type="text" name="loginID" required> <br><br>
				<p>PASSWORD * </p><br>
				<input type="password" name="password" required> <br><br>
				<button type = "submit"> Log in </button> 

			</form>

			<section id = "registerInfo">
				<div>		
					<form method = "post" id = "register">
						<h2> REGISTER </h2> <br><br>
						<label for="email" >EMAIL ADDRESS * </label>
						<input type="email" id="email" name="email" placeholder="E-mail*" title="Please enter your e-mail." maxlength="60" ><br><br>
						<p> A password will be sent to your email address </p> <br><br>
						<label for = "fname"> FIRST NAME * </label>
						<input type = "text" id = "fname" name = "fname" placeholder = "First Name" maxlength= "50"><br><br>
						<label for = "lname"> LAST NAME* </label>
						<input type = "text" id = "lname" name = "lname" placeholder = "Last Name" maxlength= "50"><br><br>
						<label  for = "address"> ADDRESS 1 * </label>
						<input type = "text" id = "address" name = "address" placeholder = "Address" maxlength= "50"><br><br>
						<label for = "address2"> ADDRESS 2 </label>
						<input type = "text" id = "address" name = "address" placeholder = "Address 2" maxlength= "50"><br><br>
						<label for = "city"> CITY * </label>
						<input type = "text" id = "city" name = "city" placeholder = "City" maxlength= "50"><br><br>
						<label for = "state"> State * </label> 
						<input type = "text" id = "state" name = "state" placeholder = "State" maxlength= "50"><br><br>
						<label for = "zip"> ZIP * </label>
						<input type = "text" id = "zip" name = "zip" placeholder = "Zipcode" maxlength= "50"><br><br>
						<label for = "country"> COUNTRY * </label> 
						<input type = "text" id = "country" name = "country" placeholder = "Country" maxlength= "50"><br><br>
						<label for = "phone"> PHONE * </label>
						<input type = "text" id = "phone" name = "phone" placeholder = "Phone Number" maxlength= "50"><br><br>
						<p>Your personal data will be used to support your experience throughout this website,
						to manage access to your account, and for other purposes described in our privacy policy.</p><br>
						<button type="submit">Register</button>

					</form>
			</div>				
	</main>
	<?php 
		readfile("footer.html");
	?>
	<script src="https://kit.fontawesome.com/b217619af5.js" crossorigin="anonymous"></script>
	<script src="http://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script src="http://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
	<script src="js/script.js"></script>
	<script type="text/javascript">
	</script>
</body>
</html>
<?php
// Initialize the session
session_start();
 
// Check if the user is already logged in, if yes then redirect him to welcome page
if(isset($_SESSION["loggedin"]) && $_SESSION["loggedin"] === true){
    header("location: shoppingcart.php");
//====================conncection and create the basket to the database================
 
//=================================
    exit;
}
 
// Include config file
require_once "config.php";
 
// Define variables and initialize with empty values
$username = "";
$password = "";
$username_error = "";
$password_error = "";
 
// Processing form data when form is submitted
if($_SERVER["REQUEST_METHOD"] == "POST"){
 
    // Check if username is empty
    if(empty(trim($_POST["username"]))){
        $username_error = "Please enter Username.";
    } else{
        $username = trim($_POST["username"]);
    }
    
    // Check if password is empty
    if(empty(trim($_POST["password"]))){
        $password_error = "Please enter your Password.";
    } else{
        $password = trim($_POST["password"]);
    }
    
    // Validate credentials
    if(empty($username_error) && empty($password_error)){
        // Prepare a select statement
       $sql = "SELECT idShopper, username, password, firstname, state FROM SP_Shopper WHERE username = ?";
        //$records = 'CALL Userlogin_sp($username,$password,$username, $password)';
        if($stmt = mysqli_prepare($link, $sql)){
            // Bind variables to the prepared statement as parameters
            mysqli_stmt_bind_param($stmt, "s", $param_username);
            
            // Set parameters
            $param_username = $username;
            
            // Attempt to execute the prepared statement
            if(mysqli_stmt_execute($stmt)){
                // Store result
                mysqli_stmt_store_result($stmt);
                
                // Check if username exists, if yes then verify password
                if(mysqli_stmt_num_rows($stmt) == 1){                    
                    // Bind result variables
                    mysqli_stmt_bind_result($stmt, $idShopper, $username, $hashed_password, $firstname, $state);
                    if(mysqli_stmt_fetch($stmt)){
                        if(password_verify($password, $hashed_password)){
                            // Password is correct, so start a new session
                            session_start();
                            
                            // Store data in session variables
                            $_SESSION["loggedin"] = true;
                            $_SESSION["idshopper"] = $idShopper;
                            $_SESSION["username"] = $username;                            
                            $_SESSION["firstname"] = $firstname;				
							$_SESSION["state"] = $state;
							//$_SESSION["idcart"] = $row[0];
                            $shopperID = $_SESSION["idshopper"];
							//=====================conncection and create the basket to the database==========================
							$connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");

							//======================================================================
							//SELECT AUTO_INCREMENT FROM information_schema.TABLES WHERE TABLE_SCHEMA = "smartphonedepotdb" AND TABLE_NAME = "sp_cart"
							$result = mysqli_query($connection, 
							"SELECT AUTO_INCREMENT FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'smartphonedepotdb' AND TABLE_NAME = 'sp_cart'");
							$row = mysqli_fetch_row($result);
							//$row[0] = $row[0] + 1;
							$_SESSION["idcart"] = $row[0];
							//======================================================================
							
							if (!@mysqli_query($connection, "insert into sp_cart(idcart,idShopper,OrderPlaced,ShipState) 
							values($row[0],$idShopper,0,'$state')")) 
							{
							//echo "Fail to add a new basket;
							} 
							else 
							{
							$rows = mysqli_affected_rows($connection);
								
							}
							  //echo "Hello, ", htmlspecialchars($_SESSION["idCart"]);
							@mysqli_close($connection);
						// Redirect user to welcome page
                            header("location: products.php");
 //=================================
							
							//==================================================
                        } else{
                            // Display an error message if password is not valid
                            $password_error = "The password you entered was not valid.";
                        }
                    }
                } else{
                    // Display an error message if username doesn't exist
					
                    $username_error = "No account found with that username.";
                }
            } else{
                echo "Oops! Something went wrong. Please try again later.";
            }
        }
        
        // Close statement
       mysqli_stmt_close($stmt);
    }
    
    // Close connection
    mysqli_close($link);
}
?>
<!DOCTYPE HTML>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" query="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta http-equiv="X-UA-Compatible" query="IE=edge">
	<title> My Account | Smartphone Depot</title>
	<link href="css/styles.css" rel="stylesheet" type="text/css">
	<link rel="icon" href="/images/favicon.png" type="image/x-icon">
</head>
<body>
		<?php 
		readfile("header1.php");
	?>	<main>
		<section id="acct">
			<h1>My Account</h1>
			<div class="flex-container">
				<form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post" id="login">
					<fieldset>
						<legend>Login</legend><br><br>
						<label>Username or E-mail Address *</label><br><br>
						<input type="text" name="username" required><br><br>
						<label for="password">Password *</label><br><br>
						<input type="password" name="password" required><br><br>
						<button type="submit" name="login">Log In</button>
					</fieldset>
				</form>
				<form method="post" id="register">
					<fieldset>
						<legend>Register/legend<br><br>
						<label for="email">Email Address *</label>
						<input type="email" id="email" name="email" placeholder="E-mail*" title="Please enter your e-mail." maxlength="60"><br><br>
							<p> A password will be sent to your email address </p> <br><br>
							<label for="fname">First Name *</label>
							<input type="text" id="fname" name="fname" placeholder="First Name" maxlength="50"><br><br>
							<label for="lname">Last Name *</label>
							<input type="text" id="lname" name="lname" placeholder="Last Name" maxlength="50"><br><br>
							<label for="address">Address 1 *</label>
							<input type="text" id="address" name="address" placeholder="Address" maxlength="50"><br><br>
							<label for="address2">Address 2</label>
							<input type="text" id="address" name="address" placeholder="Address 2" maxlength="50"><br><br>
							<label for="city">City *</label>
							<input type="text" id="city" name="city" placeholder="City" maxlength="50"><br><br>
							<label>State: </label>
							<!--<input type="city" name="city" class="form-control" value="">-->
							<select class="state" name = "state">
								<option value = "VA">- choose one -</option>
								<option value = "DC">Dictrict of Columbia</option>
									<option value = "AL">Alabama</option>
									<option value = "AK">Alaska </option>
									<option value = "AZ">Arizona </option>
									<option value = "AR">Arkansas </option>
									<option value = "CA">California </option>
									<option value = "CO">Colorado </option>
									<option value = "CT">Connecticut </option>
									<option value = "DE">Delaware </option>
									<option value = "FL">Florida </option>
									<option value = "GA">Georgia </option>
									<option value = "HI">Hawaii </option>
									<option value = "ID">Idaho </option>
									<option value = "IL">Illinois </option>
									<option value = "IN">Indiana </option>
									<option value = "IA">Iowa </option>
									<option value = "KS">Kansas </option>
									<option value = "KY">Kentucky </option>
									<option value = "LA">Louisiana </option>
									<option value = "ME">Maine </option>
									<option value = "MD">Maryland </option>
									<option value = "MA">Massachusetts </option>
									<option value = "MI">Michigan </option>
									<option value = "MN">Minnesota </option>
									<option value = "MS">Mississippi </option>
									<option value = "MO">Missouri </option>
									<option value = "MT">Montana </option>
									<option value = "NE">Nebraska</option>
									<option value = "NV">Nevada </option>
									<option value = "NH">New Hampshire</option>
									<option value = "NJ">New Jersey </option>
									<option value = "NM">New Mexico</option>
									<option value = "NY">New York</option>
									<option value = "NC">North Carolina</option>
									<option value = "ND">North Dakota</option>
									<option value = "OH">Ohio </option>
									<option value = "OK">Oklahoma </option>
									<option value = "OR">Oregon </option>
									<option value = "PA">Pennsylvania </option>
									<option value = "RI">Rhode Island</option>
									<option value = "SC">South Carolina</option>
									<option value = "SD">South Dakota</option>
									<option value = "TN">Tennessee </option>
									<option value = "TX">Texas </option>
									<option value = "UT">Utah </option>
									<option value = "VT">Vermont </option>
									<option value = "VA">Virginia </option>
									<option value = "WA">Washington </option>
									<option value = "WV">West Virginia</option>
									<option value = "WI">Wisconsin </option>
									<option value = "WY">Wyoming </option>
								</select><br><br>
							<label for="zip">Zip *</label>
							<input type="text" id="zip" name="zip" placeholder="Zipcode" maxlength="50"><br><br>
							<label for="country">County *</label> 
							<input type="text" id="country" name="country" placeholder="Country" maxlength="50"><br><br>
							<label for="phone">Phone *</label>
							<input type="text" id="phone" name="phone" placeholder="Phone Number" maxlength="50"><br><br>
							<p>Your personal data will be used to support your experience throughout this website,
							to manage access to your account, and for other purposes as described in our <a href="privacy-policy.html">privacy policy</a>.</p><br>
							<button type="submit" name="register">Register</button>
					</fieldset>
				</form>		
			</div>
		</section>
	</main>
		<footer>
		<p>&copy;<span id="date"></span> Smartphone Depot. All rights reserved.</p>
	</footer>	<script src="https://kit.fontawesome.com/b217619af5.js" crossorigin="anonymous"></script>
	<script src="http://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script src="http://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
	<script src="js/script.js"></script>
	<script type="text/javascript">
	</script>
</body>
</html>
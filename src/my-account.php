<?php
require_once("spwebsite/users/config.php");
session_start();
 
// Check if the user is already logged in, if yes then redirect him to welcome page
if(isset($_SESSION["loggedin"]) && $_SESSION["loggedin"] === true){
    header("location: profile.php");
    exit;
}
 
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
       $sql = "SELECT idShopper, username, password, firstname FROM SP_Shopper WHERE username = ?";
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
                    mysqli_stmt_bind_result($stmt, $idShopper, $username, $hashed_password, $firstname);
                    if(mysqli_stmt_fetch($stmt)){
                        if(password_verify($password, $hashed_password)){
                            // Password is correct, so start a new session
                            session_start();
                            
                            // Store data in session variables
                            $_SESSION["loggedin"] = true;
                            $_SESSION["idshopper"] = $idShopper;
                            $_SESSION["username"] = $username;                            
                            $_SESSION["firstname"] = $firstname;
                            // Redirect user to welcome page
                            header("location: index.php");
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
<?php
// Include config file
// Define variables and initialize with empty values
$username = $password = $confirm_password = $firstname = $lastname = $address= $city = $state = $zipcode = "";
$username_err = $password_err = $confirm_password_err = "";
 
// Processing form data when form is submitted
if($_SERVER["REQUEST_METHOD"] == "POST"){
 
    // Validate username
    if(empty(trim($_POST["username"]))){
        $username_err = "Please enter a username.";
    } else{
        // Prepare a select statement
        $sql = "SELECT idShopper FROM SP_Shopper WHERE username = ?";
        
        if($stmt = mysqli_prepare($link, $sql)){
            // Bind variables to the prepared statement as parameters
            mysqli_stmt_bind_param($stmt, "s", $param_username);
            
            // Set parameters
            $param_username = trim($_POST["username"]);
            
            // Attempt to execute the prepared statement
            if(mysqli_stmt_execute($stmt)){
                /* store result */
                mysqli_stmt_store_result($stmt);
                
                if(mysqli_stmt_num_rows($stmt) == 1){
                    $username_err = "This username is already taken.";
                } else{
                    $username = trim($_POST["username"]);
                }
            } else{
                echo "Oops! Something went wrong. Please try again later.";
            }
        }
         
        // Close statement
        mysqli_stmt_close($stmt);
    }
    
    // Validate password
    if(empty(trim($_POST["password"]))){
        $password_err = "Please enter a password.";     
    } elseif(strlen(trim($_POST["password"])) <= 6){
        $password_err = "Password must have atleast 6 characters.";
    } else{
        $password = trim($_POST["password"]);
    }
    
    // Validate confirm password
    if(empty(trim($_POST["confirm_password"]))){
        $confirm_password_err = "Please confirm password.";     
    } else{
        $confirm_password = trim($_POST["confirm_password"]);
        if(empty($password_err) && ($password != $confirm_password)){
            $confirm_password_err = "Password did not match.";
        }
    }
    $firstname = trim($_POST["firstname"]);
	$lastname = trim($_POST["lastname"]);
	$address = trim($_POST["address"]);
	$address2 = trim($_POST["address2"]);
	$city = trim($_POST["city"]);
	$state = trim($_POST["state"]);
	$zipcode = trim($_POST["zipcode"]);
    // Check input errors before inserting in database
    if(empty($username_err) && empty($password_err) && empty($confirm_password_err)){
        
        // Prepare an insert statement
        $sql = "INSERT INTO SP_Shopper (idShopper, firstname,lastname, address,address2,city,state, zipcode, username, password) VALUES (null,? ,? , ?, ?, ?, ?, ?, ?)";
         
        if($stmt = mysqli_prepare($link, $sql)){
            // Bind variables to the prepared statement as parameters
            mysqli_stmt_bind_param($stmt, "ssssssss", $para_firstname,$para_lastname, $para_address, $para_address2, $para_city,$para_state,$para_zipcode, $param_username, $param_password);
            
            // Set parameters
			
			$para_firstname = $firstname;
			$para_lastname = $lastname;
			$para_address = $address;
			$para_address2 = $address2;
			$para_city = $city;
			$para_state = $state;
			$para_zipcode = $zipcode;
            $param_username = $username;
            $param_password = password_hash($password, PASSWORD_DEFAULT); // Creates a password hash
            
            // Attempt to execute the prepared statement
            if(mysqli_stmt_execute($stmt)){
                // Redirect to login page
                header("location: login.php");
            } else{
                echo "Something went wrong. Please try again later.";
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
	<link rel="icon" href="images/favicon.png" type="image/x-icon">
</head>
<body>
	<?php 
		readfile("header.php");
	?>
	<main>
		<section id="acct">
			<h1>My Account</h1>
			<div class="flex-container">
				<form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post" id="login">
					<fieldset>
						<legend>Login</legend><br><br>
						<label>Username or E-mail Address *</label><br><br>
						<div class="form-group <?php echo (!empty($username_error)) ? 'has-error' : ''; ?>">
							<input type="text" name="username" value="<?php echo $username; ?>"required><br><br>
							<span class="help-block"><?php echo $username_error; ?></span>
						</div>
						<div class="form-group <?php echo (!empty($password_error)) ? 'has-error' : ''; ?>">
							<label for="password">Password *</label><br><br>
							<input type="password" name="password" required><br><br>
							<span class="help-block"><?php echo $password_error; ?></span>
						</div>
						<button type="submit" name="login">Log In</button>
					</fieldset>
				</form>
				<form method="post" id="register">
					<fieldset>
						<legend>Register</legend><br><br>
						 <div class="form-group <?php echo (!empty($username_err)) ? 'has-error' : ''; ?>">
							<label for="username">Email Address *</label>
							<input type="email" id="username" name="email" placeholder="E-mail*" title="Please enter your e-mail." maxlength="60" required><br><br>
						<span class="help-block"><?php echo $username_err; ?></span>
						<div class="form-group <?php echo (!empty($password_err)) ? 'has-error' : ''; ?>">
							<label for="password">Password *</label>
							<input type="password" name="password" class="form-control" value="<?php echo $password; ?>">
							<span class="help-block"><?php echo $password_err; ?></span>
           				</div>
           				<div class="form-group <?php echo (!empty($confirm_password_err)) ? 'has-error' : ''; ?>">
                			<label>Confirm Password</label>
               				<input type="password" name="confirm_password" class="form-control" value="<?php echo $confirm_password; ?>">
                			<span class="help-block"><?php echo $confirm_password_err; ?></span><br><br>
            			</div>
							<label for="fname">First Name *</label>
							<input type="text" id="firstname" name="fname" placeholder="First Name" maxlength="50" value="<?php echo $firstname; ?>"required><br><br>
							<label for="lname">Last Name *</label>
							<input type="text" id="lastname" name="lname" placeholder="Last Name" maxlength="50" value="<?php echo $lastname; ?>" required><br><br>
							<label for="address">Address 1 *</label>
							<input type="text" id="address" name="address" placeholder="Address" maxlength="50" value="<?php echo $address; ?>" required><br><br>
							<label for="address2">Address 2</label>
							<input type="text" id="address2" name="address" placeholder="Address 2" maxlength="50" required><br><br>
							<label for="city">City *</label>
							<input type="text" id="city" name="city" placeholder="City" maxlength="50" value="<?php echo $city; ?>" required><br><br>
							<label>State: </label>
							<!--<input type="city" name="city" class="form-control" value="">-->
							<select class="state" name="state" required>
							  <option value="">- Select one -</option>
							  <option value="AL">Alabama</option>
							  <option value="AK">Alaska</option>
							  <option value="AZ">Arizona</option>
							  <option value="AR">Arkansas</option>
							  <option value="CA">California</option>
							  <option value="CO">Colorado</option>
							  <option value="CT">Connecticut</option>
							  <option value="DE">Delaware</option>
							  <option value="DC">District Of Columbia</option>
							  <option value="FL">Florida</option>
							  <option value="GA">Georgia</option>
							  <option value="HI">Hawaii</option>
							  <option value="ID">Idaho</option>
							  <option value="IL">Illinois</option>
							  <option value="IN">Indiana</option>
							  <option value="IA">Iowa</option>
							  <option value="KS">Kansas</option>
							  <option value="KY">Kentucky</option>
							  <option value="LA">Louisiana</option>
							  <option value="ME">Maine</option>
							  <option value="MD">Maryland</option>
							  <option value="MA">Massachusetts</option>
							  <option value="MI">Michigan</option>
							  <option value="MN">Minnesota</option>
							  <option value="MS">Mississippi</option>
							  <option value="MO">Missouri</option>
							  <option value="MT">Montana</option>
							  <option value="NE">Nebraska</option>
							  <option value="NV">Nevada</option>
							  <option value="NH">New Hampshire</option>
							  <option value="NJ">New Jersey</option>
							  <option value="NM">New Mexico</option>
							  <option value="NY">New York</option>
							  <option value="NC">North Carolina</option>
							  <option value="ND">North Dakota</option>
							  <option value="OH">Ohio</option>
							  <option value="OK">Oklahoma</option>
							  <option value="OR">Oregon</option>
							  <option value="PA">Pennsylvania</option>
							  <option value="RI">Rhode Island</option>
							  <option value="SC">South Carolina</option>
							  <option value="SD">South Dakota</option>
							  <option value="TN">Tennessee</option>
							  <option value="TX">Texas</option>
							  <option value="UT">Utah</option>
							  <option value="VT">Vermont</option>
							  <option value="VA">Virginia</option>
							  <option value="WA">Washington</option>
							  <option value="WV">West Virginia</option>
							  <option value="WI">Wisconsin</option>
							  <option value="WY">Wyoming</option>
							</select>
							<br><br>
							<label for="zip">Zip *</label>
							<input type="text" id="zipcode" name="zip" placeholder="Zipcode" maxlength="50" value="<?php echo $zipcode; ?>" required><br><br>
							<label for="country" data-validation="number" data-validation-allowing="range[10000;99999]" data-validation-error-msg="invalid zipcode">Country<span class="required">*</span></label> 
							<input type="text" id="country" name="country" placeholder="Country" maxlength="50" required><br><br>
							<label for="phone">Phone *</label>
							<input type="text" id="phone" name="phone" placeholder="Phone Number" maxlength="50" required><br><br>
							<p>Your personal data will be used to support your experience throughout this website,
							to manage access to your account, and for other purposes as described in our <a href="privacy-policy.html">privacy policy</a>.</p><br>
							<button type="submit" name="register">Register</button>
					</fieldset>
				</form>		
			</div>
		</section>
	</main>
	<script>
	$.validate({
	    modules : 'security, location',
		onModulesLoaded : function() {
			 
			$('input[name="password"]').displayPasswordStrength(); 
			$('#country').suggestCountry( );

			 
		}// end onmodulesloaded
	});// end validate module
    </script>
	<?php 
		readfile("footer.html");
	?>
	<script src="https://kit.fontawesome.com/b217619af5.js" crossorigin="anonymous"></script>
	<script src="http://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script src="js/script.js"></script>
	<script type="text/javascript">
	</script>
</body>
</html>
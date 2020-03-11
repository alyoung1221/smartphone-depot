<!doctype html>
<?php
// Include config file
require_once "config.php";
 
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
	$city = trim($_POST["city"]);
	$state = trim($_POST["state"]);
	$zipcode = trim($_POST["zipcode"]);
    // Check input errors before inserting in database
    if(empty($username_err) && empty($password_err) && empty($confirm_password_err)){
        
        // Prepare an insert statement
        $sql = "INSERT INTO SP_Shopper (idShopper, firstname,lastname, address,city,state, zipcode, username, password) VALUES (null,? ,? , ?, ?, ?, ?, ?, ?)";
         
        if($stmt = mysqli_prepare($link, $sql)){
            // Bind variables to the prepared statement as parameters
            mysqli_stmt_bind_param($stmt, "ssssssss", $para_firstname,$para_lastname, $para_address,$para_city,$para_state,$para_zipcode, $param_username, $param_password);
            
            // Set parameters
			
			$para_firstname = $firstname;
			$para_lastname = $lastname;
			$para_address = $address;
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
 
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sign Up</title>
	
	<link href="http://code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css" rel="stylesheet" type="text/css">
<script src="http://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="http://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
	  
<script src="jQueryAssets/jquery-1.11.1.min.js"></script>
<script src="jQueryAssets/jquery.ui-1.10.4.dialog.min.js"></script>
<script src="jQueryAssets/jquery.ui-1.10.4.button.min.js"></script>
<link href="jQueryAssets/jquery.ui.core.min.css" rel="stylesheet" type="text/css">
<link href="jQueryAssets/jquery.ui.theme.min.css" rel="stylesheet" type="text/css">
<link href="jQueryAssets/jquery.ui.dialog.min.css" rel="stylesheet" type="text/css">
<link href="jQueryAssets/jquery.ui.resizable.min.css" rel="stylesheet" type="text/css">
<link href="jQueryAssets/jquery.ui.button.min.css" rel="stylesheet" type="text/css">
<script src="http://cdnjs.cloudflare.com/ajax/libs/jquery-form-validator/2.3.26/jquery.form-validator.min.js"></script>
	
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
	
	<link href="css/bootstrap-4.3.1.css" rel="stylesheet">
	<link href="css/mystyles.css" rel="stylesheet" type="text/css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.css">
    <style type="text/css">
        body{ font: 14px sans-serif; 
		margin: auto;}
        .wrapper{ width: 850px; padding: 20px; }
		form{margin: auto;}
    </style>
</head>
<body>
    <div class="wrapper">
        <h3>Sign Up</h3>
        <p>Please fill this form to create an account.</p>
        <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post">
            <div class="form-group <?php echo (!empty($username_err)) ? 'has-error' : ''; ?>">
                <label>Username</label>
                <input type="text" name="username" class="form-control" value="<?php echo $username; ?>" placeholder="Enter Email">
                <span class="help-block"><?php echo $username_err; ?></span>
            </div>    
            <div class="form-group <?php echo (!empty($password_err)) ? 'has-error' : ''; ?>">
                <label>Password</label>
                <input type="password" name="password" class="form-control" value="<?php echo $password; ?>">
                <span class="help-block"><?php echo $password_err; ?></span>
            </div>
            <div class="form-group <?php echo (!empty($confirm_password_err)) ? 'has-error' : ''; ?>">
                <label>Confirm Password</label>
                <input type="password" name="confirm_password" class="form-control" value="<?php echo $confirm_password; ?>">
                <span class="help-block"><?php echo $confirm_password_err; ?></span>
            </div>
			<div class="col-50">
			<label>First Name: </label>
			<input type="firstname" name="firstname" class="form-control" value="<?php echo $firstname; ?>">
			<label>Last Name: </label>
			<input type="lastname" name="lastname" class="form-control" value="<?php echo $lastname; ?>">
			<label>Address: </label>
			<input type="address" name="address" class="form-control" value="<?php echo $address; ?>">
			<label>city: </label>
			<input type="city" name="city" class="form-control" value="<?php echo $city; ?>">
			<label>state: 
			<!--<input type="city" name="city" class="form-control" value="">-->
			<div class="row">
			<div class = "col-50">
			<select class="col-50" name = "state">
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
			</select></label>
				</div>
			<div class="col-50">
			<label>Zipcode: </label>
				<input type="zipcode" name="zipcode" class="#" value="<?php echo $zipcode; ?>" data-validation="number" data-validation-allowing="range[10000;99999]" data-validation-error-msg="invalid zipcode ">
			</div>
			</div>
			</div>
            <div class="form-group">
                <input type="submit" class="btn btn-primary" value="Submit">
                <input type="reset" class="btn btn-default" value="Reset">
            </div>
            <p>Already have an account? <a href="login.php">Login here</a>.</p>
        </form>
    </div>   
	
	<script>
 $.validate({
    modules : 'security, location',
	 onModulesLoaded : function() {
		 
		$('input[name="password"]').displayPasswordStrength(); 
		   $('#country').suggestCountry( );

		 
	 }// end onmodulesloaded
  });// end validate module
  $('#comment').restrictLength($('#maxlength'));


    </script>
</body>
</html>
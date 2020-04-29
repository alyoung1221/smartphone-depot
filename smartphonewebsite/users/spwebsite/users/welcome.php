<!doctype html>
<?php
// Initialize the session
session_start();
 
// Check if the user is logged in, if not then redirect him to login page
if(!isset($_SESSION["loggedin"]) || $_SESSION["loggedin"] !== true){
    header("location: login.php");
    exit;
}
?>
 

<html lang="en">
  <head>
    <meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Login page</title>
	  
	  
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
	  
	  
	  
    <!-- Bootstrap -->
	<link href="css/bootstrap-4.3.1.css" rel="stylesheet">
	<link href="css/mystyles.css" rel="stylesheet" type="text/css">
	 <script type="text/javascript" src="js/myjavascript.js"></script>
	<script src="http://code.jquery.com/jquery-3.4.1.min.js"></script>
	  	<script>
  $(document).ready(function() {
	  
	  
	 $('#fetch').click(function() {
		 var useranwsers = document.getElementById("useranswer").value;
		 if(useranwsers == "tomorrow" || useranwsers == "Tomorrow" ){
		 $('#answer').load("questionanswer.txt")
        /*$.ajax({
			url: "joke.txt",
			type: "GET",
			dataType:"text",
			success: function(data){
				$('#answer').text(data);
			},
			error: function(xhr, status, error) {
				alert("Status:" + status);
				alert("Error:" + error);
			}
		}); */
  		 }// end if
	  else{
		  $('#answer').load("wronganswer.txt")
		 // $('#answer').load("joke.txt")
	  }// end else
	  // end ajax
		/* $.get("joke.txt",function(data){
			 
			 $('#answer').text(data)
		 },"text");*/ // jquery get method
		 //$('#answer').load("joke.txt")
		 
    }); // end click
	  
	 
  });  // end ready
</script>
	  
  </head>
  <body>
  	<!-- body code goes here -->
<div class="container">
<div class="row">
<div class="col-md-12 offset-0"> 
   <div id="banner">
   	  <img alt="banner" src="banner-outdoor-kitchen-1000px.jpg" class="img-responsive img-fluid">
	   <a name="top"></a>
   </div>
</div>
</div> 
<div class="row">
	<div id="containhornav"> 
		<ul id="hornavbar">
			<li><a href="events.html"> &nbsp;&nbsp;Login Page </a></li>
			<li><a href="chefspecial.html">Chef Special</a></li>
			<li><a href="reservation.html">&nbsp;Reservation </a></li>
			<li><a href="aboutus.html">&nbsp;&nbsp;&nbsp;About Us&nbsp;</a></li>
			<li><a href="homepage.html">Home Page&nbsp;</a></li>
		</ul>
  	</div>
</div>
<div class="row">

	
	<div id="navbar">
   <div id="nav">
	   <p><h2>Quick Menu</h2></p>
	  <ul>
		  
		  <li><a href="maindisk.html">Apertizers</a></li>
		  <li><a href="maindisk.html">Main Dishes</a></li>
		  <li><a href="#dessert">Dessert</a></li>
		  <li><a href="#soup">Soups</a></li>
		  <li><a href="orderedreview.html">Ordered Review</a></li>
	  </ul>
   </div>
	</div>

<div class="col-md-8">    
	<h1>Hi, <b><?php echo htmlspecialchars($_SESSION["firstname"]); ?></b></h1>
   <h3>What is always coming, but never arrives?</h3>
<form>
	<label>input the answer:</label><input type="text" id="useranswer">
  <label>
    <input type="button" name="fetch" id="fetch" value= "Check Answer" />
  </label>
</form>

<h2 id="answer"></h2>
	 
   <div class = "contentlogin">
	   <fieldset>
	  <form class="formRegister">
		  <p id="outputname"></p>
		  <label id="modify" name ="lastmodify"></label><br><br>
		  <label>User Name:</label>
		 <input type="text" id="usernames1" name="textname"> <br><br>
		  <label> Password: </label>
		<input type="password" id="password" name ="txtpassword"><br><br>
		  <input type="button" id ="submitfulname" name ="btnsubmit" value="Login"><br><br>
		  <p>dont have an account? </p>
		<input type="button" id = "openW" name="openW" value="Register">
		<input type="button" id = "closeW" name="closeW" value="close Window" disabled = "disabled" >
	</form>
	    </fieldset>
	   <h4>Want to get free meal? Let play the game </h4>
	   <fieldset>
	  <form>
		  <h3 id="printresult">0</h3>
		  <h3 id="printresult1">0</h3>
		  <h3 id="printresult2">0</h3>
		  <input type="button" id="playsubmit" value="Play">
		  <input type="button" id="rules" value="Check Rule"> <br><br>
		  <h3 id= "congratulation"></h3>
	   </form>
		   </fieldset>
	   <p>
        <a href="resetpassword.php" class="btn btn-warning">Reset Your Password</a>
        <a href="logout.php" class="btn btn-danger">Sign Out of Your Account</a>
    </p>
   </div>
	
</div>

	<div id="advs">
		<h2>advertiser</h2>
		<img src="1.jpg" alt="ads image" class="imgads">
		<p></p>
		<img src="boluclac.jpg" alt="ads image shaking beef" class="imgads">
		<p>Last Modify</p><br>
		<p id="lmodify"></p>

		<script type="text/javascript">
			document.getElementById("lmodify").innerHTML = document.lastModified.toLocaleString();
		</script>
	</div>

</div>

<div class="row">
<div class="col-md-12 offset-0"> 
   <div id="footer">
	   <p>project 1 IT 331</p>
   	  <p class ="footertext">“this website is developed as an educational project”. If any copyrighted materials are included in accordance to the multimedia fair use guidelines, a notice should be added and states that “certain materials are included under the fair use exemption of the U.S. Copyright Law and have been prepared according to the multimedia fair use guidelines and are restricted from further use”.</p>
   </div>
</div>
</div>  
</div>
	
	
	<!-- jQuery (necessary for Bootstrap's JavaScript plugins) --> 
	<script src="js/jquery-3.3.1.min.js"></script>

	<!-- Include all compiled plugins (below), or include individual files as needed -->
	<script src="js/popper.min.js"></script> 
	<script src="js/bootstrap-4.3.1.js"></script>
  </body>
</html>






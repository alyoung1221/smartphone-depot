<!DOCTYPE HTML>
<?php
// Initialize the session
session_start();
 
// Check if the user is logged in, if not then redirect him to login page
if(!isset($_SESSION["loggedin"]) || $_SESSION["loggedin"] !== true){
    header("location: my-account.php");
    exit;
}
?>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>About Us | Smartphone Depot</title>
	<link href="css/styles.css" rel="stylesheet" type="text/css">
	<link rel="icon" href="images/favicon.png" type="image/x-icon">
</head>
<body>
	<?php 
		require 'header.php';
	?>
	<main>
		<section id="about">
			<h1>About Us</h1><br><br><br>
			<p>Smartphone Depot is a leader in electronic resellers that sells pre-owned smartphones, tablets, iPads and iWatch. At Smartphone Depot, we take pride 
			in our products. Our phones are sourced from a reliable supplier and throughly tested to ensure the quality of our products. Our passion for our products 
			means our customers receive only the highest quality of products that are guaranteed to meet their needs. Most importantly, we believe shopping is a right, not a luxury.</p>
			<br><br><br>
			<div class="row">
				<div class="about">
					<img src="images/quality.png" alt="">
					<br><br>
					<h4>Quality</h4><br>
					<br>
					<p>To maintain the best quality, we go through rigorous processes to ensure every product is reliable. We believe that quality matters to our customers.</p>
				</div>
				<div class="about">
					<img src="images/people-powered.png" alt="">
					<br><br>
					<h4>People Powered</h4><br><br>
					<p>At Smartphone Depot, you buy directly from us. Cutting out the middleman means you buy the best quality products with the best prices and highest value.</p>
				</div>
				<div>
				<div class="about">
					<img src="images/paypal-protection.png" alt="">
					<br><br>
					<h4>Paypal Protection</h4><br><br>
					<p>Buyers and sellers transact safely and directly using PayPal. Extensive buyer and seller protections keep both parties safe.</p>
				</div>
			</div>
		</section>
	</main>
	<?php 
		readfile("footer.html");
	?>
	<script src="https://kit.fontawesome.com/b217619af5.js" crossorigin="anonymous"></script>
	<script src="http://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script src="js/script.js"></script>
	<script>
		$("nav a:nth-of-type(5)").addClass("active");
	</script>
</body>
</html>
<!DOCTYPE HTML>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>About Us | Smartphone Depot</title>
	<link href="https://necolas.github.io/normalize.css/8.0.1/normalize.css" rel="stylesheet" type="text/css">
	<link href="css/styles.css" rel="stylesheet" type="text/css">
	<link rel="icon" href="assets/favicon.png" type="image/x-icon">
</head>
<body>
  	<!--Header-->
		<?php 
			include("components/header.php");
		?>
	<!--Main-->
	<main>
		<section id="about" class="info">
			<h1 tabindex="0">About Us</h1>
			<p tabindex="0">Smartphone Depot is a leader in electronic resellers that sells pre-owned electronics. We sell pre-owned smartphones, tablets, iPads and iWatch. At Smartphone Depot, we take pride 
			in our products. Our phones are sourced from a reliable supplier and throughly tested to ensure the quality of our products. Our passion for our products 
			means our customers receive only the highest quality of products that are guaranteed to meet their needs. Most importantly, we believe shopping is a right, not a luxury.</p>
			<br><br><br>
			<div class="row">
				<div class="about">
					<img src="assets/images/quality.png" alt="">
					<br><br>
					<h4 tabindex="0">Quality</h4><br>
					<br>
					<p tabindex="0">To maintain the best quality, we go through rigorous processes to ensure every product is reliable. We believe that quality matters to our customers.</p>
				</div>
				<div class="about">
					<img src="assets/images/people-powered.png" alt="">
					<br><br>
					<h4 tabindex="0">People Powered</h4><br><br>
					<p tabindex="0">At Smartphone Depot, you buy directly from us. Cutting out the middleman means you buy the best quality products with the best prices and highest value.</p>
				</div>
				<div class="about">
					<img src="assets/images/paypal-protection.png" alt="">
					<br><br>
					<h4 tabindex="0">Paypal Protection</h4><br><br>
					<p tabindex="0">Buyers and sellers transact safely and directly using PayPal. Extensive buyer and seller protections keep both parties safe.</p>
				</div>
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
	<script>
		$(".menu-item:nth-of-type(4)").addClass("active");
	</script>
</body>
</html>
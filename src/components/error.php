<!DOCTYPE HTML>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>Page Not Found | Smartphone Depot</title>
	<link href="/css/styles.css" rel="stylesheet" type="text/css">
	<link rel="icon" href="/assets/favicon.png" type="image/x-icon">
	<style>
		#wsearch {
			width: 90vw;
		}
		main {
			text-align: center;
		}
	</style>
</head>
<body>
	<!-- Header -->
		<?php 
			$page = "";
			include("header.php");
		?>
	<!-- Main -->
	<main class="error">
		<h1>Page not found</h1>
		<br>
		<h2>Oops! That page can’t be found.</h2>
		<br>
		<p>It looks like nothing was found at this location. Try using the search box below:</p>
		<br><br>
		<input type="search" name="search" class="search" id="wsearch" placeholder="Type and hit enter...">
	</main>
	<!--Scripts-->
	<?php 
		readfile("../js/scripts.html");
	?>
	<script src="js/script.js"></script>	
	<!--Footer-->
	<?php 
		readfile("../components/footer.html");
	?>
</body>
</html>
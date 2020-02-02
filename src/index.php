<!DOCTYPE HTML>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>Smartphone Depot</title>
	<link href="css/styles.css" rel="stylesheet" type="text/css">
	<link rel="icon" href="" type="image/x-icon"/>
</head>
<body>
	<header>
		<nav>
			<ul>
				<li><a href="index.php"><img src="images/logo.png" width="150px"></a></li>
				<li><a href="inventory.php">Inventory</a></li>
				<li><a href="our-process.html">Our Process</a></li>
				<li><a href="account.html">Account</a></li>
				<li><a href="contact.html">Contact</a></li>
			</ul>
		</nav>	
	</header>
		<section id="featured">
	<?php
		$connection = mysqli_connect('helios.vse.gmu.edu','ayoung39','eesseg','ayoung39');
			
		if ($connection) {
			if (mysqli_query($connection, "SELECT * FROM PHONES")) {				
				$content = mysqli_query($connection, "SELECT PHONE_MODEL, PHONE_PRICE, PHONE_IMAGE FROM PHONES WHERE PHONE_FEATURED = 'F'");
				$phone = mysqli_fetch_assoc($content);
				
				while ($phone) {
					$phone = mysqli_fetch_assoc($content);					
				}
				mysqli_free_result($content);
			}
		}
		else {
			die('A database connection could not be established. The error was: '.mysqli_connect_error());
		}				
		mysqli_close($connection);
	?>
	</section>
</body>
</html>
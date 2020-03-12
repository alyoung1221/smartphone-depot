<!DOCTYPE HTML>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>{Page Title} | Smartphone Depot</title>
	<link href="css/styles.css" rel="stylesheet" type="text/css">
	<link rel="icon" href="images/favicon.png" type="image/x-icon">
</head>
<body>
  	<!--Header-->
		<?php 
			include("components/header.php");
		?>

	<!--Main-->
	<main>
		<section>
			<h1>{Page Title}</h1>
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
	</script>
</body>
</html>
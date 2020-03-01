<!DOCTYPE HTML>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>Our Process | Smartphone Depot</title>
	<link href="css/styles.css" rel="stylesheet" type="text/css">
	<link rel="icon" href="images/favicon.png" type="image/x-icon">
	<style>
		.flex-container div {
			width: fit-content;
		}
	</style>
</head>
<body>
	<?php 
		require_once("spwebsite/users/config.php");	
		readfile("header.php");
	?>
	<main>
		<h1>Our Process</h1>
		<br><br><br>
		<div class="flex-container">
		<?php 
			if (mysqli_query($link, "SELECT * FROM PHONE_GRADES")) {	
				$grades = mysqli_query($link, "SELECT * FROM PHONE_GRADES");
				
				while ($grade = mysqli_fetch_assoc($grades)) {
					$gradeDescs = explode("\n", $grade['P_GRADE_DESC']);
					echo "\t<div>\n";
					echo "\t\t\t\t<ul>\n";
					foreach ($gradeDescs as $value) {
						echo "\t\t\t\t\t<li>$value</li>\n";
					}
					echo "\t\t\t\t</ul>\n";
					echo "\t</div>\n";
				}
			}
		?>
		</div>
	</main>
	<?php 
		readfile("footer.html");
	?>
	<script src="https://kit.fontawesome.com/b217619af5.js" crossorigin="anonymous"></script>
	<script src="http://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script src="js/script.js"></script>
	<script>
	</script>
</body>
</html>
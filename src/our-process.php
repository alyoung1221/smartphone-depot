<!DOCTYPE HTML>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>Our Process | Smartphone Depot</title>
	<link href="https://necolas.github.io/normalize.css/8.0.1/normalize.css" rel="stylesheet" type="text/css">
	<link href="css/styles.css" rel="stylesheet" type="text/css">
	<link rel="icon" href="/assets/favicon.png" type="image/x-icon">
	<style>
		.flex-container div {
			width: fit-content;
		}
	</style>
</head>
<body>
	<?php 
		include("components/header.php");
	?>
	<main>
		<section>
			<h1 tabindex="0">Our Process</h1>
			<div class="flex-container">
			<?php 
				if (mysqli_query($link, "SELECT * FROM PHONE_GRADES")) {	
					$gradeInfo = mysqli_query($link, "SELECT * FROM PHONE_GRADES");
					
					while ($grade = mysqli_fetch_assoc($gradeInfo)) {
						$grades = explode("\n", $grade['P_GRADE']);
						$gradeDescs = explode("\n", $grade['P_GRADE_DESC']);
						echo "\t<div>\n";
						
						foreach ($grades as $value) {
							echo "\t\t\t\t<h3 tabindex='0'>Grade $value</h3>\n";
						}
						
						echo "\t\t\t\t<ul>\n";
						
						foreach ($gradeDescs as $value) {
							echo "\t\t\t\t\t<li tabindex='0'>$value</li>\n";
						}
						echo "\t\t\t\t</ul>\n";
						echo "\t</div>\n";
					}
				}
			?>
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
		$(".menu-item:nth-of-type(2)").addClass("active");
	</script>
</body>
</html>
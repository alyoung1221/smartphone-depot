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
		div.a {
  text-align: center;
}
div.b {
  text-align: center;
	font-weight: bold;
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
		<div>
		<table width="700" height="550" border="1">
  <tbody>
    <tr>
      <th width="260" height="130" scope="col"><img src="grade a icon.png" width="200" height="85" alt=""/></th>
      <th width="260" height="130" scope="col"><img src="grade b icon.png" width="200" height="85" alt=""/></th>
     <th width="260" height="130" scope="col"><img src="grade c icon.png" width="200" height="85" alt=""/></th>
    </tr>
    <tr>
      <td height="410"><p> <strong> No Crack</strong></p>
        <p> <strong> No Chip</strong></p>
        <p> <strong> No Watermark</strong></p>
        <p> <strong> No Scratches</strong></p>
        <p> <strong> No Major Dent</strong></p>
        <p> <strong> Scractches Less Than 50%</strong></p>
        <p> <strong> No Engraving or Removed Engraving</strong></p>
        <p> <strong> No Visible Scrathces on Screen</strong></p>
        <p> <strong> Very Minimal Signs of Wear</strong></p></td>
      <td><p><strong> No Crack</strong></p>
        <p> <strong> Edge Chip &lt; 2.0mm Acceptable</strong></p>
        <p> <strong> Visible Scratches Acceptable</strong></p>
        <p> <strong> Watermark No Bigger Than a Dime Acceptable</strong></p>
        <p> <strong> Minor Dent</strong></p>
        <p> <strong> Removed Engraving Acceptable</strong></p>
        <p> <strong> Will Show Some Signs of Wear</strong></p></td>
      <td><p><strong>No Crack</strong></p>
        <p> <strong> Edge Chip &lt; 5.0mm Acceptable</strong></p>
        <p> <strong> Visible Scratches</strong></p>
        <p> <strong> Possible Dent</strong></p>
        <p> <strong> Will Show Heavy Signs of Wear</strong></p></td>
    </tr>
  </tbody>
</table>



	  </div>
		<img src="RMA_sheet.png" alt="RMA">
		<div class="a">
			At smartphone-Depot, we strive our best to provide the best quality of products.
However, we understand mistakes happens and this is why we provide 30 day warranty for functionality. (Doesn’t include cosmetics). It is very important
 and core of our business to ensure that our customers are always satisfied with the goods they procure at Smartphone-Depot.
		</div>
		<div class="b">
			Smartphone-Depot reserve the rights to accept, deny or exchange any RMA
		</div>
		<div class="a">
			DOWNLOAD RMA SHEET
		</div>

		<div class="a">
			RMA Sheet goes here
		</div>
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

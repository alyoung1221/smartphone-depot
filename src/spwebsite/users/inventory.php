<!DOCTYPE HTML>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" query="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta http-equiv="X-UA-Compatible" query="IE=edge">
	<title>Inventory | Smartphone Depot</title>
	<link href="css/styles.css" rel="stylesheet" type="text/css">
	<link rel="icon" href="images/favicon.png" type="image/x-icon">
</head>
<body>
	<?php 
		readfile("header.html");
	?>
	<main>
		<form id="searchbar">
			<input type="search" id="search" placeholder="Search. . ." required>
		</form>
		<table>
			<thead>
				<tr>
					<th>Model<i class="fas fa-sort"></i></th>
					<th>Price<i class="fas fa-sort"></i></th>
					<!--<th>Colors<i class="fas fa-sort"></i></th>-->
					<th>Status<i class="fas fa-sort"></i></th>
					<th>Quantity<i class="fas fa-sort"></i></th>
				</tr>
			</thead>
			<tbody>
	<?php
		$connection = mysqli_connect('helios.vse.gmu.edu','ayoung39','eesseg','ayoung39');
			
		if ($connection) {
			if (mysqli_query($connection, "SELECT * FROM PHONES")) {				
				$query = "SELECT PHONE_MODEL, ROUND(PHONE_PRICE, 0) AS PHONE_PRICE, PHONE_STATUS, PHONE_QUANTITY FROM PHONES";
				$content = mysqli_query($connection, $query);
				$phone = mysqli_fetch_assoc($content);
				$products = ""; 
				
				while ($phone) {
					$products .= "\t\t\t\t<tr>\n";
					$products .= "\t\t\t\t\t<td><a href='https://smartphone-depot.com/product/iphone-6-2/'>$phone[PHONE_MODEL]</a></td>\n";
					$products .= "\t\t\t\t\t<td>$$phone[PHONE_PRICE]</td>\n";
					$products .= "\t\t\t\t\t<td>$phone[PHONE_STATUS]</td>\n";
					$products .= "\t\t\t\t\t<td>$phone[PHONE_QUANTITY]</td>\n";
					$products .= "\t\t\t\t</tr>\n";
					$phone = mysqli_fetch_assoc($content);				
				}
				mysqli_free_result($content);
			}
		}
		else {
			die('A database connection could not be established. The error was: '.mysqli_connect_error());
		}				
		echo $products;
		mysqli_close($connection);
	?>
			</tbody>
		</table>
	</main>
	<?php 
		readfile("footer.html");
	?>
	<script src="https://kit.fontawesome.com/b217619af5.js" crossorigin="anonymous"></script>
	<script src="http://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script src="http://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
	<script src="js/script.js"></script>
	<script>
		$("nav a:nth-of-type(3)").addClass("active");
		
		var timeout = null; 

		$("#search").keyup(function() {
			clearTimeout(timeout);
			timeout = setTimeout(search, 500);
			$("#clear").css("color", "#808080");
		});
		
		$("#search").on("input", function() {
			if ($("#search").val() === "") {
				displayTable();
			}
		});
	
		var sortButtons = document.getElementsByClassName("fa-sort");
		
		for (var i = 0; i < sortButtons.length; i++) {
			handleClick(i); 
			
			function handleClick(index) {
				sortButtons[index].addEventListener("click", function() {sort(index);}, false);
			}
		}
	</script>
</body>
</html>
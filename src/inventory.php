<!DOCTYPE HTML>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" query="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta http-equiv="X-UA-Compatible" query="IE=edge">
	<title>Inventory | Smartphone Depot</title>
	<link href="css/styles.css" rel="stylesheet" type="text/css">
	<link rel="icon" href="" type="image/x-icon"/>
</head>
<body>
	<header>
		<nav>
			<ul>
				<li><a href="index.php"><img src="images/logo.png" width="200px"></a></li>
				<li><a href="inventory.php">Inventory</a></li>
				<li><a href="#our-process">Our Process</a></li>
				<li><a href="account.html">Account</a></li>
				<li><a href="#contact">Contact</a></li>
			</ul>
		</nav>	
	</header>
	<main>
		<form id="searchbar">
			<input type="text" id="search" placeholder="Search..." title="Search phones" required>
			<input type="reset" id="clear" value="&times;">
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
	<?php
		$connection = mysqli_connect('helios.vse.gmu.edu','ayoung39','eesseg','ayoung39');
			
		if ($connection) {
			if (mysqli_query($connection, "SELECT * FROM PHONES")) {				
				$query = "SELECT PHONE_MODEL, PHONE_PRICE, PHONE_STATUS, PHONE_QUANTITY FROM PHONES";
				
				if (isset($_GET['category'])) {
					if ($_GET['category'] == 'model') {
						$query .= " ORDER BY PHONE_MODEL";
					}
					elseif ($_GET['category'] == 'price') {
						$query .= " ORDER BY PHONE_PRICE";
					}
					elseif ($_GET['category'] == 'status') {
						$query .= " ORDER BY PHONE_STATUS";
					}
					elseif($_GET['category'] == 'quantity') {
						$query .= " ORDER BY PHONE_QUANTITY";
					}
				}
				$content = mysqli_query($connection, $query);
				$phone = mysqli_fetch_assoc($content);
				$products = "\t\t<tbody>\n";
				
				while ($phone) {
					$products .= "\t\t\t\t<tr>\n";
					$products .= "\t\t\t\t\t<td>$phone[PHONE_MODEL]</td>\n";
					$products .= "\t\t\t\t\t<td>$$phone[PHONE_PRICE]</td>\n";
					$products .= "\t\t\t\t\t<td>$phone[PHONE_STATUS]</td>\n";
					$products .= "\t\t\t\t\t<td>$phone[PHONE_QUANTITY]</td>\n";
					$products .= "\t\t\t\t</tr>\n";
					$phone = mysqli_fetch_assoc($content);				
				}
				mysqli_free_result($content);
				$products .= "\t\t\t</tbody>\n";
				$products .= "\t\t</table>\n";
			}
		}
		else {
			die('A database connection could not be established. The error was: '.mysqli_connect_error());
		}				
		echo $products;
		mysqli_close($connection);
	?>
	</main>
	<footer>
		&copy;2019 Smartphone Depot.
	</footer>
	<script src="https://kit.fontawesome.com/b217619af5.js" crossorigin="anonymous"></script>
	<script src="http://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script src="http://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
	<script src="js/script.js"></script>
	<script type="text/javascript">
		$("#search").keyup(search);

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
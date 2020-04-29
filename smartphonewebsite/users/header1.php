<?php 			
	require_once("spwebsite/users/config.php");		
?>
<header>
	<a href="../users/index.php"><img src="../users/images/logo.png"></a>
	<button id="open" class="fas fa-bars mobile"></button>
	<div class="menu-container">
		<div class="menu">					
			<button id="close" class="mobile">&times;</button>
			<nav class="menu-content">
				<div class="menu-links">
					<a href="../" class="mobile">Home</a>
					<a href="../users/inventory1.php">Inventory</a>
					<a href="../users/our-process1.php">Our Process</a>
					<a href="../users/wholesale1.php">Wholesale</a>
					<a href="../users/about-us1.php">About Us</a>
					<a href="../users/contact-us1.php">Contact Us</a>
					<a href="../users/products.php">Products</a>
					<input type="search" id="search" placeholder="Search..." required title="Search website">										
				</div>	
				<div id="iconbar">
					<a href="../users/my-account.php" class="material-icons acct" aria-label="My Account">person</a>
					<a href="../users/cart.php" id="shopping-bag" aria-label="Cart"><span></span></a>
				</div>
			</nav>
		</div>	
	</div>		
</header>

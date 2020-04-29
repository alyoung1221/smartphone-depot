<?php 			
	require_once("spwebsite/users/config.php");	
	
?>

<header>

	<a href="../users/cart.php"><img src="../users/images/logo.png"></a>
	<button id="open" class="fas fa-bars mobile"></button>
	<div class="menu-container">
		<div class="menu">					
			<button id="close" class="mobile">&times;</button>
			<nav class="menu-content">
				<div class="menu-links">
					<a href="../" class="mobile">Home</a>
					<a href="../users/inventory.php">Inventory</a>
					<a href="../users/our-process.php">Our Process</a>
					<a href="../users/wholesale.php">Wholesale</a>
					<a href="../users/about-us.php">About Us</a>
					<a href="../users/contact-us.php">Contact Us</a>
					<a href="../users/products.php">Products</a>
					<input type="search" id="search" placeholder="Search..." required title="Search website">										
				</div>	
				 
				<div id="iconbar">
				 <?php
                 // count products in cart
                 $cart_count=count($_SESSION['cart']);
                  ?>
					<!-- <b style='color:red;'><?php echo "Hello, ", htmlspecialchars($_SESSION["firstname"]); ?></b> !-->
					<a href="../users/my-account.php" class="#" aria-label="My Account"><b style='color:red;'><?php echo "Hello, ", htmlspecialchars($_SESSION["firstname"]); ?></b></a>
					<a href="../users/cart.php" id="shopping-bag" aria-label="Cart"><span><?php echo "", $cart_count; ?></span></a>
				</div>
			</nav>
		</div>	
	</div>	

</header>

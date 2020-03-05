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
					<a href="../users/inventory">Inventory</a>
					<a href="../users/our-process">Our Process</a>
					<a href="../users/wholesale">Wholesale</a>
					<a href="../users/about-us">About Us</a>
					<a href="../users/contact-us">Contact Us</a>
					<input type="search" id="search" placeholder="Search..." required title="Search website">										
				</div>	
				 
				<div id="iconbar">
				
					<!-- <b style='color:red;'><?php echo "Hello, ", htmlspecialchars($_SESSION["firstname"]); ?></b> !-->
					<a href="../users/my-account.php" class="#" aria-label="My Account"><b style='color:red;'><?php echo "Hello, ", htmlspecialchars($_SESSION["firstname"]); ?></b></a>
					<a href="/cart" id="shopping-bag" aria-label="Cart"><span></span></a>
				</div>
			</nav>
		</div>	
	</div>	

</header>

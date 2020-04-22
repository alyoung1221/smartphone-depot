<?php
$_SESSION['cart']=isset($_SESSION['cart']) ? $_SESSION['cart'] : array();
?>
<header>
	<link href="css/styles.css" rel="stylesheet" type="text/css">
	<link rel="icon" href="images/favicon.png" type="image/x-icon">
	<a href="../products.php"><img src="../shoppingbasket/images/logo.png"></a>
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
					<a href="../users/my-account.php" class="#" aria-label="My Account"><b style='color:blue;'></b></a>
					<a href="cart.php" id="shopping-bag" aria-label="Cart">
                        <?php
                        // count products in cart
                        $cart_count=count($_SESSION['cart']);
                        ?>
                        <span class="#" id="comparison-count"><?php echo $cart_count; ?></span>
                    </a>
					
				</div>
			</nav>
		</div>	
	</div>	

</header>
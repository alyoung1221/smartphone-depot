<?php 			
	require_once("spwebsite/users/config.php");		
?>
<header>
	<a href="/"><img src="/images/logo.png"></a>
	<button id="open" class="fas fa-bars mobile"></button>
	<div class="menu-container">
		<div class="menu">					
			<button id="close" class="mobile">&times;</button>
			<nav class="menu-content">
				<div class="menu-links">
					<a href="/" class="mobile">Home</a>
					<a href="/inventory" aria-has-popup="true">
						<ul>
							<li><a href="inventory.html">Inventory</a></li>
						</ul>
					</a>
					<a href="/our-process">Our Process</a>
					<a href="/wholesale">Wholesale</a>
					<a href="/about-us">About Us</a>
					<a href="/contact-us">Contact Us</a>
					<input type="search" id="search" placeholder="Search..." required title="Search website">										
				</div>	
				<div id="iconbar">
					<a href="/my-account" class="material-icons acct" aria-label="My Account">person</a>
					<a href="/cart" id="shopping-bag" aria-label="Cart"><span></span></a>
				</div>
			</nav>
		</div>	
	</div>		
</header>

<?php 			
	if (isset($page)) {
		require_once("../config.php");	
	}
	else {
		require_once("config.php");		
	}
?>
<header>
	<a href="/" id="logo"><img src="/assets/images/logo.png" alt="Smartphone Depot"></a>
	<button id="open" class="fas fa-bars mobile" aria-label="Open navigation menu"></button>
	<div class="menu-container">
		<div class="menu">					
			<button id="close" class="mobile"><span aria-hidden="true">&times;</span></button>
			<nav class="menu-content">
				<ul role="none" class="main">
					<li class="menu-item flex-container">
						<a href="/products">Products</a>
						<button type="button" name="toggle" role="presentation" class="down material-icons"><span class="desktop">keyboard_arrow_down</span></button>
						<ul class="dropdown">
							<li class="submenu-item flex-container">
								<a href="/products">iPhone</a>
								<button type="button" name="toggle" role="presentation" class="dropBtn"></button>
								<ul class="subdropdown">
									<?php 
										if (mysqli_query($link, "SELECT DISTINCT P_MODEL FROM PHONES, PHONE_CAT, CATEGORIES WHERE CAT_NAME = 'iPhone'")) {
						
											$products = mysqli_query($link, "SELECT DISTINCT P_MODEL FROM PHONES, PHONE_CAT, CATEGORIES WHERE CAT_NAME = 'iPhone'");

											while ($row = mysqli_fetch_assoc($products)) {								
												$pModel = $row['P_MODEL'];
												echo "<li class='subdropdown-item'>\n";
												echo "<a href='/product/$pModel'>$pModel</a>\n";
												echo "</li>\n"; 
											}
										}
									?>
								</ul>
							</li>
							<li class="submenu-item">
								<a href="/products">iPad</a>
							</li>
							<li class="submenu-item">
								<a href="/products">Samsung</a>
							</li>
							<li class="submenu-item">
								<a href="/products">Apple Watch</a>
							</li>
							<li class="submenu-item">
								<a href="/inventory">Current Inventory</a>
							</li>
						</ul>
					</li>
					<li class="menu-item">
						<a href="/our-process">Our Process</a>
					</li>
					<li class="menu-item">
						<a href="/wholesale">Wholesale</a>
					</li>
					<li class="menu-item">
						<a href="/about-us">About Us</a>
					</li>
					<li class="menu-item">
						<a href="/contact-us">Contact Us</a>
					</li>
				</ul>	
			</nav>
			<div class="wrapper flex-container">
				<div id="search-container">
					<input type="search" id="search" placeholder="Search..." required title="Search website">
				</div>
				<div id="iconbar" class="flex-container">
					<div class="hover">
						<a href="/cart"><span id="shopping-bag">0</span></a>
						<!--<a href="/cart" class="fa-stack" aria-label="Shopping Cart">
						  <p class="fas fa-shopping-bag fa-stack-2x" style="-ms-transform: scale(.82, 1); transform: scale(.82, 1); color: #00AAEF;"></p>
						  <p class="fa-stack-1x fa-inverse" style="vertical-align: middle; position: relative; top: 6px;">0</p>
						</a>-->
						<div class="hidden shopping-cart" tabindex="0">
							<div tabindex="0">
								No products in the cart
							</div>
						</div>
					</div>
					<div class="hover">
						<button class="material-icons acct" aria-hidden="true">person</button>
						<div class="hidden profile" tabindex="0">
							<div tabindex="0">
								<a href="/my-account" class="last">My Account</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>	
	</div>		
</header>

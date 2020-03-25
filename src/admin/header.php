<?php 			
	require_once("spwebsite/users/config.php");		
?>
<header>
	<a href="index"><img src="/images/logo.png"></a>
	<button id="open" class="fas fa-bars mobile"></button>
	<div class="menu-container">
		<div class="menu">					
			<button id="close" class="mobile">&times;</button>
			<nav class="menu-content">
				<div class="menu-links">
					<a href="index" class="mobile">Home</a>
					<a href="inventory">Inventory</a>
					<input type="search" id="search" placeholder="Search..." required title="Search website">										
				</div>	
				<div id="iconbar">
					<div class="hover" tabindex="0">
						<button class="material-icons acct" aria-label="My Account">person</button>
						<div class="hidden profile" tabindex="0">
							<a href="/my-account" tabindex="0">My Account</a>
						</div>
					</div>
				</div>
			</nav>
		</div>	
	</div>		
</header>
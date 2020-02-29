<div id = "header">	
	<h2> POS Admin Dashboard</h2>
	<?php  if (isset($_SESSION['user'])) : ?>
					<p><?php echo" Hi. ", $_SESSION['user']['adminUsername']; ?>

					
						<i  style="color: #888;">(<?php echo ucfirst($_SESSION['user']['adminLevel']); ?>) 
						</i> Welcome to POS Admin Management </p>
	
	<?php endif ?>
	<h3><a href="index.php?logout='1'" style="color: White;" >Logout</a></h3>
</div>
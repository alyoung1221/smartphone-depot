<!DOCTYPE HTML>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" query="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta http-equiv="X-UA-Compatible" query="IE=edge">
	<title>Contact Us | Smartphone Depot</title>
	<link href="css/styles.css" rel="stylesheet" type="text/css">
	<link rel="icon" href="images/favicon.png" type="image/x-icon">
</head>
<body>
	<?php 
		readfile("header.html");
	?>
	<main>
		<div class="flex-container">
			<form method="post" id="contactForm">
				<label for="name" class="hidden">Name</label>
				<input type="text" id="name" name="name" placeholder="Name*" title="Please enter your last name." maxlength="60" required><br>
				<label for="email" class="hidden">E-mail</label>
				<input type="email" id="email" name="email" placeholder="E-mail*" title="Please enter your e-mail." maxlength="60" required><br>
				<label for="subject" class="hidden">Subject</label>
				<input type="text" name="subject" id="subject" placeholder="Subject*" title="Please enter the subject." maxlength="60" required><br>
				<label for="message" class="hidden">Message</label>
				<textarea id="msg" name="msg" rows="9" placeholder="Message*" title="Please write a message." maxlength="600" required></textarea><br>
				<button type="submit">Send</button>
				<p id="success"></p>
			</form>
			<section id="contact">
				<div>
					<span class="far fa-envelope"></span>
					<div class="details">
						<a href="mailto:sales@smartphone-depot.com">sales@smartphone-depot.com</a><br><br>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="mailto:info@smartphone-depot.com">info@smartphone-depot.com</a>
					</div>
				</div>
				<div>
					<span class="fas fa-mobile-alt"></span>
					<div class="details">
						&nbsp;&nbsp;&nbsp;<a href="tel:15715294002">+1 (571) 529-4022</a><br><br>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="tel:1571344150">+1 (571) 344-1500</a>
					</div>
				</div>
				<div>
					<span class="fas fa-map-marker-alt"></span>
					<div class="details">
						&nbsp;&nbsp;&nbsp;<address>2735 Hartland Rd. #303<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Falls Church, VA 22043</address>
					</div>
				</div>
				<div>
					<iframe src="https://www.google.com/maps/embed?pb=!1m14!1m8!1m3!1d6211.939317893626!2d-77.222238!3d38.878936!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x89b64b693b4878e1%3A0x64581df890c84d02!2s2735%20Hartland%20Rd%20%23303%2C%20Falls%20Church%2C%20VA%2022043%2C%20USA!5e0!3m2!1sen!2sbd!4v1581109070945!5m2!1sen!2sbd" frameborder="0" style="border:0;" allowfullscreen=""></iframe>
				</div>
			</section>
		</div>
	</main>
	<?php 
		readfile("footer.html");
	?>
	<script src="https://kit.fontawesome.com/b217619af5.js" crossorigin="anonymous"></script>
	<script src="http://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script src="http://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
	<script src="js/script.js"></script>
	<script type="text/javascript">
	</script>
</body>
</html>
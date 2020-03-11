<?php 
	if (!empty($_GET['id']) && !empty($_GET['model'])) {
		$id = $_GET['id'];
		$model = $_GET['model'];
	}
	else {
		http_response_code(404);
		include("components/error.php");
		die();
	}
?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?php echo $model;?> | Smartphone Depot</title>
	<link href="https://necolas.github.io/normalize.css/8.0.1/normalize.css" rel="stylesheet" type="text/css">
	<link href="/css/styles.css" rel="stylesheet" type="text/css">
	<link type="text/css" rel="stylesheet" href="css/lightslider.css"> 
	<link rel="icon" href="/assets/favicon.png" type="image/x-icon">
	<!--[if lt IE 9]>
		  <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
		  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
	<![endif]-->
	<style>
		@media screen and (min-width: 800px) {
			main {
				width: 90%;
			}
			.product-info {
				text-align: right;
				margin-left: 200px;
			}
			#product #zoom {
				width: 220px;
				height: 380px;
			}
		}
		@media screen and (min-width: 800px) and (max-width: 1000px) {
			.product-info {
				margin-left: 100px;
			}
		}
		@media screen and (max-width: 800px) {
			form {
				display: flex;
				flex-direction: column;
				align-items: center;
				justify-content: center;
			}
			.flex-container {
				display: block;
			}
			.product-info {
				margin-top: 70px;
				margin-left: 0;
			}
			.zoom {
				margin: auto;
			}
		}
	</style>
  </head>
  <body>
  	<!--Header-->
		<?php 
			include("components/header.php");
		?>
		
	<!--Main-->
		<main>
			<section>
				<h1 tabindex="0"><?php echo $model;?></h1>	
				<span class="mobile"><br></span>
				<form name="product" method="post" action="<?php echo $_SERVER['PHP_SELF']?>" class="product" data-id="<?php echo $id;?>">
				</form>
			</section>
		</main>
	<!--Footer-->
		<?php 
			readfile("components/footer.html");
		?>
		
	<!--Scripts-->
		<?php 
			readfile("js/scripts.html");
		?>
		<script>
			$("nav li:nth-child(2) a").addClass("active");
			
			var url = "components/modal.php?id=" + $(".product").eq(0).attr("data-id") + "&component=product";
			$(".product").load(url);
		</script>
  </body>
</html>
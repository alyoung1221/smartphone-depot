<?php 
	if (!empty($_GET['model']) && !is_numeric($_GET['model'])) {
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
	<link href="/css/styles.css" rel="stylesheet" type="text/css"> 
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
			#product .zoom {
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
			[name="product"] .flex-container {
				display: block;
			}
			.product-info {
				margin-top: 50px;
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
				<form name="product" method="post" action="<?php echo $_SERVER['PHP_SELF']?>" data-model="<?php echo str_replace(" ", "%20", $model);?>">
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
			$(".menu-item:first-of-type").addClass("active");
			$(".submenu-item:first-of-type > a").addClass("active");
			$(".subdropdown-item").each(function(index) {
				if ($(this).text().trim() == $("h1").html()) {
					$(this).find("a").addClass("active");
				}
			});
			//$(".subdropdown-item:nth-of-type(3) > a").addClass("active");
			var url = "/components/modal?model=" + $("[name='product']").eq(0).attr("data-model") + "&component=product";
			$("[name='product']").eq(0).load(url);
		</script>
  </body>
</html>
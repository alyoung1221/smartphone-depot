<!DOCTYPE HTML>
<html lang="en">
<head>

	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
	<title>Products | Smartphone Depot</title>
	<link rel="icon" href="assets/favicon.png" type="image/x-icon">
    <link href="css/styles.css" rel="stylesheet" type="text/css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    

</head>
<body>
	<!-- Header -->
	<?php
		include("components/header.php");
	?>
	<!-- Main -->
	<main>
		<section>
			<h1>Products</h1>
            <div class="container">
            <div id="myCarousel" class="carousel slide" data-ride="carousel">
                <!-- Indicators -->
                <ol class="carousel-indicators">
                    <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
                    <li data-target="#myCarousel" data-slide-to="1"></li>
                    <li data-target="#myCarousel" data-slide-to="2"></li>
                </ol>

                <!-- Wrapper for slides -->
                <div class="carousel-inner">
                    <div class="item active">
                        <img src="images/iPhone 6/gold/front.jpg" alt= "iphone 6" style="width:300px;">
                    </div>

                    <div class="item">
                        <img src="images/iPhone 7/matte black/front.jpg" alt= "iphone 7" style="width:150px;">
                    </div>
                    
                    <div class="item">
                        <img src="images/iPhone X/white/front.jpg" alt= "iphone X" style="width:300px;"> 
                    </div>
                </div>

                <!-- Left and right controls -->
                <a class="left carousel-control" href="#myCarousel" data-slide="prev">
                <span class="glyphicon glyphicon-chevron-left"></span>
                <span class="sr-only">Previous</span>
                </a>
                <a class="right carousel-control" href="#myCarousel" data-slide="next">
                <span class="glyphicon glyphicon-chevron-right"></span>
                <span class="sr-only">Next</span>
                </a>
            </div>
            </div>
			<div class="gallery">
				<?php
					if (mysqli_query($link, "SELECT * FROM PHONES")) {
							
						$products = mysqli_query($link, "SELECT * FROM PHONES ORDER BY P_MODEL DESC");

						while ($phone = mysqli_fetch_assoc($products)) {								
							$id = $phone['P_ID'];
							$model = $phone['P_MODEL'];
							$status= $phone['P_STATUS'];
							$front = "assets/images/$phone[P_FRONT_IMG]";
							$back = "assets/images/$phone[P_BACK_IMG]";
							$prices = mysqli_query($link, "SELECT MIN(P_PRICE) AS MIN_PRICE, MAX(P_PRICE) AS MAX_PRICE FROM PHONE_OPTIONS, PHONES WHERE PHONE_OPTIONS.P_ID = $id");
							$url = "product/$model";
							
							while ($price = mysqli_fetch_assoc($prices)) {
								$minPrice = $price['MIN_PRICE'];
								$maxPrice = $price['MAX_PRICE'];
								$priceRange = ($maxPrice > $minPrice) ? "$$minPrice &ndash; $$maxPrice" : "$$minPrice";
							}
				?>
	<div class="product" data-id="<?php echo $id;?>" data-model="<?php echo str_replace(" ", "%20", $model);?>">
		<a href="<?php echo $url;?>">
			<div class="fade">
				<img src="<?php echo $back?>" class="bottom">
				<img src="<?php echo $front?>" class="top">
			</div>
		</a>
		<div class="caption">
			<h3><a href="<?php echo $url;?>"><?php echo $model?></a></h3>
			<p tabindex="0"><?php echo $priceRange;?></p>
			<div class="view">
				<button tabindex="0">Quick View</button>
			</div>
		</div>
	</div>
				<?php 
						}
					}
				?>
				<div id="dialog" role="dialog" aria-labelledby="product" aria-modal="true" tabindex="-1" hidden>
					<div id="dialog-container">
						<span class="hidden" id="product"></span>
						<button id="close-dialog" title="Close product" aria-label="Close product">&times;</button>
						<div id="dialog-body">
							<form method="post" name="product" class="product-modal">
							</form>
						</div>			
					</div>
				</div>
			</div>
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
	<script src="js/script.js"></script>
	<script>
		$(".menu-item:first-of-type").addClass("active");
					
		var dialog = document.getElementById("dialog");
		var focusedElementBeforeDialogOpened;
				
		$(".view button").each(function(index) {
			$(this).click(function() {
				$("#product").html("Purchase " + $(".product").eq(index).attr("data-model")); 
				var url = "components/modal.php?model=" + $(".product").eq(index).attr("data-model") + "&component=modal";
				$("[name='product']").eq(0).load(url, openDialog);
				focusedElementBeforeDialogOpened = document.getElementsByClassName("view")[index].getElementsByTagName("button")[0];
			});
		});
		$("#close-dialog").click(closeDialog);
		
		dialog.addEventListener("submit", submit, true);
		
		$(window).click(function(e) {		
			if ($(e.target).attr("id") === "dialog") {
				closeDialog();
			}
		});

		var keyHandle;
		var tabHandle;
		var disabledHandle;
		var hiddenHandle;

		function openDialog() {
			$("body").css("overflow-y", "hidden");

			ally.when.visibleArea({
				context: dialog,
				callback: function(context) {
					var element = ally.query.firstTabbable({
						context: context, 
						defaultToContext: true,
					});
					element.focus();
				},
			});

			disabledHandle = ally.maintain.disabled({
				filter: dialog,
			});

			hiddenHandle = ally.maintain.hidden({
				filter: dialog,
			});

			tabHandle = ally.maintain.tabFocus({
				context: dialog,
			});

			keyHandle = ally.when.key({
				escape: closeDialogByKey,
			});
			dialog.hidden = false;
		}

		function closeDialogByKey() {
			setTimeout(closeDialog);
		}

		function closeDialog() {
			// undo listening to keyboard
			keyHandle.disengage();
			// undo trapping Tab key focus
			tabHandle.disengage();
			// undo hiding elements outside of the dialog
			hiddenHandle.disengage();
			// undo disabling elements outside of the dialog
			disabledHandle.disengage();
			// return focus to where it was before we opened the dialog
			focusedElementBeforeDialogOpened.focus();
			// hide or remove the dialog
			dialog.hidden = true;
			$("body").css("overflow-y", "visible");
		}

		function submit(event) {
			event.preventDefault();
			closeDialog();
		}
		$.validate({
			modules: 'toggleDisabled'
		});// end validate module
	</script>
</body>
</html>

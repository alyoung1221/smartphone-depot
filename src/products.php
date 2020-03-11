<!DOCTYPE HTML>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>Products | Smartphone Depot</title>
	<link href="https://necolas.github.io/normalize.css/8.0.1/normalize.css" rel="stylesheet" type="text/css">
	<link type="text/css" rel="stylesheet" href="css/lightslider.css"> 
	<link href="css/styles.css" rel="stylesheet" type="text/css">
	<link rel="icon" href="assets/favicon.png" type="image/x-icon">
</head>
<body>
	<!-- Header -->
	<?php
		include("components/header.php");
	?>
	<!-- Main -->
	<main>
		<section>
			<h1 tabindex="0">Products</h1>
			<div class="gallery">
				<?php
					if (mysqli_query($link, "SELECT * FROM PHONES")) {
							
						$products = mysqli_query($link, "SELECT * FROM PHONES ORDER BY P_MODEL DESC");

						while ($phone = mysqli_fetch_assoc($products)) {								
							$id = $phone['P_ID'];
							$model = $phone['P_MODEL'];
							$status= $phone['P_STATUS'];
							$img = "assets/images/$phone[P_IMG]";
							$prices = mysqli_query($link, "SELECT MIN(P_PRICE) AS MIN_PRICE, MAX(P_PRICE) AS MAX_PRICE FROM PHONE_OPTIONS, PHONES WHERE PHONE_OPTIONS.P_ID = $id");
													
							while ($price = mysqli_fetch_assoc($prices)) {
								$minPrice = $price['MIN_PRICE'];
								$maxPrice = $price['MAX_PRICE'];
								$priceRange = ($maxPrice > $minPrice) ? "$$minPrice - $$maxPrice" : "$$minPrice";
							}
				?>
	<div class="product" data-id="<?php echo $id?>" data-model="<?php echo $model;?>">
		<div class="fade">
			<img src="<?php echo $img?>" class="top">;
		</div>
		<div class="caption">
			<h3><a href="product?model=<?php echo str_replace(" ", "%20", $model);?>&id=<?php echo $id?>"><?php echo $model;?></a></h3>
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
				var url = "components/modal.php?id=" + $(".product").eq(index).attr("data-id") + "&component=modal";
				$("[name='product']").load(url, openDialog);
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
	</script>
</body>
</html>

﻿<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Products | Smartphone Depot</title>
	<link href="css/styles.css" rel="stylesheet" type="text/css">
	<link rel="icon" href="images/favicon.png" type="image/x-icon">
	<!--[if lt IE 9]>
		  <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
		  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
	<![endif]-->
  </head>
  <body>
  	<!--Header-->
		<?php
			require_once "spwebsite/users/config.php";	
			readfile("header.php");
		?>
	<!--Main-->
		<main>
			<h1 class="title">Products</h1>
			<br><br>
			<div class="gallery">
				<?php
					if (mysqli_query($link, "SELECT * FROM PHONES")) {
						
						$products = mysqli_query($link, "SELECT * FROM PHONES ORDER BY P_MODEL DESC");

						while ($row = mysqli_fetch_assoc($products)) {								
							$id = $row['P_ID'];
							$model = $row['P_MODEL'];
							$status= $row['P_STATUS'];
							$img = $row['P_IMG'];
							$prices = mysqli_query($link, "SELECT MIN(P_PRICE) AS MIN_PRICE, MAX(P_PRICE) AS MAX_PRICE FROM PHONE_OPTIONS, PHONES WHERE PHONE_OPTIONS.P_ID = $id");
							$sizes = mysqli_query($link, "SELECT * FROM PHONE_OPTIONS, PHONE_STORAGE WHERE PHONE_OPTIONS.P_ID = $id AND PHONE_STORAGE.P_STG_ID = PHONE_OPTIONS.P_STG_ID GROUP BY PHONE_OPTIONS.P_STG_ID");
							$grades = mysqli_query($link, "SELECT DISTINCT P_GRADE, PHONE_OPTIONS.P_GRADE_ID FROM PHONE_OPTIONS, PHONE_GRADES WHERE PHONE_OPTIONS.P_ID = $id AND PHONE_GRADES.P_GRADE_ID = PHONE_OPTIONS.P_GRADE_ID");
							$colors = mysqli_query($link, "SELECT DISTINCT C_DESC, C_HEX FROM PHONE_OPTIONS, PHONE_COLORS, COLORS WHERE PHONE_OPTIONS.P_ID = $id AND PHONE_OPTIONS.P_OPT_ID = PHONE_COLORS.P_OPT_ID AND PHONE_COLORS.C_ID = COLORS.C_ID");
												
							while ($price = mysqli_fetch_assoc($prices)) {
								$minPrice = $price['MIN_PRICE'];
								$maxPrice = $price['MAX_PRICE'];
							}
				?>
<div class="products" data-id="<?php echo $id?>">
  					<img src="<?php echo $img;?>">
					<br><br>
					<p tabindex='0'><a href="product.php?model=<?php echo $model?>&id=<?php echo $id?>"><?php echo $model;?></a><br><span><?php echo "$$minPrice - $$maxPrice";?></span></p>
					<div class="info">
						<button tabindex="0">View Item</button>
					</div>
					<div class="popup-hidden">
						<div class="content">	
							<button class="close">&times;</button>						
							<div class="container">
								<form method="post" action="<?php echo $_SERVER['PHP_SELF']?>" class="products">
									<div class="flex-container">
										<div class="zoom" style="background-image: url('<?php echo $img?>');">
											<img src="<?php echo $img?>">
										</div>
										<div class="product-details">
											<h1 tabindex="0"><?php echo $model;?></h1>	
											<br>
											<p class="price" tabindex="0"><?php echo "$$minPrice - $$maxPrice";?></p>	
											<br>
										<?php 	
											if ($status === "N") {
										?>
	<p class="no-stock" tabindex="0">Out of Stock</p>
											<label>Color: <span>Please Select</span></label>
											<div class="options">
											<?php												
												while ($color = mysqli_fetch_assoc($colors)) { 
											?>
	<input type="radio" name="color" id="<?php echo "P".$id."-".$color['C_DESC'];?>" value="<?php echo $color['C_DESC'];?>" disabled>
												<label for="<?php echo "P".$id."-".$color['C_DESC'];?>" class="colors" style="background-color: <?php echo $color['C_HEX'];?>" title="<?php echo $color['C_DESC'];?>"></label>
											<?php
												}
											?>
</div>
											<br><br>
											<label>Size: <span>Please Select</span></label><br>
											<div class="options">
					<?php
						while ($size = mysqli_fetch_assoc($sizes)) { 
					?>
									<input type="radio" name="size" id="<?php echo "P".$id."-".$size['P_STG_SIZE'];?>" value="<?php echo $size['P_STG_SIZE'];?>" data-size-id="<?php echo $size['P_STG_ID'];?>" disabled>
												<label for="<?php echo "P".$id."-".$size['P_STG_SIZE'];?>" class="sizes"><?php echo "$size[P_STG_SIZE] $size[P_STG_UNIT]";?></label>
					<?php
						}
					?>
						</div>
											<br><br>
											<label>Grade: <span>Please Select</span></label>
											<div class="options">
					<?php
						while ($grade = mysqli_fetch_assoc($grades)) { 
					?>
							<input type="radio" name="grade" id="<?php echo "P".$id."-".$grade['P_GRADE'];?>" value="<?php echo $grade['P_GRADE'];?>" disabled>
												<label for="<?php echo "P".$id."-".$grade['P_GRADE'];?>" class="grades"><?php echo $grade['P_GRADE'];?></label>
					<?php
							}
					?>
						</div>
											<div class="cart disabled">
												<div class="quantity">
													<label for="quantity" class="hidden">Quantity</label>
													<button type="button" class="minus" disabled>–</button><input type="number" name="quantity" class="quantity" disabled><button type="button" class="plus" disabled>＋</button>
												</div>								
												<button type="submit" name="add" disabled>Add to Cart</button>
											</div>
						<?php
											}
								else {
						?>
	<label>Color: <span class="color">Please Select</span></label>
											<div class="options">
			<?php
				while ($color = mysqli_fetch_assoc($colors)) { 
			?>
									<input type="radio" name="color" id="<?php echo "P".$id."-".$color['C_DESC'];?>" value="<?php echo $color['C_DESC'];?>" required>
												<label for="<?php echo "P".$id."-".$color['C_DESC'];?>" class="colors" style="background-color: <?php echo $color['C_HEX'];?>" title="<?php echo $color['C_DESC'];?>"></label>
			<?php
				}
			?>
								</div>
											<br><br>
											<label>Storage: <span class="size">Please Select</span></label>
											<div class="options">
			<?php
				while ($size = mysqli_fetch_assoc($sizes)) { 
			?>
									<input type="radio" name="size" id="<?php echo "P".$id."-".$size['P_STG_SIZE'];?>" value="<?php echo $size['P_STG_SIZE'];?>" data-size-id="<?php echo $size['P_STG_ID'];?>" disabled>
												<label for="<?php echo "P".$id."-".$size['P_STG_SIZE'];?>" class="sizes"><?php echo "$size[P_STG_SIZE] $size[P_STG_UNIT]";?></label>
			<?php
				}
			?>
								</div>
											<br><br>
											<label>Grade: <span class="grade">Please Select</span></label>
												<div class="options">
			<?php
				while ($grade = mysqli_fetch_assoc($grades)) { 
			?>
										<input type="radio" name="grade" id="<?php echo "P".$id."-".$grade['P_GRADE'];?>" value="<?php echo $grade['P_GRADE'];?>" data-grade-id="<?php echo $grade['P_GRADE_ID'];?>" required>
													<label for="<?php echo "P".$id."-".$grade['P_GRADE'];?>" class="grades"><?php echo $grade['P_GRADE'];?></label>
			<?php
				}
			?>
									</div>
												<p class="price"><span></span></p>
												<div class="cart">
													<div class="quantity">
														<label for="quantity" class="hidden">Quantity</label>
														<button type="button" class="minus">–</button><input type="number" name="quantity" class="quantity" step="1" min="1" value="1"><button type="button" class="plus">＋</button>
													</div>
													<button type="submit" name="add">Add to Cart</button>
												</div>
			<?php
				}
			?>
										</div>
									</div>
								</form>
							</div>
						</div>
					</div>
				</div>
		<?php 
							}
					}
			mysqli_multi_query($link, "SET @i=0; UPDATE PHONES SET P_ID=(@i:=@i+1)");
		?>
</div>
		</main>
	<!--Footer-->
		<?php 
			readfile("footer.html");
		?>
		<script src="https://kit.fontawesome.com/b217619af5.js" crossorigin="anonymous"></script>
		<script src="http://code.jquery.com/jquery-3.4.1.min.js"></script>
		<script src="js/script.js"></script>
		<script>
			for (var i = 0; i < $(".info button").length; i++) {
				handleClick(i); 
				
				function handleClick(index) {
					$(".info button").eq(index).click(function() {showProduct(index);});
				}
			}
			for (var i = 0; i < $(".zoom").length; i++) {
				mouseover(i); 
				function mouseover(index) {
					$(".zoom").eq(index).mousemove(function(e) {zoom(e);});
				}
			}
			$(".quantity button").each(function(e) {
				$(this).click(function(e) {setQuantity(e);});
			});
			$("[name='color']").click(function() {
				$(".color").html($("[name='color']:checked").val()); 
			});
			$("[name='size']").click(function() {
				$(".size").html($("[name='size']:checked").val()); 
				
				if ($("[name='grade']:checked").val()) {
					var id = $(this).attr("id").slice(1, $(this).attr("id").indexOf("-")); 
					updatePrice(id);
				}
			});
			$("[name='grade']").click(function() {
				$(".grade").html($("[name='grade']:checked").val()); 
								
				if ($("[name='size']:checked").val()) {
					var id = $(this).attr("id").slice(1, $(this).attr("id").indexOf("-")); 
					updatePrice(id);
				}
			});
		</script>
  </body>
</html>
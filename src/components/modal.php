<?php 
	require_once("../config.php");
	
	if (!empty($_GET['id']) && !empty($_GET['component'])) {
		$id = $_GET['id'];
		$component = $_GET['component'];
		$class = ($component === "product") ? "product-info" : "product-details";
	}
	else {
		http_response_code(404);
		include("error.php");
		die();
	}
	
	if (mysqli_prepare($link, "SELECT * FROM PHONES WHERE P_ID = $id")) {
		$query = mysqli_query($link, "SELECT * FROM PHONES WHERE P_ID = $id LIMIT 1");
		$phone = mysqli_fetch_assoc($query);
		$model = $phone['P_MODEL'];
		$status = $phone['P_STATUS'];
		$baseUrl = "assets/images";
		$img = "$baseUrl/$phone[P_IMG]";
		$prices = mysqli_query($link, "SELECT MIN(P_PRICE) AS MIN_PRICE, MAX(P_PRICE) AS MAX_PRICE FROM PHONE_OPTIONS, PHONES WHERE PHONE_OPTIONS.P_ID = $id");
		$sizes = mysqli_query($link, "SELECT * FROM PHONE_OPTIONS, PHONE_STORAGE WHERE PHONE_OPTIONS.P_ID = $id AND PHONE_STORAGE.P_STG_ID = PHONE_OPTIONS.P_STG_ID GROUP BY PHONE_OPTIONS.P_STG_ID");
		$grades = mysqli_query($link, "SELECT DISTINCT P_GRADE, PHONE_OPTIONS.P_GRADE_ID FROM PHONE_OPTIONS, PHONE_GRADES WHERE PHONE_OPTIONS.P_ID = $id AND PHONE_GRADES.P_GRADE_ID = PHONE_OPTIONS.P_GRADE_ID");
		$query = "SELECT DISTINCT C_DESC, C_HEX FROM PHONE_OPTIONS, PHONE_COLORS, COLORS WHERE PHONE_OPTIONS.P_ID = $id AND PHONE_OPTIONS.P_OPT_ID = PHONE_COLORS.P_OPT_ID AND PHONE_COLORS.C_ID = COLORS.C_ID ORDER BY C_DESC"; 
		$colors = mysqli_query($link, $query);			
		
		while ($price = mysqli_fetch_assoc($prices)) {
			$minPrice = $price['MIN_PRICE'];
			$maxPrice = $price['MAX_PRICE'];
			$priceRange = ($maxPrice > $minPrice) ? "$$minPrice - $$maxPrice" : "$$minPrice";
		}
?>	
										<div class="flex-container">
											<div id="carousel">
												<div class="zoom" style="background-image: url(<?php echo $img;?>);">
													<img src="<?php echo $img;?>">
												</div>
												<div id="thumbnails">
													<img src="<?php echo $img?>" alt="" role="presentation" class="active">
													<?php 
														while ($color = mysqli_fetch_assoc($colors)) { 
															$url = "$baseUrl/$model/$color[C_DESC]/back.jpg"; 													
													?>
														<img src="<?php echo $url;?>"  alt="" role="presentation">
													<?php 
														}
														$colors = mysqli_query($link, $query);			
													?>
												</div>
											</div>
											<div class="<?php echo $class;?>">
												<?php 
													if ($component == "modal") {
												?>
													<h1 tabindex="0"><?php echo $model;?></h1>	
													<br><br>
												<?php 
													}
												?>
												<p class="price-range" tabindex="0"><?php echo "$priceRange";?></p>	
												<p id="price"></p>
											<?php 
												if ($status === "N") {
											?>
											<p class="no-stock" tabindex="0">Out of Stock</p>
											<label tabindex="0">Color: <span>Please Select</span></label>
											<div class="options">
											<?php												
												while ($color = mysqli_fetch_assoc($colors)) { 
											?>
												<input type="radio" name="color" id="<?php echo $color['C_DESC'];?>" value="<?php echo $color['C_DESC'];?>" disabled>
												<label for="<?php echo $color['C_DESC'];?>" class="colors" style="background-color: <?php echo $color['C_HEX'];?>" title="<?php echo $color['C_DESC'];?>"></label>
											<?php
												}
											?>
											</div>
											<br><br>
											<label tabindex="0">Size: <span>Please Select</span></label><br>
											<div class="options">
												<?php
													while ($size = mysqli_fetch_assoc($sizes)) { 
												?>
														<input type="radio" name="size" id="<?php echo $size['P_STG_SIZE'];?>" value="<?php echo "$size[P_STG_SIZE] $size[P_STG_UNIT]";?>" data-size-id="<?php echo $size['P_STG_ID'];?>" disabled>
														<label for="<?php echo "$size[P_STG_SIZE] $size[P_STG_UNIT]";?>" class="sizes" title="<?php echo "$size[P_STG_SIZE] $size[P_STG_UNIT]";?>"><?php echo "$size[P_STG_SIZE]";?></label>
												<?php
													}
												?>
											</div>
											<br><br>
											<label tabindex="0">Grade: <span>Please Select</span></label>
											<div class="options">
											<?php
												while ($grade = mysqli_fetch_assoc($grades)) { 
											?>
													<input type="radio" name="grade" id="<?php echo $grade['P_GRADE'];?>" value="<?php echo $grade['P_GRADE'];?>" disabled>
													<label for="<?php echo $grade['P_GRADE'];?>" class="grades" title="<?php echo $grade['P_GRADE'];?>"><?php echo $grade['P_GRADE'];?></label>
											<?php
												}
											?>
											</div>
											<p id="total"></p>
											<div class="cart disabled">
												<div class="quantity">
													<label for="quantity" class="hidden">Quantity</label>
													<input type="number" name="quantity" id="quantity" step="1" min="1" value="1">
												</div>								
												<button type="submit" name="add" disabled>Add to Cart</button>
											</div>
											<?php
												}
												else {
											?>
											<label tabindex="0">Color: <span class="color">Please Select</span></label>
											<div class="options">
												<?php
													$count = 0; 
													
													while ($color = mysqli_fetch_assoc($colors)) { 
														$cDesc = str_replace(' ', '', $color['C_DESC']);
														$count++;
														
														if ($count % 6 == 0) {
												?>
														<br><br>
													<?php 
														}
													?>
														<input type="radio" name="color" id="<?php echo $cDesc?>" value="<?php echo $color['C_DESC'];?>" required>
														<label for="<?php echo $cDesc;?>" class="colors" style="background-color: <?php echo $color['C_HEX'];?>" title="<?php echo $color['C_DESC'];?>"></label>
												<?php
													}
												?>
											</div>
											<br><br>
											<label tabindex="0">Storage: <span class="size">Please Select</span></label>
											<div class="options">
												<?php
													$count = 0; 
													while ($size = mysqli_fetch_assoc($sizes)) { 
													
													$sizeDesc = str_replace(' ', '', $size['P_STG_SIZE']);
													$count++; 
													
													if ($count % 5 == 0) {
												?>	
												<br><br>
												<?php 
													}
												?>
													<input type="radio" name="size" id="<?php echo $sizeDesc;?>" value="<?php echo "$size[P_STG_SIZE] $size[P_STG_UNIT]";?>" data-size-id="<?php echo $size['P_STG_ID'];?>" required>
													<label for="<?php echo $sizeDesc;?>" class="sizes" title="<?php echo "$size[P_STG_SIZE] $size[P_STG_UNIT]";?>"><?php echo "$size[P_STG_SIZE] $size[P_STG_UNIT]";?></label>
												<?php
													}
												?>
											</div>
											<br><br>
											<label tabindex="0">Grade: <span class="grade">Please Select</span></label>
												<div class="options">
													<?php
														$count = 0; 
														while ($grade = mysqli_fetch_assoc($grades)) { 
															$count++; 
															
															if ($count % 6 == 0) {
													?>
															<br><br>
														<?php	
															}
														?>
															<input type="radio" name="grade" id="<?php echo $grade['P_GRADE'];?>" value="<?php echo $grade['P_GRADE'];?>" data-grade-id="<?php echo $grade['P_GRADE_ID'];?>" required>
															<label for="<?php echo $grade['P_GRADE'];?>" class="grades" title="<?php echo $grade['P_GRADE'];?>"><?php echo $grade['P_GRADE'];?></label>
													<?php
														}
													?>
												</div>
												<p id="total"></p>
												<div class="cart">
													<div class="quantity">
														<label for="quantity" class="hidden">Quantity</label>
														<input type="number" name="quantity" id="quantity" step="1" min="1" value="1">
													</div>
													<button type="submit" name="add">Add to Cart</button>
												</div>
												<?php
													}
												?>
										</div>
									</div>
								<?php 
									}
									else {
										http_response_code(404);
									}
									mysqli_multi_query($link, "SET @i=0; UPDATE PHONES SET P_ID=(@i:=@i+1)");
								?>
								<!--Scripts-->
								<?php 
									readfile("../js/scripts.html");
								?>
									<script src="js/niceNumber.js"></script>
									<script src="js/script.js"></script>
									<script src="js/actions.js"></script>
									<script>
										$("#thumbnails img").click(function() {
											var url = $(this).attr("src");
											$(".zoom img").attr("src", url);
											document.getElementsByClassName("zoom")[0].style.backgroundImage = "url('" + url + "')";
											$("#thumbnails img").removeClass("active");
											$(this).addClass("active");
										});
										$(".quantity button").click(function() {	
											setQuantity();
										});
										$("#quantity").keyup(function() {	
											setQuantity();
										});
									</script>
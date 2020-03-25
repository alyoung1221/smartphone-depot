<?php 
	require_once("../config.php");

	if (!empty($_GET['model']) && !empty($_GET['component'])) {
		$model = $_GET['model'];
		$component = $_GET['component'];
		$class = ($component === "product") ? "product-info" : "product-details";
	}
	else {
		http_response_code(404);
		include("error.php");
		die();
	}

	if (mysqli_prepare($link, "SELECT * FROM PHONES WHERE P_MODEL = '$model'")) {
		$query = mysqli_query($link, "SELECT * FROM PHONES WHERE P_MODEL = '$model' LIMIT 1");
		$phone = mysqli_fetch_assoc($query);
		$id = $phone['P_ID'];
		$status = $phone['P_STATUS'];
		$baseUrl = "/assets/images";
		$frontImg = "$baseUrl/$phone[P_FRONT_IMG]";
		$backImg = "$baseUrl/$phone[P_BACK_IMG]";
		$baseColor = ucwords(trim(str_replace(["%20", "$model", "/", "front.jpg"], " ", "$phone[P_FRONT_IMG]")));
		$prices = mysqli_query($link, "SELECT MIN(P_PRICE) AS MIN_PRICE, MAX(P_PRICE) AS MAX_PRICE FROM PHONE_OPTIONS, PHONES WHERE PHONE_OPTIONS.P_ID = $id");
		$sizes = mysqli_query($link, "SELECT * FROM PHONE_OPTIONS, PHONE_STORAGE WHERE PHONE_OPTIONS.P_ID = $id AND PHONE_STORAGE.P_STG_ID = PHONE_OPTIONS.P_STG_ID GROUP BY PHONE_OPTIONS.P_STG_ID");
		$grades = mysqli_query($link, "SELECT DISTINCT P_GRADE, PHONE_OPTIONS.P_GRADE_ID FROM PHONE_OPTIONS, PHONE_GRADES WHERE PHONE_OPTIONS.P_ID = $id AND PHONE_GRADES.P_GRADE_ID = PHONE_OPTIONS.P_GRADE_ID");
		$query = "SELECT DISTINCT COLORS.C_ID, C_DESC, C_HEX, SUM(PC_QUANTITY) AS SUM FROM PHONE_OPTIONS, PHONE_COLORS, COLORS WHERE PHONE_OPTIONS.P_ID = $id AND PHONE_OPTIONS.P_OPT_ID = PHONE_COLORS.P_OPT_ID AND PHONE_COLORS.C_ID = COLORS.C_ID GROUP BY C_DESC ORDER BY C_DESC = '$baseColor' DESC";		
		
		while ($price = mysqli_fetch_assoc($prices)) {
			$minPrice = $price['MIN_PRICE'];
			$maxPrice = $price['MAX_PRICE'];
			$priceRange = ($maxPrice > $minPrice) ? "$$minPrice &ndash; $$maxPrice" : "$$minPrice";
		}
?>	
										<div class="flex-container">
											<div id="carousel">
												<div class="zoom" style="background-image: url(<?php echo $frontImg;?>);">
													<img src="<?php echo $frontImg;?>">
												</div>
												<div id="thumbnails">
													<?php 
														$colors = mysqli_query($link, "$query");	
														
														$count = 0;

														while ($color = mysqli_fetch_assoc($colors)) {
															$count++;
															$url = "$baseUrl/$model/$color[C_DESC]/back.jpg"; 
															
															if ($count == 1) {
																echo "<img src='$frontImg' alt='' role='presentation' class='active' data-color='$color[C_DESC]'>";
																echo "<img src='$backImg' alt='' role='presentation' data-color='$color[C_DESC]' title='$color[C_DESC]'>";
															}
															else {
													?>
														<img src="<?php echo $url;?>"  alt="" role="presentation" data-color="<?php echo $color['C_DESC'];?>" title="<?php echo $color['C_DESC'];?>">
													<?php 
															}
														}
														$colors = mysqli_query($link, $query);			
													?>
												</div>
											</div>
											<div class="<?php echo $class;?>" data-id="<?php echo $id;?>">
												<?php 
													if ($component == "modal") {
												?>
													<h1 tabindex="0"><?php echo $model;?></h1>	
													<br><br>
												<?php 
													}
												?>
												<p id="price-range" tabindex="0"><?php echo "$priceRange";?></p>	
												<p id="price"></p>
											<?php 
												if ($status === "N") {
											?>
											<p id="no-stock" tabindex="0">Out of Stock</p>
											<label tabindex="0">Color<span>: Please Select</span></label>
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
											<label tabindex="0">Size<span>: Please Select</span></label><br>
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
											<label tabindex="0">Grade<span>: Please Select</span></label>
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
													<input type="number" name="quantity" id="quantity" step="1" min="1" value="1" disabled>
												</div>								
												<button type="submit" name="add" disabled>Add to Cart</button>
											</div>
											<?php
												}
												else {
											?>
											<p id="no-stock" tabindex="0"></p>
											<label tabindex="0">Color<span class="color">: Please Select</span></label>
											<div class="options">
												<?php
													$count = 0; 
													
													while ($color = mysqli_fetch_assoc($colors)) { 
														$cDesc = $color['C_DESC'];
														$count++;

														if ($color['SUM'] > 0) {
												?>
													<input type="radio" name="color" data-color-id = "<?php echo $color['C_ID'];?>" id="<?php echo $cDesc?>" value="<?php echo $color['C_DESC'];?>" required>
													<?php
														}
														else {
													?>	
													<input type="radio" name="color" data-color-id = "<?php echo $color['C_ID'];?>" id="<?php echo $cDesc?>" value="<?php echo $color['C_DESC'];?>" class="disabled" disabled>
													<?php 
														}
													?>
													<label for="<?php echo $cDesc;?>" class="colors" style="background-color: <?php echo $color['C_HEX'];?>" title="<?php echo $color['C_DESC'];?>"></label>
													<?php
														if ($count % 6 == 0) {
															echo "<br><br>";
														}
													}
													?>
											</div>
											<br><br>
											<label tabindex="0">Storage<span class="size">: Please Select</span></label>
											<div class="options">
												<?php
													$count = 0; 
													while ($size = mysqli_fetch_assoc($sizes)) { 
													
													$sizeDesc = "$size[P_STG_SIZE] $size[P_STG_UNIT]";
													$count++; 
													
													if ($count % 5 == 0) {
												?>	
												<br><br>
												<?php 
													}
												?>
													<input type="radio" name="size" id="<?php echo $sizeDesc;?>" value="<?php echo "$sizeDesc";?>" data-size-id="<?php echo $size['P_STG_ID'];?>" required>
													<label for="<?php echo $sizeDesc;?>" class="sizes" title="<?php echo "$sizeDesc";?>"><?php echo $sizeDesc;?></label>
												<?php
													}
												?>
											</div>
											<br><br>
											<label tabindex="0">Grade<span class="grade">: Please Select</span></label>
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
												<p id="total" tabindex="0" aria-live="polite"></p>
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
									mysqli_multi_query($link, "SET @i=0; UPDATE PHONES SET P_ID=(@i:=@i+1)");
								?>
								<!--Scripts-->
								<?php 
									readfile("../js/scripts.html");
								?>
									<script src="../js/nice-number.js"></script>
									<script src="../js/script.js"></script>
									<script src="../js/actions.js"></script>
									<script>										
										$(".zoom").each(function() {
											$(this).mousemove(function(e) {
												var zoomer = e.currentTarget;
												e.offsetX ? offsetX = e.offsetX : offsetX = e.touches[0].pageX;
												e.offsetY ? offsetY = e.offsetY : offsetX = e.touches[0].pageX;
												x = offsetX / zoomer.offsetWidth * 100;
												y = offsetY / zoomer.offsetHeight * 100;
												zoomer.style.backgroundPosition = x + '% ' + y + '%';
											});
										}); 
										$("#thumbnails img").click(function() {
											var url = $(this).attr("src");
											$(".zoom img").attr("src", url);
											document.getElementsByClassName("zoom")[0].style.backgroundImage = "url('" + url + "')";
											
											var color = $(this).attr("data-color");
											/*$("[name='color'][value='" + color + "'").prop("checked", true); 
											$(".color").html($("[name='color']:checked").val());*/
											$("#thumbnails img").removeClass("active");
											$(this).addClass("active");
										});
										
										$("[type='radio'] + label").click(function() {
											if ($(this).prev().prop("disabled")) {
												$(this).prev().prop("checked", true);
												$("[type='radio']:not(:disabled)").prop("checked", false); 
												$("[type='radio']:not([name='" + $(this).prev().attr("name") + "'])").prop("disabled", true);
												$("[name='product'] button").prop("disabled", true);
												$("[name='product'] p:not(#no-stock)").hide();
												$("#no-stock").show();
												$("#no-stock").html("Out of Stock");
												$("#total").html("");
											}
											else {
												$("[type='radio']:not(.disabled)").prop("disabled", false); 
												$("[name='product'] button").prop("disabled", false);
												$("[name='product'] p:not(#no-stock)").show();
												$("#no-stock").hide();
											}
										});
										
										$("input[type='radio']").each(function(index) {
											$(this).click(function() {
												switch($(this).attr("name")) {
													case "color": 
														$(".color").html(": " + $("[name='color']:checked").val()); 
														var url = $("#thumbnails img").eq(index + 1).attr("src");
														$(".zoom img").attr("src", url);
														document.getElementsByClassName("zoom")[0].style.backgroundImage = "url('" + url + "')";
														break;
													case "size":
														$(".size").html(": " + $("[name='size']:checked").val()); 
														break;
													case "grade": 
														$(".grade").html(": " + $("[name='grade']:checked").val()); 
														break;
												}
												if ($("[name='color']:checked").val() && $("[name='grade']:checked").val() && $("[name='size']:checked").val()) {
													getProductInfo();
												}
											});
										});
										$(".quantity button").click(function() {	
											setQuantity();
										})
									</script>
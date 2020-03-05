<?php
session_start();
	require_once("spwebsite/users/config.php");	
	
	if (mysqli_query($link, "SELECT * FROM PHONES")) {				
?>
<!DOCTYPE HTML>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>Inventory | Smartphone Depot</title>
	<link href="css/styles.css" rel="stylesheet" type="text/css">
	<link rel="icon" href="images/favicon.png" type="image/x-icon">
</head>
<body>
  	<!--Header-->
		<?php require 'header1.php';?>
	<!--Main-->
		<main>
			<table>
				<thead>
					<tr>
						<th>Model
							<span class="fas fa-sort"></span>
							<div>
								<select name="model">
									<option value="" selected disabled>--</option>
									<?php 
									$phones = mysqli_query($link, "SELECT P_MODEL FROM PHONES");
									
									while ($phone = mysqli_fetch_assoc($phones)) {
										$model = $phone['P_MODEL'];
										
										echo "<option value='$model'>$model</option>";
									}
									?>
								</select>
							</div>
						</th>
						<th>Grade
							<span class="fas fa-sort"></span>
							<div>
								<select name="grade">
									<option value="" selected disabled>--</option>
									<?php 
									$phones = mysqli_query($link, "SELECT P_GRADE FROM PHONE_GRADES");
									
									while ($phone = mysqli_fetch_assoc($phones)) {
										$grade = $phone['P_GRADE'];
										
										echo "<option value='$grade'>$grade</option>";
									}
									?>
								</select>
							</div>
						</th>
						<th>Storage Capacity
							<span class="fas fa-sort" id="stg"></span>
							<div>
								<select name="storage">
									<option value="" selected disabled>--</option>
									<?php 
									$phones = mysqli_query($link, "SELECT P_STG_SIZE FROM PHONE_STORAGE");
									
									while ($phone = mysqli_fetch_assoc($phones)) {
										$storage = $phone['P_STG_SIZE'];
										
										echo "<option value='$storage'>$storage</option>";
									}
									?>
								</select>
							</div>
						</th>
						<th>Colors
							<span class="fas fa-sort"></span>
							<div>
								<select name="colors">
									<option value="" selected disabled>--</option>
									<?php 
									$phones = mysqli_query($link, "SELECT C_DESC FROM COLORS");
									
									while ($phone = mysqli_fetch_assoc($phones)) {
										$color = $phone['C_DESC'];
										
										echo "<option value='$color'>$color</option>\n";
									}
									?>
								</select>
							</div>
						</th>
						<th>Quantity
							<span class="fas fa-sort"></span>
							<div>
								<input type="search" id="isearch" placeholder="Search. . ." title="" required>
							</div>
						</th>
					</tr>
				</thead>
				<tbody>
				<?php
					$products = ""; 
					$phones = mysqli_query($link, "SELECT P_MODEL, P_GRADE, P_STG_SIZE, P_QUANTITY FROM PHONES, PHONE_OPTIONS AS OPTS, PHONE_STORAGE AS STG, PHONE_GRADES AS GRADES WHERE PHONES.P_ID = OPTS.P_ID AND OPTS.P_STG_ID = STG.P_STG_ID AND OPTS.P_GRADE_ID = GRADES.P_GRADE_ID ORDER BY OPTS.P_ID, P_GRADE, P_STG_SIZE");
							
						while ($phone = mysqli_fetch_assoc($phones)) {
							$products .= "\t\t\t\t<tr>\n";
							$products .= "\t\t\t\t\t\t<td>$phone[P_MODEL]</td>\n";
							$products .= "\t\t\t\t\t\t<td>$phone[P_GRADE]</td>\n";
							$products .= "\t\t\t\t\t\t<td>$phone[P_STG_SIZE]</td>\n";
							$colors = "";
							$i = 0;
														
							$query = mysqli_query($link, "SELECT DISTINCT(C_DESC) FROM PHONES, PHONE_OPTIONS, PHONE_COLORS, COLORS WHERE PHONE_OPTIONS.P_ID = PHONES.P_ID AND PHONE_COLORS.P_OPT_ID = PHONE_OPTIONS.P_ID AND PHONE_COLORS.C_ID = COLORS.C_ID");

							while ($color = mysqli_fetch_assoc($query)) {
								$colors .= strtolower("$color[C_DESC]");
								$i++; 
										
								if ($i != mysqli_num_rows($query)) {
									$colors .= ", ";
								}
							}
							$products .= "\t\t\t\t\t\t<td>".ucfirst($colors)."</td>\n";
							$products .= "\t\t\t\t\t\t<td>$phone[P_QUANTITY]</td>\n";
							$products .= "\t\t\t\t\t</tr>\n";				
						}				
						echo $products;
						mysqli_free_result($phones);
					}			
					mysqli_close($link);
				?>
			</tbody>
		</table>
	</main>
	<?php 
		readfile("footer.html");
	?>
	<script src="https://kit.fontawesome.com/b217619af5.js" crossorigin="anonymous"></script>
	<script src="http://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script src="http://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
	<script src="js/script.js"></script>
	<script>
		$("nav a:nth-of-type(2)").addClass("active");
		
		var timeout = null; 

		$("#isearch").keyup(function() {
			clearTimeout(timeout);
			timeout = setTimeout(search, 500);
			$("#clear").css("color", "#808080");
		});
		
		$("#isearch").on("input", function() {
			if ($("#isearch").val() === "") {
				displayTable();
			}
		});
		
		for (var i = 0; i < $(".fa-sort").length; i++) {
			handleClick(i); 
			
			function handleClick(index) {
				$(".fa-sort").eq(index).click(
					function() {sort(index);
				});
			}
		}
	</script>
</body>
</html>
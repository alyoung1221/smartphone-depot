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
				<table border="1" width = 100%>
			<tr>
				
				<th>Model</th>
				<th>Grade</th>
				<th>Storage Capacity</th>
				
				<th>price</th>
				<th>Quantity</th>
				
				
				
			</tr>
			<?php
				$connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");
				$result = mysqli_query($connection, 
				"SELECT PhoneType,grade,storageGB,price, stock
				FROM sp_phones;");
				
				while ($row = mysqli_fetch_row($result)) {
			?>
			<tr>
				
				<td><?php echo $row[0];?></td>
				<td><?php echo $row[1];?></td>
				<td><?php echo $row[2];?></td>
				<td><?php echo $row[3];?></td>
				<td><?php echo $row[4];?></td>
				
				
				
			</tr>
			<?php
				
				}
				mysqli_free_result($result);
				mysqli_close($connection);
			?>
		</div>
		</table>
				<?php 
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
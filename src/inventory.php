<!DOCTYPE HTML>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>Inventory | Smartphone Depot</title>
	<link href="https://necolas.github.io/normalize.css/8.0.1/normalize.css" rel="stylesheet" type="text/css">
	<link href="css/styles.css" rel="stylesheet" type="text/css">
	<link rel="icon" href="assets/favicon.png" type="image/x-icon">
</head>
<body>
  	<!--Header-->
	<?php
		include("components/header.php");
	?>
	<!--Main-->
		<main>
			<table id="inventory">
				<caption><h1 tabindex="0">Live Inventory</h1></caption>
				<thead>
					<tr>
						<th scope="col">Model
							<button class="fas fa-sort"><span class="hidden" tabindex="0">Sort by model</span></button>
						</th>
						<th scope="col">Grade
							<button class="fas fa-sort"><span class="hidden">Sort by phone grade</span></button>
						</th>
						<th scope="col">Storage Capacity
							<button class="fas fa-sort" id="stg"><span class="hidden">Sort by storage capacity</span></button>
						</th>
						<th scope="col">Colors
							<button class="fas fa-sort"><span class="hidden">Sort by colors</span></button>
						</th>
						<th scope="col">Quantity
							<button class="fas fa-sort"><span class="hidden">Sort by quantity</span></button>
							<div>
								<button type="button" name="reset" title="Reset filters"><span aria-hidden="true">&times;</span><span class="hidden">Reset filters</span></button>
							</div>
						</th>
					</tr>
				</thead>
				<tbody>
				<?php
					if (mysqli_query($link, "SELECT * FROM PHONES")) {	
						$products = ""; 
						$phones = mysqli_query($link, "SELECT PHONES.P_ID, OPTS.P_OPT_ID, P_MODEL, P_GRADE, P_STG_SIZE, P_STG_UNIT, P_QUANTITY FROM PHONES, PHONE_OPTIONS AS OPTS, PHONE_STORAGE AS STG, PHONE_GRADES AS GRADES WHERE PHONES.P_ID = OPTS.P_ID AND OPTS.P_STG_ID = STG.P_STG_ID AND OPTS.P_GRADE_ID = GRADES.P_GRADE_ID ORDER BY OPTS.P_ID, P_STG_SIZE, P_GRADE");
							
						while ($phone = mysqli_fetch_assoc($phones)) {
							$products .= "\t\t\t\t<tr>\n";
							$products .= "\t\t\t\t\t\t<th scope='row'>$phone[P_MODEL]</th>\n";
							$products .= "\t\t\t\t\t\t<td>$phone[P_GRADE]</td>\n";
							$products .= "\t\t\t\t\t\t<td>$phone[P_STG_SIZE] $phone[P_STG_UNIT]</td>\n";
							$colors = "";
							$i = 0;
														
							$query = mysqli_query($link, "SELECT DISTINCT(C_DESC) FROM PHONES, PHONE_OPTIONS, PHONE_COLORS, COLORS WHERE PHONE_OPTIONS.P_ID = $phone[P_ID] AND PHONE_COLORS.P_OPT_ID = $phone[P_OPT_ID] AND PHONE_COLORS.C_ID = COLORS.C_ID ORDER BY C_DESC");

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
	<!--Footer-->
	<?php 
		readfile("components/footer.html");
	?>
	
	<!--Scripts-->
	<?php 
		readfile("js/scripts.html");
	?>
	<script src="js/niceNumber.js"></script>
	<script src="js/script.js"></script>
	<script src="js/actions.js"></script>
	<script src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js"></script>
	<script>
		$(".menu-item:first-of-type").addClass("active");
		$(".submenu-item:last-of-type a").addClass("active");
		
		var inventory = $('#inventory').DataTable({
			info: false,
			paging: false,
			ordering: false,
			initComplete: function() {
				this.api().columns([0, 1, 2]).every(function() {
					var column = this;

					var select = $('<select><option value="">--</option></select>')
						.appendTo($(column.header()))
						.on('change', function() {
							var val = $.fn.dataTable.util.escapeRegex(
								$(this).val()
							);
							column
								.search(val ? "^" + val + "$" : '', true, false)
								.draw();
						});
						
					column.data().unique().each(function (d, j) {
						select.append('<option value="'+d+'">'+d+'</option>');
					});
				});
				
				this.api().columns(3).every(function() {
					var column = this;

					var select = $('<select><option value="">--</option></select>')
						.appendTo($(column.header()))
						.on('change', function(index) {
							var val = $.fn.dataTable.util.escapeRegex(
								$(this).val()
							);
							column
								.search(val ? val : '', true, false)
								.draw();
						});
						
					column.data().unique().sort().each(function (d, j) {
						var options = d.split(", ");
								
						for (var i = 0; i < options.length; i++) {
							var option = capitalize(options[i]);
							select.append('<option value="'+option+'">'+option+'</option>');
						}
					});
				});
				
				var options = new Array();
				
				$("select").eq(3).children("option").each(function(index){
					options[index] = $(this).val();
						
					for (i = 0; i < options.length - 1; i++){
						if (options[index] == options[i]) {
							$(this).remove();
						}
					}
				})
			}
		});

		$("[name='reset']").click(function() {
			reset(inventory)
		});
		$("select").change(function() {
			if ($(this).val()) {
				$(this).blur();
			}
		});
	</script>
</body>
</html>
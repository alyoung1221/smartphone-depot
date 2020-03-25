<?php
	require_once("../spwebsite/users/config.php");	
	
	if (mysqli_query($link, "SELECT * FROM PHONES")) {				
?>
<!DOCTYPE HTML>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>Inventory | Smartphone Depot</title>
	<link href="/css/admin-styles.css" rel="stylesheet" type="text/css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
	<link rel="icon" href="/images/favicon.png" type="image/x-icon">
</head>
<body>
  	<!--Header-->
		<?php
			readfile("header.php");
		?>
	<!--Main-->
		<main>
			<section>
				<h1>Current Inventory</h1>
				<table id="inventory">
					<thead>
						<tr>
							<th scope="col">Model
								<button class="fas fa-sort"></button>
							</th>
							<th scope="col">Grade
								<button class="fas fa-sort"></button>
							</th>
							<th scope="col">Storage Capacity
								<button class="fas fa-sort" id="stg"></button>
							</th>
							<th scope="col">Colors
								<button class="fas fa-sort"></button>
							</th>
							<th scope="col">Quantity
								<button class="fas fa-sort"></button>
							</th>
							<th class="no-export">
							</th>
						</tr>
					</thead>
					<tbody>
					<?php
						$products = ""; 
						$phones = mysqli_query($link, "SELECT P_OPT_ID, P_MODEL, P_GRADE, P_STG_SIZE, P_QUANTITY FROM PHONES, PHONE_OPTIONS AS OPTS, PHONE_STORAGE AS STG, PHONE_GRADES AS GRADES WHERE PHONES.P_ID = OPTS.P_ID AND OPTS.P_STG_ID = STG.P_STG_ID AND OPTS.P_GRADE_ID = GRADES.P_GRADE_ID ORDER BY OPTS.P_ID, P_GRADE, P_STG_SIZE");
								
							while ($phone = mysqli_fetch_assoc($phones)) {
								$id = $phone['P_OPT_ID'];
								$products .= "\t\t\t\t<tr>\n";
								$products .= "\t\t\t\t\t\t<th scope='row'>$phone[P_MODEL]</th>\n";
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
								$products .= "\t\t\t\t\t\t<td>
									<div class='rowmenu' data-id='$id' tabindex='0'>
										<button class='material-icons expand' aria-has-popup='true'>more_vert</button>
										<div class='menubar' tabindex='0'>
											<button class='edit' onclick='window.dialog.showModal();'>Edit<span class='material-icons'>edit</span></button>
											<button class='delete'>Delete<span class='material-icons'>delete</span></button>
										</div>
									</div>
								</td>";
								$products .= "\n\t\t\t\t\t</tr>\n";				
							}				
							echo $products;
							mysqli_free_result($phones);
						}			
						mysqli_close($link);
					?>				
				</tbody>
			</table>
			<div class="popup-hidden" aria-hidden="true" aria-modal="true">
				<div class="content">	
					<button type="button" class="close" aria-label="Close product">&times;</button>						
					<div class="container">
						<form method="post" action="<?php echo $_SERVER['PHP_SELF']?>" class="products">
							<section class="product-details">
								<h1>iPhone 6</h1>
								<label for="price" style="position: relative; top: -8px;">Price<span>:</span></label> 
								<input type="number" id="price" name="price" class="quantity" step=".01" min="1" value="">
								<br><br><br>
								<div class="quantity">
									<label for="quantity">Quantity<span>:</span></label>
									<button type="button" class="minus">–</button><input type="number" id="quantity" name="quantity" class="quantity" step="1" min="1" value=""><button type="button" class="plus">＋</button>
								</div>
								<br><br><br>
								<label for="saleSt">Sale Start</label>: 
								<input type="text" name="saleSt" id="saleSt">
								<br><br><br>
								<label for="saleEnd">Sale End</label>: 
								<input type="text" name="saleEnd" id="saleEnd">
								<br><br>
							</section>
							<br><br>
							<button type="submit" name="update">Update</button>
							<br><br><br><br>
						</form>
					</div>
				</div>
			</div>
		</section>
	</main>
	<?php 
		readfile("../footer.html");
	?>
	<script src="https://kit.fontawesome.com/b217619af5.js" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
	<script src="http://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/ally.js/1.4.1/ally.min.js"></script>
	<script type="text/javascript" src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.6.1/js/dataTables.buttons.min.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.6.1/js/buttons.html5.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
	<script src="../js/script.js"></script>
	<script>
		$("nav a:nth-of-type(2)").addClass("active");
		
		var timeout = null; 
		
		$(".edit").each(function(index) {
			$(".edit").eq(index).click(function() {showProduct(0);});
		});
		
		$(".delete").each(function(index) {
			$(".delete").eq(index).click(function() {
				confirm("Are you sure you want to delete this product?");
				$(".delete").eq(index).blur();
			});
		});
			
		flatpickr('#saleSt, #saleEnd', {
            dateFormat: "m/d/Y H:i K",
			enableTime: true,
			minDate: "today",
			static: true
        });
		$('#inventory').DataTable({
			dom: 'Bfrtip',
			info: false,
			paging: false,
			ordering: false,
			buttons: [
				{
					extend: "excel",
					className: 'export',
					exportOptions: {
						columns: ':not(.no-export)'
					},
					filename: "Inventory - Smartphone Depot",
					text: "<i class='fas fa-file-excel'><span class='hidden'>Export to Excel</span></i>",
					titleAttr: 'Export to Excel'
				},
				{
					extend: 'csv',
					className: 'export',
					exportOptions: {
						columns: ':not(.no-export)'
					},
					filename: "Inventory - Smartphone Depot",
					text: "<i class='fas fa-file-csv'><span class='hidden'>Export to CSV</span></i>",
					titleAttr: 'Export to CSV'
				}
			]
		});
	</script>
</body>
</html>
<?php
// start session
session_start();
 
// get the product id
$id = isset($_GET['id']) ? $_GET['id'] : "";
$name = isset($_GET['name']) ? $_GET['name'] : "";
 
// remove the item from the array
unset($_SESSION['cart'][$id]);
//======================================================
$idcarts = htmlspecialchars($_SESSION["idcart"]);
$connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");


		if (!@mysqli_query($connection, "DELETE FROM SP_cartitem WHERE idSmartPhones ='$id' and idcart = '$idcarts'")) {
		echo "Fail to add the ordered to process. please try again";
	} else {
		$rows = mysqli_affected_rows($connection);
		echo "Success delete $rows rows";
		
	}
		
	@mysqli_close($connection);
//========================================================== 
// redirect to product list and tell the user it was added to cart
header('Location: cart.php?action=removed&id=' . $id);
?>
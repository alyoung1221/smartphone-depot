<?php
session_start();
 
// get the product id
$id = isset($_GET['id']) ? $_GET['id'] : 1;
$quantity = isset($_GET['quantity']) ? $_GET['quantity'] : "";
 
// make quantity a minimum of 1
$quantity=$quantity<=0 ? 1 : $quantity;
 
// remove the item from the array
unset($_SESSION['cart'][$id]);
 
// add the item with updated quantity
$_SESSION['cart'][$id]=array(
    'quantity'=>$quantity
	
);
 //======================================
	$connection = @mysqli_connect("localhost", "root", "", "shop_cart_sessions_1") or die("cannot connect");

	if (!@mysqli_query($connection, "UPDATE sp_basketitem SET quantity = $quantity WHERE idproduct = $id")) 
	{
		echo "Error doing update";
	} 
	else 
	{
		$rows = mysqli_affected_rows($connection);
		echo "Success, update $rows Phone's Quantity";
	}
		
	@mysqli_close($connection);
	//===========================================
// redirect to product list and tell the user it was added to cart
header('Location: cart.php?action=quantity_updated&id=' . $id);
?>
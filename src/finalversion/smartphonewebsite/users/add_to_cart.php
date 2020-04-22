<?php
// start session
session_start();
// Check if the user is logged in, if not then redirect him to login page
if(!isset($_SESSION["loggedin"]) || $_SESSION["loggedin"] !== true){
    header("location: my-account.php");
    exit;
} 
?>

<?php
// start session 
session_start();
 
// get the product id
$id = $_GET["id"];
//$price = $_GET["price"];
$storageGB =  isset($_GET['storageGB']) ? $_GET['storageGB'] : "";
$price = isset($_GET['price']) ? $_GET['price'] : "";
$quantity = isset($_GET['quantity']) ? $_GET['quantity'] : 1;
$page = isset($_GET['page']) ? $_GET['page'] : 1;
 
 
 //====================conncection and add to the database================
 $connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");
 $idcarts = htmlspecialchars($_SESSION["idcart"]);
 //=================================
 
 if (!@mysqli_query($connection, "insert into sp_cartitem (idcartitem,P_OPT_ID,idsmartphones,storageGB, price, quantity,idCart)
			values(null,2,$id,$storageGB,$price,$quantity,$idcarts)")) {
			
		
	} else {
		$rows = mysqli_affected_rows($connection);
		
		
	}
		
	@mysqli_close($connection);
 
 //=================================
// make quantity a minimum of 1
$quantity=$quantity<=0 ? 1 : $quantity;
 
// add new item on array
$cart_item=array(
    'quantity'=>$quantity
);
 
/*
 * check if the 'cart' session array was created
 * if it is NOT, create the 'cart' session array
 */
if(!isset($_SESSION['cart'])){
    $_SESSION['cart'] = array();
}
 
// check if the item is in the array, if it is, do not add
if(array_key_exists($id, $_SESSION['cart'])){
    // redirect to product list and tell the user it was added to cart
    header('Location: products.php?action=exists&id=' . $id . '&page=' . $page);
}
 
// else, add the item to the array
else{
    $_SESSION['cart'][$id]=$cart_item;
 
    // redirect to product list and tell the user it was added to cart
    header('Location: products.php?action=added&page=' . $page);
}

?>
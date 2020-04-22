<?php
// start session
session_start();
// Check if the user is logged in, if not then redirect him to login page
if(!isset($_SESSION["loggedin"]) || $_SESSION["loggedin"] !== true){
    header("location: my-account.php");
    exit;
} 
?>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Check Out</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="css/bootstrap-4.3.1.css" rel="stylesheet">

</head>
<body>
<?php
// start session

 
// connect to database
include 'config/database.php';
 
// include objects
include_once "objects/product.php";
include_once "objects/product_image.php";
 
// get database connection
$database = new Database();
$db = $database->getConnection();
 
// initialize objects
$product = new Product($db);
$product_image = new ProductImage($db);
 
// set page title
$page_title="Checkout";
 
//require 'header.php';
// include page header HTML
include_once 'layout_header.php';
//include 'cartheader_layout.php';
 
if(count($_SESSION['cart'])>0){
 
    // get the product ids
    $ids = array();
    foreach($_SESSION['cart'] as $id=>$value){
        array_push($ids, $id);
    }
 
    $stmt=$product->readByIds($ids);
 
    $total=0;
    $item_count=0;
 
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)){
        extract($row);
 
        $quantity=$_SESSION['cart'][$id]['quantity'];
        $sub_total=$price*$quantity;
 
        //echo "<div class='product-id' style='display:none;'>{$id}</div>";
        //echo "<div class='product-name'>{$name}</div>";
 
        // =================
        echo "<div class='cart-row'>";
            echo "<div class='col-md-8'>";
 
                echo "<div class='product-name m-b-10px'><h4>{$ProductName}</h4></div>";
                echo $quantity>1 ? "<div>{$quantity} items</div>" : "<div>{$quantity} item</div>";
 
            echo "</div>";
			
			$totaldue = $quantity * $price;
			//echo $totaldue;
            echo "<div class='col-md-4'>";
                echo " <h4>Unit Price : &#36;" . number_format($price, 2, '.', ',') . "</h4>";
				echo " <h4>Total Price : &#36;" . number_format($totaldue, 2, '.', ',') . "</h4>";
            echo "</div>";
			
                
           
        echo "</div>";
        // =================
 
        $item_count += $quantity;
        $total+=$sub_total;
    }
	?>
    <div class='col-md-8'></div>
    <div class='col-md-12 text-align-center'>
        <div class='cart-row'>
	<?php 
            if($item_count>1){
                echo "<h4 class='m-b-10px'>Total ({$item_count} items)</h4>";
            }else{
                echo "<h4 class='m-b-10px'>Total ({$item_count} item)</h4>";
            }
			?>
            <h4> $<?php echo number_format($total, 2) ?></h4>
           <a href='place_order.php' class='btn btn-lg btn-success m-b-10px'>
               <span class='glyphicon glyphicon-shopping-cart'></span> Place Order
            </a>
        </div>
    </div>
 <?php
}
 
else{
    echo "<div class='col-md-12'>";
        echo "<div class='alert alert-danger'>";
            echo "No products found in your cart!";
        echo "</div>";
    echo "</div>";
}


				
				

 //===========================
include 'layout_footer.php';
?>
</body>
</html>

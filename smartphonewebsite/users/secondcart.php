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
$page_title="Your Shopping Cart";
 
// include page header html
require 'header.php';
//==============================
include 'cartheader_layout.php';
 $action = isset($_GET['action']) ? $_GET['action'] : "";
 
echo "<div class='col-md-12'>";
    if($action=='removed'){
        echo "<div class='alert alert-info'>";
            echo "Product was removed from your cart!";
        echo "</div>";
    }
 
    else if($action=='quantity_updated'){
        echo "<div class='alert alert-info'>";
            echo "Product quantity was updated!";
        echo "</div>";
    }
echo "</div>";
//======================may be contents here=============================
if(count($_SESSION['cart'])>0){
 
    // get the product ids
    $ids = array();
    foreach($_SESSION['cart'] as $idsmartphones=>$value){
        array_push($ids, $idsmartphones);
    }
 
    $stmt=$product->readByIds($ids);
 
    $total=0;
    $item_count=0;
 
   while ($row = $stmt->fetch(PDO::FETCH_ASSOC))
	{
        extract($row);
 
        $quantity=$_SESSION['cart'][$idsmartphones]['quantity'];
        $sub_total=$price*$quantity;
 
        // ========update the quantity using javascript to redirect the page update quantity=========
		
		?>
        <div class='#'>
            <div class='cart-row'>
			
 
                <div class='#'><h4><?php echo $ProductName ?> </h4><?php echo "Quantity:" ?></div>
 
                <?php
				 echo "<form class='update-quantity-form'>";
                    echo "<div class='product-id' style='display:none;'>{$idsmartphones}</div>";
                    echo "<div class='input-group'>";
                        echo "<input type='number' name='quantity' value='{$quantity}' class='form-control cart-quantity' min='1' />";
                            echo "<span class='input-group-btn'>";
                                echo "<button class='btn btn-default update-quantity' type='submit'>Update</button>";
                            echo "</span>";
                    echo "</div>";
                echo "</form>";
				?>
				
				<!-- 
                <form class='update-quantity-form'>
				<?php echo "<div class='product-id' style='display:none;'>{$idsmartphones}</div>";?>
                    
                    <div class='input-group'>
					
					
                        <input type='number' name='quantity' value='<?php echo $quantity ?>' class='form-control cart-quantity' min='1' />
                            <span class='#'>
                                <button class='btn btn-default update-quantity' type='submit'>Update</button>
                            </span>
                    </div>
                </form>
			!-->
                <!-- delete from cart -->
                <a href='remove_from_cart.php?id=<?php echo $idsmartphones ?>' class='btn btn-default'> Delete  </a>
				<a href='update_quantity.php?id=<?php echo $idsmartphones ?>' class='btn btn-default'> update  </a>
            </div>
 
            <div class="#">
				 
                 Unit Price : $<?php echo  number_format($price, 2) ?>
            </div>
			<div class="#">
				 
                 Storage : <?php echo  number_format($storageGB, 2)," GB" ?>
            </div>
        </div>
        
 <?php
        $item_count += $quantity;
        $total+=$sub_total;
    }
 ?>
    <div class='col-md-8'></div>
    <div class='col-md-4'>
        <div class='cart-row'>
            <h4 class='m-b-10px'>Total : <?php  echo $item_count ?> items</h4>
           Total: $<?php echo number_format($total, 2)
		   ?>
            <a href='checkout.php' class='btn btn-success m-b-10px'>
                <span class='glyphicon glyphicon-shopping-cart'></span> Proceed to Checkout
            </a>
        </div>
   </div>
 <?php
}
 
// no products were added to cart
else{
    echo "<div class='col-md-12'>";
        echo "<div class='alert alert-danger'>";
            echo "No products found in your cart!";
        echo "</div>";
    echo "</div>";
}
//===================================================
// contents will be here 
 
// layout footer 
include 'layout_footer.php';
?>

</html>
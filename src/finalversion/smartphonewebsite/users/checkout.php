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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<style>
body {
  font-family: Arial;
  font-size: 17px;
  padding: 8px;
}

* {
  box-sizing: border-box;
}

.row {
  display: -ms-flexbox; /* IE10 */
  display: flex;
  -ms-flex-wrap: wrap; /* IE10 */
  flex-wrap: wrap;
  margin: 0 -16px;
}

.col-25 {
  -ms-flex: 25%; /* IE10 */
  flex: 25%;
}

.col-50 {
  -ms-flex: 50%; /* IE10 */
  flex: 50%;
}

.col-75 {
  -ms-flex: 75%; /* IE10 */
  flex: 75%;
}

.col-25,
.col-50,
.col-75 {
  padding: 0 16px;
}

.container {
  background-color: #f2f2f2;
  padding: 5px 20px 15px 20px;
  border: 1px solid lightgrey;
  border-radius: 3px;
}

input[type=text] {
  width: 100%;
  margin-bottom: 20px;
  padding: 12px;
  border: 1px solid #ccc;
  border-radius: 3px;
}

label {
  margin-bottom: 10px;
  display: block;
}

.icon-container {
  margin-bottom: 20px;
  padding: 7px 0;
  font-size: 24px;
}

.btn {
  background-color: #4CAF50;
  color: white;
  padding: 12px;
  margin: 10px 0;
  border: none;
  width: 100%;
  border-radius: 3px;
  cursor: pointer;
  font-size: 17px;
}

.btn:hover {
  background-color: #45a049;
}

a {
  color: #2196F3;
}

hr {
  border: 1px solid lightgrey;
}

span.price {
  float: right;
  color: grey;
}

/* Responsive layout - when the screen is less than 800px wide, make the two columns stack on top of each other instead of next to each other (also change the direction - make the "cart" column go on top) */
@media (max-width: 800px) {
  .row {
    flex-direction: column-reverse;
  }
  .col-25 {
    margin-bottom: 20px;
  }
}
</style>
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
 
require 'header.php';
//include page header HTML
//include_once 'layout_header.php';
include 'cartheader_layout.php';
 
//=============================================
if(count($_SESSION['cart'])>0){
 //========cal store procedure==========

$idcarts = htmlspecialchars($_SESSION["idcart"]);
		//echo "hello: ", $idcarts ;
 $connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");
				$result = mysqli_query($connection, 
				"call cal_total_before_orderPlace_sp($idcarts);");
				
				mysqli_close($connection);
				
//=============================================
 $connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");
				$result1 = mysqli_query($connection, 
				"SELECT Shipping, Tax, Total 
				 FROM sp_cart 
				 WHERE idCart = $idcarts;");
				
				
				$result2 = mysqli_fetch_row($result1);
				$shipping =  $result2[0];
				$tax = $result2[1];
				$totalprice =  $result2[2];
				mysqli_close($connection);
//===============================================
    // get the product ids
    $ids = array();
    foreach($_SESSION['cart'] as $idSmartPhones=>$value){
        array_push($ids, $idSmartPhones);
    }
 
    $stmt=$product->readByIds($ids);
 
    $total=0;
    $item_count=0;
 
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)){
        extract($row);
 
        $quantity=$_SESSION['cart'][$idSmartPhones]['quantity'];
        $sub_total=$price*$quantity;
 
        //echo "<div class='product-id' style='display:none;'>{$id}</div>";
        //echo "<div class='product-name'>{$name}</div>";
 
        // =================
        echo "<div class='#'>";
            echo "<div class='col-md-10'>";
 
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
		<div style = "text-align:right;">
	<?php 
            if($item_count>1){
                echo "<h4 class='m-b-10px'> ({$item_count} items)</h4>";
            }else{
                echo "<h4 class='m-b-10px'> ({$item_count} item)</h4>";
            }
			?>
			<h4>Sub Total: $<?php echo number_format($total, 2) ?></h4>	
			<h4>Shipping: $<?php echo number_format($shipping, 2) ?></h4>
			<h4>Tax: $<?php echo number_format($tax, 2) ?></h4>
			<h4 style ="color: red;">Total: $<?php echo number_format($totalprice, 2) ?></h4>
		</div>
<div class="row">
  <div class="col-75">
    <div class="container">
      <form action="/action_page.php">
      
        <div class="row">
          <div class="col-50">
            <h3>Billing Address</h3>
            <label for="fname"><i class="fa fa-user"></i> Full Name</label>
            <input type="text" id="fname" name="firstname" placeholder="First Name">
            <label for="email"><i class="fa fa-envelope"></i> Email</label>
            <input type="text" id="email" name="email" placeholder="Email Address">
            <label for="adr"><i class="fa fa-address-card-o"></i> Address</label>
            <input type="text" id="adr" name="address" placeholder="Address">
            <label for="city"><i class="fa fa-institution"></i> City</label>
            <input type="text" id="city" name="city" placeholder="City">

            <div class="row">
              <div class="col-50">
                <label for="state">State</label>
                <input type="text" id="state" name="state" placeholder="State">
              </div>
              <div class="col-50">
                <label for="zip">Zip</label>
                <input type="text" id="zip" name="zip" placeholder="Zip code">
              </div>
            </div>
          </div>

          <div class="col-50">
            <h3>Payment</h3>
            <label for="fname">Accepted Cards</label>
            <div class="icon-container">
              <i class="fa fa-cc-visa" style="color:navy;"></i>
              <i class="fa fa-cc-amex" style="color:blue;"></i>
              <i class="fa fa-cc-mastercard" style="color:red;"></i>
              <i class="fa fa-cc-discover" style="color:orange;"></i>
            </div>
            <label for="cname">Name on Card</label>
            <input type="text" id="cname" name="cardname" placeholder="Name on Card">
            <label for="ccnum">Credit card number</label>
            <input type="text" id="ccnum" name="cardnumber" placeholder="Card number">
            <label for="expmonth">Exp Month</label>
            <input type="text" id="expmonth" name="expmonth" placeholder="Month Expire">
            <div class="row">
              <div class="col-50">
                <label for="expyear">Exp Year</label>
                <input type="text" id="expyear" name="expyear" placeholder="Year Expire">
              </div>
              <div class="col-50">
                <label for="cvv">CVV</label>
                <input type="text" id="cvv" name="cvv" placeholder="CVV">
              </div>
            </div>
          </div>
          
        </div>
        <label>
          <input type="checkbox" checked="checked" name="sameadr"> Shipping address same as billing
        </label>
        
      </form>
    </div>
  </div>
  
</div>
			
			
			
            <h4> Total: $<?php echo number_format($totalprice, 2) ?></h4>
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

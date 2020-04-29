<?php
// start session
session_start();
 

//========cal store procedure==========

$idcarts = htmlspecialchars($_SESSION["idcart"]);
		//echo "hello: ", $idcarts ;
 $connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");
				$result = mysqli_query($connection, 
				"call basket_calc_sp($idcarts);");
				
				mysqli_close($connection);
// remove items from the cart
session_destroy();
//unset($_SESSION['cart']);
// set page title
$page_title="Thank You For Shopping At SmartPhone Depot! See You Again.";
 
require 'header.php';
// include page header HTML
//include_once 'layout_header.php';
include 'cartheader_layout.php';
 
echo "<div class='col-md-12'>";
	
    // tell the user order has been placed
    echo "<div class='alert alert-success'>";
		
		
        echo "<strong>Your order has been placed!</strong> Thank you very much!";
    echo "</div>";
 
echo "</div>";
 
// include page footer HTML
include_once 'layout_footer.php';
?>
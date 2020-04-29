<?php
if(!isset($_SESSION['cart'])){
    $_SESSION['cart']=array();
}
 
while ($row = $stmt->fetch(PDO::FETCH_ASSOC)){
    extract($row);
	
    // creating box
    echo "<div class='col-md-4 m-b-20px'>";
 
        // product id for javascript access
        echo "<div class='product-id display-none'>{$id}</div>";
		echo "<div class='product-id display-none'>{$price}</div>";
		//echo "<div class='product-id display-none'>{$quantity}</div>";
        echo "<a href='product.php?id={$id}&price ={$price}' class='product-link'>";
			
            // select and show first product image
            $product_image->product_id=$id;
			
			
            $stmt_product_image=$product_image->readFirst();
 
            while ($row_product_image = $stmt_product_image->fetch(PDO::FETCH_ASSOC)){
                echo "<div class='m-b-10px'>";
                    echo "<img src='uploads/images/{$row_product_image['name']}' class='w-90-pct' alt=phoneimages />";
                echo "</div>";
            }
 
            // product name
            echo "<div class='product-name m-b-10px'>{$name}</div>";
        echo "</a>";
 
        // add to cart button
        echo "<div class='m-b-10px'>";
            if(array_key_exists($id, $_SESSION['cart'])){
                echo "<a href='cart.php' class='btn btn-success w-100-pct'>";
                    echo "Update Cart";
                echo "</a>";
            }else{
				//==============show the price from database to be added into the database=========
				$connection = @mysqli_connect("localhost", "root", "", "shop_cart_sessions_1") or die("cannot connect");

				//=================================
				$result = mysqli_query($connection, 
				"SELECT price FROM products WHERE id = $id;");
				
				$row = mysqli_fetch_row($result); 
				$price = $row[0];
				
		
				
				//===============================
			echo "<a href='add_to_cart.php?price={$price}&id={$id}&page={$page}' class='btn btn-primary w-100-pct'>Add to Cart</a>";
            @mysqli_close($connection);
			}
        echo "</div>";
 
    echo "</div>";
}
 
include_once "paging.php";
?>
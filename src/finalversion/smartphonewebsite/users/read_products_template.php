<?php
if(!isset($_SESSION['cart'])){
    $_SESSION['cart']=array();
}
 
while ($row = $stmt->fetch(PDO::FETCH_ASSOC)){
    extract($row);
	
    // creating box
    echo "<div class='col-md-4 m-b-20px'>";
 
        // product id for javascript access
        echo "<div class='product-id display-none'>{$idSmartPhones}</div>";
		echo "<div class='product-id display-none'>{$price}</div>";
		echo "<div class='product-id display-none'>{$storageGB}</div>";
		//echo "<div class='product-id display-none'>{$quantity}</div>";
        echo "<a href='product.php?id={$idSmartPhones}&price ={$price}' class='product-link'>";
			
            // select and show first product image
            $product_image->idSmartPhones=$idSmartPhones;
			$product->idSmartPhones=$idSmartPhones;
			
            $stmt_product_image=$product_image->readFirst();
			$stmt_product_name=$product->readFirst();
			$connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");
			$result = mysqli_query($connection, 
				"SELECT productName from sp_phones");	
            while ($row_product_image = $stmt_product_image->fetch(PDO::FETCH_ASSOC))
			{
                echo "<div class='m-b-10px'>";
                    echo "<img src='uploads/images/{$row_product_image['name']}' class='w-90-pct' alt=phoneimages />";
                echo "</div>";
				echo "<div class='product-name m-b-10px'>{$row_product_image['idSmartPhones']}</div>";
				$result2 = mysqli_fetch_row($result);
				$typeofphone =  $result2[0];
            }
			
				
				
            // product name
			//echo "<div class='product-name m-b-10px'>{$typeofphone}</div>";
				
        echo "</a>";
 
        // add to cart button
        echo "<div class='m-b-10px'>";
            if(array_key_exists($idSmartPhones, $_SESSION['cart'])){
                echo "<a href='cart.php' class='btn btn-success w-100-pct'>";
                    echo "Update Cart";
                echo "</a>";
            }else{
				//==============show the price from database to be added into the database=========
				$connection = @mysqli_connect("localhost", "root", "", "smartphonedepotdb") or die("cannot connect");

				//=================================
				$result = mysqli_query($connection, 
				"SELECT price, storageGB FROM sp_phones WHERE idSmartPhones = $idSmartPhones;");
				
				$row = mysqli_fetch_row($result); 
				$price = $row[0];
				$storageGB = $row[1];
		
				
				//===============================
			echo "<a href='add_to_cart.php?price={$price}&id={$idSmartPhones}&storageGB={$storageGB}&page={$page}' class='btn btn-primary w-100-pct'>Add to Cart</a>";
            @mysqli_close($connection);
			}
        echo "</div>";
 
    echo "</div>";
}
 
include_once "paging.php";
?>
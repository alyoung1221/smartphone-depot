<?php
	require_once "../config.php";
	
	if (!empty($_POST['name']) && !empty($_POST['email']) && !empty($_POST['subject']) && !empty($_POST['msg'])) {
		$name = $_POST['name'];
		$email = $_POST['email'];
		$subject = $_POST['subject'];
		$msg = $_POST['msg'];
		
		$info = $name . "<br>" . $email . "<br>" . $subject . "<br>" . $msg;
		echo $info; 
		
		$message = $name . $email .  $subject . $msg;
		/*$mail = mail("ayoung39@gmu+edu", $_POST['subject'], $message);

		if ($mail) {
			echo "Sent";
		}*/
	}

	if (!empty($_GET['id']) && !empty($_GET['size']) && !empty($_GET['grade'])) {
		$id = $_GET['id'];
		$size = $_GET['size'];
		$grade = $_GET['grade'];
		$query = mysqli_query($link, "SELECT P_OPT_ID FROM PHONE_OPTIONS WHERE P_ID = $id AND P_STG_ID = $size AND P_GRADE_ID = $grade LIMIT 1");
		$optId = mysqli_fetch_assoc($query)['P_OPT_ID'];
		
		echo "$optId";
		mysqli_free_result($query);
	}
	
	if (!empty($_GET['optId']) && empty($_GET['colorId'])) {
		$optId = $_GET['optId'];
		$query = mysqli_query($link, "SELECT P_PRICE FROM PHONE_OPTIONS WHERE P_OPT_ID = $optId LIMIT 1");
		$price = mysqli_fetch_assoc($query)['P_PRICE']; 
		
		echo "$price";
		mysqli_free_result($query);
	}
	
	if (!empty($_GET['optId']) && !empty($_GET['colorId'])) {
		$optId = $_GET['optId'];
		$colorId = $_GET['colorId'];
		$query = mysqli_query($link, "SELECT PC_QUANTITY FROM PHONE_COLORS WHERE P_OPT_ID = $optId AND C_ID = $colorId LIMIT 1");
		$quantity = mysqli_fetch_assoc($query)['PC_QUANTITY']; 
		$availability = (int) $quantity > 0 ? "In Stock" : "Out of stock";
		
		echo "$availability";
		mysqli_free_result($query);
	}
	
	mysqli_close($link);
?>
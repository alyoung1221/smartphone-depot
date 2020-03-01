<?php
	require_once "spwebsite/users/config.php";
	
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

	/*Gets phone prices based on parameters provided*/
	
	if (!empty($_GET['id']) && !empty($_GET['size']) && !empty($_GET['grade'])) {
		$id = (int) $_GET['id'];
		$size = $_GET['size'];
		$grade = $_GET['grade'];
		$query = mysqli_query($link, "SELECT P_PRICE FROM PHONE_OPTIONS WHERE PHONE_OPTIONS.P_ID = $id AND PHONE_OPTIONS.P_STG_ID = $size AND PHONE_OPTIONS.P_GRADE_ID = $grade LIMIT 1");
		$price = number_format(mysqli_fetch_assoc($query)['P_PRICE'], 2); 
		
		echo "$$price";
		mysqli_free_result($query);
	}
	mysqli_close($link);
?>
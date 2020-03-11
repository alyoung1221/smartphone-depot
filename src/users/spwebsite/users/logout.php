<!doctype html>
<?php
// Initialize the session
session_start();
 
// Unset all of the session variables
$_SESSION = array();
 
// Destroy the session.
session_destroy();
 
// Redirect to login page
header("location: login.php");
exit;
?>
<html>
<head>
<meta charset="utf-8">
<title>log out</title>
</head>

<body>
</body>
</html>
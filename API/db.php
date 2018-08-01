<?php
$host_name = 'db748303572.db.1and1.com';
$database = 'db748303572';
$user_name = 'dbo748303572';
$password = 'radiusdb';

$dbh = null;
try {
  $dbh = new PDO("mysql:host=$host_name; dbname=$database;", $user_name, $password);
} catch (PDOException $e) {
  echo "Error!: " . $e->getMessage() . "<br/>";
  die();
}
?>

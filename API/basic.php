<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Credentials: true");
header("Content-Type: application/json; charset=UTF-8");

require('db.php');

$location = [$_GET['lat'], $_GET['lon']];

echo "{";
echo "\"lat\": ", $location[0], ", \"lon\": ", $location[1], "";
echo "}";




?>

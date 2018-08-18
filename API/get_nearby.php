<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Credentials: true");
header("Content-Type: application/json; charset=UTF-8");

require('db.php');

// set ID property of product to be edited
$lat = isset($_GET['latitude']) ? $_GET['latitude'] : die();
$lon = isset($_GET['longitude']) ? $_GET['longitude'] : die();
$rad = 100;

$R = 6371;  // earth's mean radius, km

// first-cut bounding box (in degrees)
$maxLat = $lat + rad2deg($rad/$R);
$minLat = $lat - rad2deg($rad/$R);
$maxLon = $lon + rad2deg(asin($rad/$R) / cos(deg2rad($lat)));
$minLon = $lon - rad2deg(asin($rad/$R) / cos(deg2rad($lat)));

// $sql = "SELECT FirstCut.*, passes.name as pass_name, passes.link, acos(sin(:lat)*sin(radians(latitude)) + cos(:lat)*cos(radians(latitude))*cos(radians(longitude)-:lon)) * :R As D
//     FROM (
//         SELECT *
//         FROM trails
//         WHERE latitude BETWEEN :minLat AND :maxLat
//         AND longitude BETWEEN :minLon AND :maxLon
//     ) as FirstCut, passes
//     Where acos(sin(:lat)*sin(radians(latitude)) + cos(:lat)*cos(radians(latitude))*cos(radians(longitude)-:lon)) * :R < :rad
//     AND (FirstCut.pass=passes.id or (FirstCut.pass=0 and passes.id=5))
//     Order by D
//     LIMIT 10";

// echo "\nLAT\n";
// echo $maxLat;
// echo "\n";
// echo $minLat;
// echo "\nLON\n";
// echo $maxLon;
// echo "\n";
// echo $minLon;

$sql = "SELECT *
    FROM test_gps
    WHERE latitude BETWEEN :minLat AND :maxLat
    AND longitude BETWEEN :minLon AND :maxLon";

$params = [
        // 'lat'    => deg2rad($lat),
        // 'lon'    => deg2rad($lon),
        'minLat' => $minLat,
        'minLon' => $minLon,
        'maxLat' => $maxLat,
        'maxLon' => $maxLon,
        // 'rad'    => $rad,
        // 'R'      => $R,
    ];

$result = $dbh->prepare($sql);
$result->execute($params);

$hikes = array();

foreach ($result as $row) {
    extract($row);
    $hike=array(
        "id" => $id,
        "latitude" => $latitude,
        "longitude" => $longitude,
        "description" => $user
    );

    array_push($hikes, $hike);
}

echo "{ \"people\": ";
echo json_encode($hikes);
echo ",\"count\": ";
echo count($hikes);
echo "}";


?>

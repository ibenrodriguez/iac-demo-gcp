<?php 
$ip = $_SERVER['REMOTE_ADDR'];
// display it back
echo "<h1>Welcome to the CloudArmor IaC HTTP Load Balancing Demo</h1>";
echo "<h2>Client IP</h2>";
echo "Your IP address : " . $ip;
echo "<h2>Hostname</h2>";
echo "Server Hostname: " . php_uname("n");
echo "<h2>Server Location</h2>";
echo "Region and Zone: " . "region-here";
echo "<h2>This demo was deployed using Terraform Cloud</h2>";
?>

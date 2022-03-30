#! /bin/bash  
yum update -y
yum install -y epel-release
yum install -y nmap wget curl iperf3 siege httpd php
service httpd start
sudo vm_hostname="$(curl -H "Metadata-Flavor:Google" http://169.254.169.254/computeMetadata/v1/instance/name)"
sudo echo "Page served from: $vm_hostname" | tee /var/www/html/index.html
cd /var/www/html 
rm index.html -f 
rm index.php -f 
wget https://storage.googleapis.com/cloud-training/gcpnet/httplb/index.php 
META_REGION_STRING=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/zone" -H "Metadata-Flavor: Google") 
REGION=`echo "$META_REGION_STRING" | awk -F/ '{print $4}'` 
sed -i "s|region-here|$REGION|" index.php 

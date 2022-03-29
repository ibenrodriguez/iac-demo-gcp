wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -ivh epel-release-latest-7.noarch.rpm
yum update -y
yum install -y epel-release
yum install -y nmap wget curl iperf3 siege httpd
service httpd start
sudo vm_hostname="$(curl -H "Metadata-Flavor:Google" http://169.254.169.254/computeMetadata/v1/instance/name)"
sudo echo "Page served from: $vm_hostname" | tee /var/www/html/index.html

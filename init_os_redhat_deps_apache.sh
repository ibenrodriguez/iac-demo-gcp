yum update
yum install -y nmap wget curl
wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -ivh epel-release-latest-7.noarch.rpm
yum install epel-release
yum install -y nmap wget curl iperf3 siege httpd

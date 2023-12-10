
sudo yum install -y firewalld
sudo systemctl start firewalld
sudo systemctl enable firewalld

sudo yum install -y mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb

sudo firewall-cmd --permanent --zone=public --add-port=3306/tcp
sudo firewall-cmd --reload


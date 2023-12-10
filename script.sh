function print_color(){
    case $1 in 
    "green") COLOR="\033[0;32m" ;;
    "red") COLOR="\033[0;31m" ;;
    "*") COLOR="\033[0m" ;;
    esac
    echo -e "${COLOR}$1${NO_COLOR}"

}



# ------------------- Database Configuration -------------------------

# Install and configure firewallD
print_color "green" "Installing firewalld..."

sudo yum install -y firewalld
sudo systemctl start firewalld
sudo systemctl enable firewalld

is_firewalld_active=$(systemctl is-active firewalld)

if [ $is_firewalld_active = "active" ]
then
    print_color "green" "Firewalld Service is active"
else
    print_color "red" "FirewallD Service is not active"
    exit 1
fi


# Install and configure MariaDB
print_color "green" "Installing MariaDB..."
sudo yum install -y mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb


# Add firewallD rules for database
print_color "green" "Adding Firewall rules for db..."
sudo firewall-cmd --permanent --zone=public --add-port=3306/tcp
sudo firewall-cmd --reload


# Configure Database 
print_color "green" "Configuring DB..."

cat > db_config.sql <<-EOF
MariaDB > CREATE DATABASE ecomdb;
MariaDB > CREATE USER 'ecomuser'@'localhost' IDENTIFIED BY 'ecompassword';
MariaDB > GRANT ALL PRIVILEGES ON *.* TO 'ecomuser'@'localhost';
MariaDB > FLUSH PRIVILEGES;
EOF

sudo mysql < db_config.sql

# Load inventory data into database
print_color "green" "Loading inventory data into DB..."
cat > db-load-script.sql <<-EOF
USE ecomdb;
CREATE TABLE products (id mediumint(8) unsigned NOT NULL auto_increment,Name varchar(255) default NULL,Price varchar(255) default NULL, ImageUrl varchar(255) default NULL,PRIMARY KEY (id)) AUTO_INCREMENT=1;

INSERT INTO products (Name,Price,ImageUrl) VALUES ("Laptop","100","c-1.png"),("Drone","200","c-2.png"),("VR","300","c-3.png"),("Tablet","50","c-5.png"),("Watch","90","c-6.png"),("Phone Covers","20","c-7.png"),("Phone","80","c-8.png"),("Laptop","150","c-4.png");
EOF

sudo mysql < db-load-script.sql




# ------------------- Web Server Configuration -------------------------
print_color "green" "Configuring Web Server..."
# Install Apache web server and php
sudo yum install -y httpd php php-mysqlnd

print_color "green" "Configuring firewallD rules for web server..."
# Configure firewallD rules for web server
sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
sudo firewall-cmd --reload

sudo sed -i 's/index.html/index.php/g' /etc/httpd/conf/httpd.conf

# Start and enable http service
print_color "green" "Starting web server..."
sudo systemctl start httpd
sudo systemctl enable httpd

# Replace database IP with localhost
sudo sed -i 's/172.20.1.101/localhost/g' /var/www/html/index.php


print_color "green" "All gone!"

curl http://localhost


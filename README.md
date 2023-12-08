# 2-Tier E-Commerce App Deployment

This simple E-Commerce website was my first app deployment.
The project was made with the LAMP stack but instead of MySql I used Maria db.
LAMP stands for Linux, Apache, MySql/MariaDB, php.

I decided to put a little spin on this task and made it entirely inside a CentOS VM with Vagrant and Oracle Virtual Box. It took a little setting-up but in the end it all worked out.

Disclaimer: The javascript and the php logic/interface weren't done by me. My only interaction with them is editing a few lines of texts. All credit goes to KodeKloud.


![Alt text] (/home/plamen/E-Commerce_Deployment/gifIndex.gif)

### Stage 1 - Setting up my VM:

On my Ubuntu host machine I grabbed a Vagrant box of CentOS9 and ran it through my Oracle Virtual Box. 

Then I got the ssh configuration of my Vagrant's VM and used it to SSH from Ubuntu to the CentOS. With the help of the Remote SSH extension in my VsCode I managed to clone the e-commerce repo and load it into my IDE. It's worth mentioning that I still had to generate an SSH key for my github.


### Stage 2 - Database and Firewall

The first step into deployment was configuring firewalld which is a dynamic firewall management tool. It's a high-level device that abstracts away the manual manipulating of iptable rules which I am not yet familiar with to be honest. 
I used it to split up the traffic ports in two:

One for the MariaDB so the web application communicates with the database server.
I set it to the default: 3306 (TCP).

One for the HTTP traffic:
I set it to the default: 80 (TCP).

The second step into deployment and chill was installing and configuring mariaDB.
There's not much more to it. I created a database called 'ecomdb' and then a user with all privileges. After that I loaded a sql script containing the inventory information to the database.


### Stage 3 - Configuring the Apache server

As you can see this wasn't that much of a hassle either. You just have to make sure that you connect it to the databse and then configure the the httpd to load the index.php page in the web app.


#!bin/bash
yum install httpd -y
chkconfig httpd on
service httpd start
echo "<h1>what is your name</h1>" > /var/www/html/index.html

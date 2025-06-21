#!/bin/bash
apt-get update
apt-get install -y nginx
echo "<h1>Hello there</h1>" > /var/www/html/index.html
systemctl enable nginx
systemctl start nginx


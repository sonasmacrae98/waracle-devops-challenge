#!/bin/bash
apt-get update
apt-get install -y nginx
echo "${html_content}" > /var/www/html/index.html
systemctl enable nginx
systemctl start nginx

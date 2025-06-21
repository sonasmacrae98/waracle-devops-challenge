#!/bin/bash
apt-get update
apt-get install -y nginx

# Inject the HTML content into index.html
echo "${html_content}" > /var/www/html/index.html

systemctl enable nginx
systemctl start nginx

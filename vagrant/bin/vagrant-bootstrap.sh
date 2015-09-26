#!/usr/bin/env bash

# run locally stored secret env vars
source /vagrant/local/secretes.sh

# install components
sudo apt-get update

# install apache
sudo apt-get install -y --force-yes apache2

# install php
sudo apt-get install -y --force-yes php5 libapache2-mod-php5 php5-mcrypt php5-gd libssh2-php php5-mysql

# install word press
cd ~
wget http://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
cd ~/wordpress
cp wp-config-sample.php wp-config.php
sed -i -e "s/database_name_here/$dbname/g" wp-config.php
sed -i -e "s/username_here/$dbuser/g" wp-config.php
sed -i -e "s/password_here/$dbpassword/g" wp-config.php
sed -i -e "s/localhost/$dbhost/g" wp-config.php

# insert new lines at correct position
if [ -n "$wp_url" ]; then
  line1="define('WP_HOME','$wp_url');"
  line2="define('WP_SITEURL','$wp_url');"
  ln=$(($(grep -n -m 1 '*/' ./wp-config.php |sed  's/\([0-9]*\).*/\1/')+1))
  sed -i "20i$line2" wp-config.php
  sed -i "20i$line1" wp-config.php
fi

# sync to correct directory
sudo rsync -avP ~/wordpress/ /var/www/html/
sudo rm -f /var/www/html/index.html #remove old apache default index html file

cd /var/www/html
sudo chown -R ubuntu:www-data *
sudo mkdir /var/www/html/wp-content/uploads
sudo chown -R :www-data /var/www/html/wp-content/uploads

# restart apache
sudo service apache2 restart

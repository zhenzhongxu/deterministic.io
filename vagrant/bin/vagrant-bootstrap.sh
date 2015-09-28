#!/usr/bin/env bash

# run locally stored secret env vars
source /vagrant/local/secretes.sh

# install components
sudo apt-get update

# install apache
sudo apt-get install -y --force-yes apache2

# install php
sudo apt-get install -y --force-yes php5 libapache2-mod-php5 php5-mcrypt php5-gd libssh2-php php5-mysql php5-curl

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
  line3="define('AWS_ACCESS_KEY_ID','$AWS_KEY');"
  line4="define('AWS_SECRET_ACCESS_KEY','$AWS_SECRET');"
  ln=$(($(grep -n -m 1 '*/' ./wp-config.php |sed  's/\([0-9]*\).*/\1/')+1))
  sed -i "20i$line4" wp-config.php
  sed -i "20i$line3" wp-config.php
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
sudo chmod 777 /var/www/html/wp-content/uploads

# restart apache
sudo service apache2 restart

# install wp-cli
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
# update all wp plugins
wp plugin update --path=/var/www/html --all
wp plugin install google-analytics-for-wordpress --path=/var/www/html
wp plugin install amazon-web-services  --path=/var/www/html
wp plugin install amazon-s3-and-cloudfront --path=/var/www/html
wp plugin install wordpress-mobile-pack --path=/var/www/html
wp plugin activate --path=/var/www/html --all

# install theme
wp theme install Cannyon --path=/var/www/html
wp theme install spacious --path=/var/www/html
wp theme install catch-evolution --path=/var/www/html

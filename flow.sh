#!/bin/bash -e
clear
echo "============================================"
echo "Install Wordpress, Underscores & Avalanche"
echo "============================================"
echo "Site Name: "
read -e sname
echo "Enter Pluto Password: "
read -e plutoPassword
echo "run install? (y/n)"
read -e run
if [ "$run" == n ] ; then
exit
else
echo "============================================"
echo "Our AI is now installing things."
echo "============================================"

#ssh admin@10.0.0.73

#Setting up directories and permission

mkdir "$sname".pixelpreview.net

cd "$sname".pixelpreview.net

mkdir config
mkdir public

cd public
mkdir htdocs

sudo chown admin:www-data htdocs

sudo chown -R www-data:www-data htdocs/*

sudo chmod -R 664 htdocs

sudo chmod -R +X htdocs

cd htdocs

#download wordpress
curl -O https://wordpress.org/latest.tar.gz
#unzip wordpress
tar -zxvf latest.tar.gz
#change dir to wordpress
cd wordpress
#copy file to parent dir
cp -rf . ..
#move back to parent dir
cd ..
#remove files from wordpress folder
rm -R wordpress
#create wp config

#generate password  
dbpws=$RANDOM

cp wp-config-sample.php wp-config.php
#set database details with perl find and replace
perl -pi -e "s/database_name_here/wp_$sname/g" wp-config.php
perl -pi -e "s/username_here/wp_$sname/g" wp-config.php
perl -pi -e "s/password_here/$dbpws/g" wp-config.php

#set WP salts
perl -i -pe'
  BEGIN {
    @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);
    push @chars, split //, "!@#$%^&*()-_ []{}<>~\`+=,.;:/?|";
    sub salt { join "", map $chars[ rand @chars ], 1 .. 64 }
  }
  s/put your unique phrase here/salt()/ge
' wp-config.php

#create uploads folder and set permissions
mkdir wp-content/uploads

chmod 775 wp-content/uploads
echo "Cleaning..."
#remove zip file
rm latest.tar.gz

cd wp-content/themes

#Clone Underscores theme
git clone https://github.com/rshahin/pixeleton.git
#change dir to underscores
mv pixeleton $sname-theme

cd $sname-theme/assets/scss
curl -O https://raw.githubusercontent.com/colourgarden/avalanche/master/_avalanche.scss

cd ../..
perl -pi -e "s/theme_name_here/$sname-theme/g" style.css
perl -pi -e "s/theme_name_here/$sname-theme/g" gulpfile.js

rm style.css.bak
rm gulpfile.js.bak


#remove bash script
cd ../../..
rm flow.sh

set -e

mysql -u root -p"$plutoPassword"  <<MYSQL_SCRIPT
CREATE DATABASE wp_$sname;
CREATE USER 'wp_$sname'@'localhost' IDENTIFIED BY '$dbpws';
GRANT ALL PRIVILEGES ON wp_$sname.* TO 'wp_$sname'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

echo "MySQL db/user created."
echo "Username:   wp_$sname"
echo "Password:   $dbpws"



echo "========================="
echo "Job Done."
echo "========================="
fi
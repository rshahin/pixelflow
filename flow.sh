#!/bin/bash -e
clear
echo "============================================"
echo "Install Wordpress, Underscores & Avalanche"
echo "============================================"
echo "Database Name: "
read -e dbname
echo "Database User: "
read -e dbuser
echo "Database Password: "
read -s dbpass
echo "Theme Name: "
read -e tname
echo "run install? (y/n)"
read -e run
if [ "$run" == n ] ; then
exit
else
echo "============================================"
echo "Our AI is now installing things."
echo "============================================"
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
cp wp-config-sample.php wp-config.php
#set database details with perl find and replace
perl -pi -e "s/database_name_here/$dbname/g" wp-config.php
perl -pi -e "s/username_here/$dbuser/g" wp-config.php
perl -pi -e "s/password_here/$dbpass/g" wp-config.php

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
git clone https://github.com/Automattic/underscores.me.git
#change dir to underscores
mv underscores.me $tname
#move back to parent dir
cd $tname
#Make a scss dir for sass files
mkdir assets
#go into scss
cd assets

#create assets folders
mkdir scss
mkdir css
mkdir images
mkdir fonts

#Go into scss
cd scss

#download Avalanche.scc from Guthub
curl -O https://github.com/colourgarden/avalanche/blob/master/_avalanche.scss

#move back to theme dir
cd ../..

#remove js folder
rm -rf js

#Clone our gulp and package file
curl -O https://raw.githubusercontent.com/rshahin/pixelflow/master/gulpfile.js
curl -O https://raw.githubusercontent.com/rshahin/pixelflow/master/package.json

#Clone optimisation file into /inc
cd inc
curl -O https://raw.githubusercontent.com/AaronAMcGuire/Optimisation-Script/master/optimisation.php


#Add optimisation file to functions.php

cd ..
perl -e 'print "require (get_template_directory() . '\''/inc/optimisation.php'\'');"' >> functions.php

#remove bash script
cd ../../..
rm flow.sh

echo "========================="
echo "Job Done."
echo "========================="
fi

#!/bin/bash
# Check & grant sudo priviledges
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

# Intro Message
printf "\nThis script will setup Apache2 & UFW \n Set your Email Address & Domain Name (example.com) WITHOUT any Sub-domain (www.)\n"

# Get Domain name from user
read -p "Enter Your Domain Name: " -r DOMAIN
read -p "Enter Your Email ID: " -r EMAIL

# Update package lists and install required packages
sudo apt-get update
sudo apt-get install -y htop vim apache2 openssl ufw curl socat rsync

# Start required Services
sudo systemctl enable --now apache2
sudo systemctl enable --now ssh
sudo systemctl enable --now rsync
sudo systemctl enable --now ufw

# Setup UFW to allow ssh and Apache connections
sudo ufw allow 'WWW Full'
sudo ufw allow ssh
yes | sudo ufw enable

# Create required directories
sudo mkdir -p /var/www/"$DOMAIN"
sudo mkdir -p /root/Server

# Set correct permissions
sudo chown -R $USER:$USER /var/www/"$DOMAIN"
sudo chmod -R 755 /var/www/"$DOMAIN"

# Edit config files according to user input
sed -i "s/DOMAIN/$DOMAIN/g" apache-http.conf
sed -i "s/DOMAIN/$DOMAIN/g" apache-https.conf
sed -i "s/DOMAINSHOULDBECHANGED/$DOMAIN/g" apache-https.sh
sed -i "s/EMAILSHOULDBECHANGED/$EMAIL/g" apache-https.sh

# Copy required config to the right places
< apache-website.conf tee /var/www/"$DOMAIN"/index.html > /dev/null
< apache-http.conf sudo tee /etc/apache2/sites-available/"$DOMAIN".conf > /dev/null
mv apache-https.sh /root/Server/
mv apache-https.conf /root/Server/


# Verify and Enable apache config then restart it
sudo apache2ctl configtest
sudo a2ensite "$DOMAIN".conf
sudo a2dissite 000-default.conf
sudo a2enmod ssl
sudo systemctl restart apache2.service



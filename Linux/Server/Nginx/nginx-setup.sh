#!/bin/bash

# Check & grant sudo priviledges
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

# Intro Message
printf "\nThis script will setup Nginx & UFW \nFor starters, set your domain name (example.com) WITHOUT any Sub-domain (www.)\n"

# Get Domain Name from User
printf "\nEnter Your Domain Name: "
read -r DOMAIN

# Update & Install required Packages
printf "\nUpdating & Installing Required Packages...\n"
sudo apt-get update
sudo apt install -y git bc wget vim htop openssl curl socat rsync ufw nginx

# Start required Services
printf "\nStarting Systemd Services...\n"
sudo systemctl enable --now nginx
sudo systemctl enable --now ssh
sudo systemctl enable --now rsync
sudo systemctl enable --now ufw

# Setup UFW to allow ssh & Nginx
printf "\nSetting up UFW...\n"
sudo ufw allow ssh
sudo ufw allow 'Nginx Full'
yes | sudo ufw enable

# Create required directories
printf "\nCreating Required Directories...\n"
sudo mkdir -p /var/www/"$DOMAIN"
sudo mkdir -p /etc/nginx/includes
sudo mkdir -p /var/www/"$DOMAIN"/.well-known/acme-challenge/
sudo mkdir -p /root/Server

# Move https related files to root
printf "\nMoving https related files to root...\n"
sudo mv https-setup.sh /root/Server/
sudo mv https.conf /root/Server/

# Set appropriate directory permissions
printf "\nSetting Necessary Folder Permissions...\n"
sudo chown -R "$USER":"$USER" /var/www/"$DOMAIN"
sudo chmod -R 755 /var/www/"$DOMAIN"
sudo chown -R www-data:www-data /var/www/"$DOMAIN"/.well-known/acme-challenge/
sudo chmod -R 0555 /var/www/"$DOMAIN"/.well-known/acme-challenge/

# Copy required configuration to their appropriate places
printf "\nCopying required config files...\n"
< website.conf tee /var/www/"$DOMAIN"/index.html >/dev/null
< letsencrypt-webroot.conf sudo tee /etc/nginx/includes/letsencrypt-webroot >/dev/null
< http.conf sudo tee /etc/nginx/sites-available/"$DOMAIN" >/dev/null

# Symlink nginx config
printf "\nFinalizing Nginx Server Setup...\n"
sudo ln -s /etc/nginx/sites-available/"$DOMAIN" /etc/nginx/sites-enabled/

# Set nginx hash bucket size
sudo sed -i 's/# server_names_hash_bucket_size/server_names_hash_bucket_size/g' /etc/nginx/nginx.conf

# Check nginx config & restart it
printf "\nVerifying Nginx config...\n"
sudo nginx -t
printf "\nRestarting Nginx...\n"
sudo systemctl restart nginx

# Inform the user about running the https script
printf "\nChange to root user and run https-setup.sh stored inside the Server folder to get https support and complete the Setup.\n"

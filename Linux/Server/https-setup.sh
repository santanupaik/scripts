#!/bin/bash

# Check for root user
if [ "$EUID" -ne 0 ]
  then echo "Please run as root !!"
  exit
fi

# Intro Message
printf "\nThis script will setup https with Nginx \nFor starters: Set your Email Address & Domain Name (example.com) WITHOUT any Sub-domain (www.)\n"

# Get Email & Domain name from user
printf "\nEnter Your Email Address: "
read -r EMAIL
printf "\nEnter Your Domain Name: "
read -r DOMAIN

# Set the Present Working Directory
DIR=$(pwd)

# Install acme.sh client
printf "\nInstalling acme.sh client...\n"
curl https://get.acme.sh | sh -s email="$EMAIL"

# Creating required directories
printf "\nCreating the required Directories...\n"
mkdir -pv /var/log/nginx/"$DOMAIN"
mkdir -pv /etc/nginx/ssl/"$DOMAIN"

# Generating dhparams for ssl
printf "\nGenerating dhparams for SSL...\n"
cd /etc/nginx/ssl/"$DOMAIN" || exit
openssl dhparam -out dhparams.pem -dsaparam 4096
cd "$DIR" || exit

# Issue an ssl/tls Certificate from LetsEncrypt
printf "\nIssuing TLS Certificate...\n"
bash /root/.acme.sh/acme.sh \
--issue -d "$DOMAIN" \
-d www."$DOMAIN" \
-w /var/www/"$DOMAIN" \
-k 4096 --server letsencrypt --force

# Copy https config to required place
printf "\nCopying https config...\n"
< https.conf tee /etc/nginx/sites-available/"$DOMAIN" >/dev/null

# Verify Nginx config
printf "Verifying Nginx Config..."
nginx -t

# Install the ssl/tls certificate in Nginx & reload it
printf "\nInstalling the TLS Certificate...\n"
bash /root/.acme.sh/acme.sh \
--install-cert -d "$DOMAIN" \
--cert-file /etc/nginx/ssl/"$DOMAIN"/cert \
--key-file /etc/nginx/ssl/"$DOMAIN"/key \
--fullchain-file /etc/nginx/ssl/"$DOMAIN"/fullchain \
--reloadcmd "systemctl reload nginx.service"


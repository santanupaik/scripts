#!/bin/bash

# Check for root user
if [ "$EUID" -ne 0 ]
  then echo "Please run as root !!"
  exit
fi

# Variables
DOMAIN=DOMAINSHOULDBECHANGED
EMAIL=EMAILSHOULDBECHANGED

# Get user confirmation for stored variables
printf "\nStored credentials:\n"
printf "\nDomain: %s\n" "$DOMAIN"
printf "Email: %s\n\n" "$EMAIL"

read -p "Are the Stored Credentials Correct ? (y/n): " -r ans
case $ans in
    [Yy]* ) printf "Great ! Proceeding with installation..."
            ;;
            
    [Nn]* ) echo
            read -p "Enter Your Email: " -r EMAIL
	    read -p "Enter Your Domain: " -r DOMAIN
	    ;;
	    
    * )     echo "Please re-run the script and answer in (y)es or (n)o."
    	    exit 0
    	    ;;
esac

# Intro Message
printf "\nThis script will setup https with Nginx \n"

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
--issue \
-d "$DOMAIN" \
-d www."$DOMAIN" \
-w /var/www/"$DOMAIN" \
-k 4096 \
--server letsencrypt

# Copy https config to required place
printf "\nCopying https config...\n"
< nginx-https.conf tee /etc/nginx/sites-available/"$DOMAIN" >/dev/null

# Install the ssl/tls certificate in Nginx & reload it
printf "\nInstalling the TLS Certificate...\n"
bash /root/.acme.sh/acme.sh \
--install-cert -d "$DOMAIN" \
--cert-file /etc/nginx/ssl/"$DOMAIN"/"$DOMAIN".cert \
--key-file /etc/nginx/ssl/"$DOMAIN"/"$DOMAIN".key \
--fullchain-file /etc/nginx/ssl/"$DOMAIN"/"$DOMAIN".fullchain \
--reloadcmd "systemctl restart nginx.service"


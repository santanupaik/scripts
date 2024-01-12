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
printf "\nThis script will setup https with Apache \n"

# Make required directory
printf "\nCreating required directories..."
mkdir -p /etc/apache2/2.2/ssl

# Download and Install acme.sh client for https setup
printf "\nInstalling acme.sh client..."
curl https://get.acme.sh | sh -s email="$EMAIL"

# Issue the SSL/TLS certificate from LetsEncrypt
printf "\nIssuing SSL/TLS certificate from LetsEncrypt..."
bash /root/.acme.sh/acme.sh \
--issue \
-d "$DOMAIN" \
-d www."$DOMAIN" \
-w /var/www/"$DOMAIN" \
-k 4096 \
--server letsencrypt

# Copy https config to the right place
printf "\nCopying https config to the right place..."
< apache-https.conf tee /etc/apache2/sites-available/"$DOMAIN".conf > /dev/null

# Install the SSL/TLS certificate and restart Apache
printf "\nInstalling SSL/TLS certificate..."
bash /root/.acme.sh/acme.sh \
--install-cert -d "$DOMAIN" \
--cert-file /etc/apache2/2.2/ssl/"$DOMAIN".cert \
--key-file /etc/apache2/2.2/ssl/"$DOMAIN".key \
--fullchain-file /etc/apache2/2.2/ssl/"$DOMAIN".fullchain \
--reloadcmd "systemctl restart apache2.service"

# Final message, please check the config files once yourself
printf "\nSetup Successful ! Your website should have HTTPS now ! \nPlease check the config files just to be sure."


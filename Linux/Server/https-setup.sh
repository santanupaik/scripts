#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root !!"
  exit
fi
echo
echo "This script will setup Nginx & UFW"
echo "For starters: Set your Email Address & Domain Name (example.com) WITHOUT any Sub-domain (www.)"
echo
printf "Enter Your Email Address: "
read EMAIL
echo
printf "Enter Your Domain Name: "
read DOMAIN
echo
DIR=$(pwd)
curl https://get.acme.sh | sh -s email=$EMAIL
mkdir -pv /var/log/nginx/$DOMAIN
mkdir -pv /etc/nginx/ssl/$DOMAIN
cd /etc/nginx/ssl/$DOMAIN
openssl dhparam -out dhparams.pem -dsaparam 4096
cd $DIR
bash /root/.acme.sh/acme.sh \
--issue -d itnerd.dev \
-d www.itnerd.dev \
-w /var/www/itnerd.dev \
-k 4096 --server letsencrypt
< https.conf tee /etc/nginx/sites-available/$DOMAIN >/dev/null
nginx -t
bash /root/.acme.sh/acme.sh \
--install-cert -d $DOMAIN \
--cert-file /etc/nginx/ssl/$DOMAIN/cert \
--key-file /etc/nginx/ssl/$DOMAIN/key \
--fullchain-file /etc/nginx/ssl/$DOMAIN/fullchain \
--reloadcmd "systemctl reload nginx.service"


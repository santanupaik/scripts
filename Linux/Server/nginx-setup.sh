echo
echo "This script will setup Nginx & UFW"
echo "For starters, set your domain name (example.com) WITHOUT any Sub-domain (www.)"
echo
printf "Enter Your Domain Name: "
read DOMAIN
echo
sudo apt-get update
sudo apt install git bc wget vim htop openssl curl socat rsync ufw nginx
sudo systemctl enable --now nginx
sudo systemctl enable --now ssh
sudo systemctl enable --now rsync
sudo systemctl enable --now ufw
sudo ufw allow ssh
sudo ufw allow 'Nginx Full'
sudo ufw enable
sudo mkdir -p /var/www/$DOMAIN
sudo mkdir -p /etc/nginx/includes
sudo mkdir -p /var/www/$DOMAIN/.well-known/acme-challenge/
sudo mkdir -p /root/Server
sudo mv https-setup.sh /root/Server/
sudo mv https.conf /root/Server/
sudo chown -R $USER:$USER /var/www/$DOMAIN
sudo chmod -R 755 /var/www/$DOMAIN
sudo chown -R www-data:www-data /var/www/$DOMAIN/.well-known/acme-challenge/
sudo chmod -R 0555 /var/www/$DOMAIN/.well-known/acme-challenge/
< website.conf tee /var/www/$DOMAIN/index.html >/dev/null
< letsencrypt-webroot.conf sudo tee /etc/nginx/includes/letsencrypt-webroot >/dev/null
< http.conf sudo tee /etc/nginx/sites-available/$DOMAIN >/dev/null
sudo ln -s /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/
sudo sed -i 's/# server_names_hash_bucket_size/server_names_hash_bucket_size/g' /etc/nginx/nginx.conf
sudo nginx -t
sudo systemctl restart nginx


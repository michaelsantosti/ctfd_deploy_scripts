#! /bin/sh

#Stop nginx
docker stop ctfd_nginx_1

#Check Certificate
certbot renew --cert-name CTFD_DOMAIN_ADDR

#Copy Certificates
sudo cp /etc/letsencrypt/live/CTFD_DOMAIN_ADDR/fullchain.pem .data/certbot/conf/live/CTFD_DOMAIN_ADDR/fullchain.pem
sudo cp /etc/letsencrypt/live/CTFD_DOMAIN_ADDR/privkey.pem .data/certbot/conf/live/CTFD_DOMAIN_ADDR/privkey.pem

#Start nginx
docker start ctfd_nginx_1

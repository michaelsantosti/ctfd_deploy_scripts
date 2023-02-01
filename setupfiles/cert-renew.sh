#!/bin/bash

#Get Certificate Expiration Date
CertEx=`openssl x509 -in /etc/letsencrypt/live/CTFD_DOMAIN_ADDR/fullchain.pem -inform PEM -noout -enddate`

#Convert Date to MM-DD-YYYY
dateStr=${CertEx/notAfter=/}
CertExpires=`date --date="$dateStr" --utc +"%m-%d-%Y"`

#Get Today Date and add +30 days
TodayPlus15=`date -ud "+15 day" --utc +"%m-%d-%Y"`

# Check if certificate will expire in 30 days
if [ "$CertExpires" = "$TodayPlus15" ]
then
echo Certificate Expires on: $CertExpires
echo 
echo Your SSL Cert will expire in 15 days.
echo

#Stop nginx
docker stop ctfd_nginx_1

#Check Certificate
certbot renew --cert-name CTFD_DOMAIN_ADDR

#Copy Certificates
sudo cp /etc/letsencrypt/live/CTFD_DOMAIN_ADDR/fullchain.pem .data/certbot/conf/live/CTFD_DOMAIN_ADDR/fullchain.pem
sudo cp /etc/letsencrypt/live/CTFD_DOMAIN_ADDR/privkey.pem .data/certbot/conf/live/CTFD_DOMAIN_ADDR/privkey.pem

#Start nginx
docker start ctfd_nginx_1

fi

#Well, everything is ok!
echo
echo Certificate OK!
echo
echo Certificate Expires on: $CertExpires
echo
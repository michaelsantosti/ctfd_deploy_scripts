#! /bin/sh

#############################
##                         ##
#     CTFd Docker Setup     #
#      Michael Santosti     #
##                         ##
#############################

#Set Working Directory
DIR_NAME="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd ${DIR_NAME}
clear
echo 
echo Working Directory: $DIR_NAME
echo 

# Catching Domain Name
echo Insira o dominio do CTFd:
read domainctfd

#Create Certificates
sudo certbot certonly -n --standalone --agree-tos -d $domainctfd 

# Copy config files
cp ./setupfiles/* .

#Copy Certificates
sudo cp /etc/letsencrypt/live/$domainctfd/fullchain.pem .data/certbot/conf/live/$domainctfd/fullchain.pem
sudo cp /etc/letsencrypt/live/$domainctfd/privkey.pem .data/certbot/conf/live/$domainctfd/privkey.pem

#Add Domain to necessary files
sudo sed -i 's|CTFD_DOMAIN_ADDR|'"$domainctfd"'|g' nginx.conf
sudo sed -i 's|CTFD_DOMAIN_ADDR|'"$domainctfd"'|g' cert-renew.sh

#Create cron to docker certificate renew
sudo sed -i 's|WORKDIR|'"$DIR_NAME"'|g' cron_certdocker
cp cron_certdocker /etc/cron.d/certbot  

#Default Permissions
sudo chown -R 755 .
sudo chown -R www-data:www-data .

#Compose Docker
sudo docker-compose -f docker-compose.yml -f docker-compose-production.yml up -d

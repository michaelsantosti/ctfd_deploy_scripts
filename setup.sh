#! /bin/sh
clear
cat <<EOF

                _________              __                  __  .__
               /   _____/____    _____/  |_  ____  _______/  |_|__|
               \_____  \__   \  /    \   __\/  _ \/  ___/\   __\  |
               /        \/ __ \|   |  \  | (  <_> )___ \  |  | |  |
              /_______  (____  /___|  /__|  \____/____  > |__| |__|
 =====================\/=====\/=====\/================\/=======================
                           CTFd Wargames Deploy Script
 ==============================================================================
   Date............ 05/14/2023              Version....... V1.5-SSL
   By.............. Michael Santosti        Target........ CTFd
 ==============================================================================

EOF

#Set Working Directory
DIR_WORK="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Bind a Work Directory
DIR_CTFD=${DIR_WORK}/CTFd
echo
echo Working Directory: ${DIR_CTFD}

# Catching Domain Name
echo 
echo "Insert CTFd domain address (example.com):"
read domainctfd
echo 
echo "Insert valid email (example@example.com):"
read domainemail

#Create Certificates
sudo certbot certonly -n --standalone --agree-tos -d $domainctfd  --email $domainemail

# Copy config files
sudo cp -r ./setupfiles/* ${DIR_CTFD}/

#Create Certificates Directory
sudo mkdir -p ${DIR_CTFD}/.data/certbot/conf/live/$domainctfd/

#Copy Certificates
sudo cp /etc/letsencrypt/live/$domainctfd/fullchain.pem ${DIR_CTFD}/.data/certbot/conf/live/$domainctfd/fullchain.pem
sudo cp /etc/letsencrypt/live/$domainctfd/privkey.pem ${DIR_CTFD}/.data/certbot/conf/live/$domainctfd/privkey.pem

#Add Domain to necessary files
sudo sed -i 's|CTFD_DOMAIN_ADDR|'"$domainctfd"'|g' ${DIR_CTFD}/nginx.conf
sudo sed -i 's|CTFD_DOMAIN_ADDR|'"$domainctfd"'|g' ${DIR_CTFD}/hooks/ctfd_pre.sh
sudo sed -i 's|CTFD_DOMAIN_ADDR|'"$domainctfd"'|g' ${DIR_CTFD}/hooks/ctfd_post.sh

#Import hooks to the certbot renew
sudo cp ${DIR_CTFD}/hooks/ctfd_pre.sh /etc/letsencrypt/renewal-hooks/pre/ctfd_pre.sh
sudo cp ${DIR_CTFD}/hooks/ctfd_post.sh /etc/letsencrypt/renewal-hooks/post/ctfd_post.sh

#Default Permissions
sudo chown -R 755 ${DIR_CTFD}
sudo chown -R www-data:www-data ${DIR_CTFD}

#Compose Docker
cd ${DIR_CTFD}
sudo docker-compose -f docker-compose.yml -f docker-compose-production.yml up -d

#! /bin/sh

#############################
##                         ##
#     CTFd Docker Setup     #
#      Michael Santosti     #
##                         ##
#############################



#Set Working Directory
DIR_WORK="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

#Download CTFd
git clone --single-branch https://github.com/CTFd/CTFd.git CTFd

#Install Requirements
sudo apt-get update -y
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y

#Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
echo ""
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo usermod -aG docker ubuntu

#Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.15.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

#Install Certbot
sudo apt-get update -y
sudo apt-get install certbot -y

# Bind a Work Directory
DIR_CTFD=${DIR_WORK}/CTFd
clear
echo 
echo Working Directory: ${DIR_CTFD}

# Catching Domain Name
echo 
echo Insert CTFd domain address (example.com):
read domainctfd
echo 
echo Insert valid email (example@example.com):
read domainemail

#Create Certificates
sudo certbot certonly -n --standalone --agree-tos -d $domainctfd  -email $domainemail

# Copy config files
sudo chmod 777 CTFd
sudo cp ./setupfiles/* ${DIR_CTFD}/

#Create Certificates Directory
sudo mkdir -p ${DIR_CTFD}/.data/certbot/conf/live/$domainctfd/

#Copy Certificates
sudo cp /etc/letsencrypt/live/$domainctfd/fullchain.pem ${DIR_CTFD}/.data/certbot/conf/live/$domainctfd/fullchain.pem
sudo cp /etc/letsencrypt/live/$domainctfd/privkey.pem ${DIR_CTFD}/.data/certbot/conf/live/$domainctfd/privkey.pem

#Add Domain to necessary files
sudo sed -i 's|CTFD_DOMAIN_ADDR|'"$domainctfd"'|g' ${DIR_CTFD}/nginx.conf
sudo sed -i 's|CTFD_DOMAIN_ADDR|'"$domainctfd"'|g' ${DIR_CTFD}/cert-renew.sh

#Create cron to docker certificate renew
sudo sed -i 's|WORKDIR|'"$DIR_NAME"'|g' ${DIR_CTFD}/cron_certdocker
cp ${DIR_CTFD}/cron_certdocker /etc/cron.d/certbot  

#Default Permissions
sudo chown -R 755 ${DIR_CTFD}
sudo chown -R www-data:www-data ${DIR_CTFD}
sudo chmod +x ${DIR_CTFD}/cert-renew.sh

#Compose Docker
cd ${DIR_CTFD}
sudo docker-compose -f docker-compose.yml -f docker-compose-production.yml up -d

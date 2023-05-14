#! /bin/sh
clear
cat <<EOF

                _________              __                  __  .__
               /   _____/____    _____/  |_  ____  _______/  |_|__|
               \_____  \__   \  /    \   __\/  _ \/  ___/\   __\  |
               /        \/ __ \|   |  \  | (  <_> )___ \  |  | |  |
              /_______  (____  /___|  /__|  \____/____  > |__| |__|
 =====================\/=====\/=====\/================\/=======================
                               CTFd Deploy Script
 ==============================================================================
   Date............ 02/01/2023              Version....... V1.5-NOSSL
   By.............. Michael Santosti        Target........ CTFd
 ==============================================================================

EOF

#Set Working Directory
DIR_WORK="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Bind a Work Directory
DIR_CTFD=${DIR_WORK}/CTFd
echo 
echo Working Directory: ${DIR_CTFD}

#Download CTFd
sudo git clone --single-branch https://github.com/CTFd/CTFd.git CTFd

#Download Themes
sudo git clone https://github.com/0xdevsachin/CTFD-crimson-theme.git CTFd/CTFd/themes/crimson
sudo git clone https://github.com/hmrserver/CTFd-theme-pixo.git CTFd/CTFd/themes/pixo
sudo git clone https://github.com/0xdevsachin/CTFD-odin-theme.git CTFd/CTFd/themes/odin
sudo git clone https://github.com/iver-ics/CTFd-xmas-theme.git CTFd/CTFd/themes/xmas
sudo git clone https://github.com/chainflag/ctfd-neon-theme.git CTFd/CTFd/themes/neon
sudo git clone https://github.com/AaronVigal/nullify-ctfd-theme.git && sudo mv ./nullify-ctfd-theme/nullify/ CTFd/CTFd/themes/ && sudo rm -rf nullify-ctfd-theme/

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
DCVERSION=$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*\d')
sudo curl -L "https://github.com/docker/compose/releases/download/${DCVERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

# Copy config files
sudo cp -r ./setupfiles/* ${DIR_CTFD}/

#Default Permissions
sudo chown -R 755 ${DIR_CTFD}
sudo chown -R www-data:www-data ${DIR_CTFD}

#Compose Docker
cd ${DIR_CTFD}
sudo docker-compose -f docker-compose.yml -f docker-compose-homol.yml up -d

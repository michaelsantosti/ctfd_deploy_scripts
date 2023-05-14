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
   Date............ 05/14/2023              Version....... V1.5-UPD
   By.............. Michael Santosti        Target........ CTFd
 ==============================================================================

EOF

#Set Working Directory
DIR_WORK="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Bind a Work Directory
DIR_CTFD=${DIR_WORK}/CTFd
echo
echo Working Directory: ${DIR_CTFD}

#Change to Directory
cd ${DIR_CTFD}

#Pull updates
sudo git config --global --add safe.directory ${DIR_CTFD}
git pull

#Remove old CTFd
sudo docker stop $(sudo docker ps -a -q) && sudo docker rm $(sudo docker ps -a -q)

#Default Permissions
sudo chown -R 755 ${DIR_CTFD}
sudo chown -R www-data:www-data ${DIR_CTFD}

#Compose Docker
sudo docker-compose -f docker-compose.yml -f docker-compose-homol.yml up -d

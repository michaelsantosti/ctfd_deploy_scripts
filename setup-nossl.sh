#! /bin/sh

cat <<EOF

                _________              __                  __  .__
               /   _____/____    _____/  |_  ____  _______/  |_|__|
               \_____  \__   \  /    \   __\/  _ \/  ___/\   __\  |
               /        \/ __ \|   |  \  | (  <_> )___ \  |  | |  |
              /_______  (____  /___|  /__|  \____/____  > |__| |__|
 =====================\/=====\/=====\/================\/=======================
                           CTFd Wargames Deploy Script
 ==============================================================================
   Date............ 05/14/2023              Version....... V1.5-NOSSL
   By.............. Michael Santosti        Target........ CTFd
 ==============================================================================

EOF

#Set Working Directory
DIR_WORK="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Bind a Work Directory
DIR_CTFD=${DIR_WORK}/CTFd
clear
echo 
echo Working Directory: ${DIR_CTFD}

# Copy config files
sudo cp ./setupfiles/* ${DIR_CTFD}/

#Default Permissions
sudo chown -R 755 ${DIR_CTFD}
sudo chown -R www-data:www-data ${DIR_CTFD}

#Compose Docker
cd ${DIR_CTFD}
sudo docker-compose -f docker-compose.yml -f docker-compose-homol.yml up -d

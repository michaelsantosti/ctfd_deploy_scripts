#!/bin/bash
#
#                _________              __                  __  .__
#               /   _____/____    _____/  |_  ____  _______/  |_|__|
#               \_____  \__   \  /    \   __\/  _ \/  ___/\   __\  |
#               /        \/ __ \|   |  \  | (  <_> )___ \  |  | |  |
#              /_______  (____  /___|  /__|  \____/____  > |__| |__|
# =====================\/=====\/=====\/================\/=======================
#                               CTFd Deploy Script
# ==============================================================================
#   Date............ 05/14/2023              Version....... V1.5-SSL
#   By.............. Michael Santosti        Target........ CTFd
# ==============================================================================
#

sudo cp /etc/letsencrypt/live/CTFD_DOMAIN_ADDR/fullchain.pem .data/certbot/conf/live/CTFD_DOMAIN_ADDR/fullchain.pem
sudo cp /etc/letsencrypt/live/CTFD_DOMAIN_ADDR/privkey.pem .data/certbot/conf/live/CTFD_DOMAIN_ADDR/privkey.pem
sudo docker start ctfd-nginx-1

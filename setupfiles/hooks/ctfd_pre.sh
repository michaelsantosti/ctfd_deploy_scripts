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
echo Stop NGINX docker - Free Port 80
sudo docker stop ctfd-nginx-1

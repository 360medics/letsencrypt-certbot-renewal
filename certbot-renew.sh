#!/usr/bin/env bash
# Author: Romain Bruckert
# https://kvz.io/blog/2013/11/21/bash-best-practices/
# 

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

domains="$1"

if [ -z "$domains" ]
then
    echo -e "${RED}Invalid domains given as 1st argument: ${NC}"
    exit 1
fi

echo -e "${YELLOW}Renewing certificate for domains: ${domains}${NC}"
sudo certbot certonly \
-a webroot \
--webroot-path /var/www/html/letsencrypt \
-d ${domains} \
--server https://acme-v02.api.letsencrypt.org/directory \
--agree-tos --renew-by-default

sudo service nginx reload
echo -e "${GREEN}Done.${NC}"
exit 0
#!/bin/bash

# ------------------------------------------------

HOSTS_FILE="/etc/hosts"

if [ $# -eq 0 ]
  then
    echo "No arguments supplied, usage: hosts.sh <domain.tld>"
    exit
fi

DOMAIN=$1

echo "127.0.0.1 $DOMAIN www.$DOMAIN" >> $HOSTS_FILE

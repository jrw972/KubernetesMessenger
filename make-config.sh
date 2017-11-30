#!/bin/bash

PUBLIC_IP=$(ip -o -f inet address show scope global | head -n1 | awk '{print $4;}' | cut -d'/' -f1)
sed -e "s/_PUBLIC_IP_/${PUBLIC_IP}/g" config.ini.in > config.ini

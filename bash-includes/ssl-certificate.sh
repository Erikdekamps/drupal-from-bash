#!/bin/sh
# This script will do stuff.

# Load environment variables
. .env > /dev/null

openssl genrsa 4096 \
| tee ./${DOMAIN}.localhost/docker/proxy/cert.key \
| openssl req -new -subj "/CN=${DOMAIN}.localhost" -key /dev/stdin -config ./${DOMAIN}.localhost/docker/conf/${DOMAIN}.conf \
| openssl x509 -req -days 3650 -in /dev/stdin -signkey ./${DOMAIN}.localhost/docker/proxy/cert.key -extensions v3_req -extfile ./${DOMAIN}.localhost/docker/conf/${DOMAIN}.conf \
> ./${DOMAIN}.localhost/docker/proxy/cert.crt

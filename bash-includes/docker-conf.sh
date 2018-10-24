#!/bin/sh
# This script will do stuff.

# Load environment variables
. .env > /dev/null

# Create the config file.
echo "Creating /docker/conf/${DOMAIN}.conf ..."
touch ${DOMAIN}.localhost/docker/conf/${DOMAIN}.conf

# Write the contents to the conf file.
cat > ${DOMAIN}.localhost/docker/conf/${DOMAIN}.conf <<EOL
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req

[req_distinguished_name]
commonName = ${DOMAIN}.localhost

[ v3_req ]
# Extensions to add to a certificate request
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = ${DOMAIN}.localhost
EOL

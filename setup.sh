#!/bin/sh
# This script will do stuff.

# !) Temp.
rm -rf docker

# Read the user input.
echo "Type the domain prefix, followed by [ENTER]:"
read DOMAIN

# Write the domain to the .env file.
echo "DOMAIN=${DOMAIN}" >> .env

################################################################################
# Create the project with composer.
################################################################################

echo "Creating composer project, please wait ..."
composer create-project drupal-composer/drupal-project:8.x-dev ${DOMAIN}.localhost --stability dev --no-interaction

# Create the docker directories.
echo "Creating the docker directories ..."
mkdir -p ${DOMAIN}.localhost/docker/{conf,database,proxy,web}

################################################################################
# conf/[DOMAIN].conf
################################################################################

source ./bash-includes/docker-conf.sh

################################################################################
# database/mysqld.cnf
################################################################################

source ./bash-includes/database-mysql.sh

################################################################################
# docker/proxy/nginx.conf
################################################################################

source ./bash-includes/docker-proxy.sh

################################################################################
# docker/web/development.services.yml
################################################################################

source ./bash-includes/development-services.sh

# Create other files. TODO:
touch ${DOMAIN}.localhost/docker/web/php.ini-dev
touch ${DOMAIN}.localhost/docker/web/settings.dev.php
touch ${DOMAIN}.localhost/docker/web/settings.live.php
touch ${DOMAIN}.localhost/docker/web/settings.local.php

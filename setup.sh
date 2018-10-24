#!/bin/sh
# This script will do stuff.

# Read the user input.
echo "Type the domain prefix, followed by [ENTER]:"
read DOMAIN

# Write the domain to the .env file.
rm -rf .env
echo "DOMAIN=${DOMAIN}" >> .env

################################################################################
# Create the project with composer.
################################################################################

echo "Creating composer project, please wait ..."
composer create-project drupal-composer/drupal-project:8.x-dev ${DOMAIN}.localhost --stability dev --no-interaction

# Create the docker directories.
echo "Creating the docker directories ..."
mkdir -p ${DOMAIN}.localhost/docker/{conf,database,proxy,web}

# Create the [DOMAIN].localhost/docker/conf/[DOMAIN].conf file.
source ./bash-includes/docker-conf.sh

# Create the [DOMAIN].localhost/docker/database/mysqld.cnf file.
source ./bash-includes/database-mysql.sh

# Create the [DOMAIN].localhost/docker/proxy/nginx.conf file.
source ./bash-includes/docker-proxy.sh

# Create the [DOMAIN].localhost/docker/web/development.services.yml file.
source ./bash-includes/development-services.sh

# Create the [DOMAIN].localhost/config directory.
source ./bash-includes/drupal-config.sh

################################################################################
# composer install (WIP).
################################################################################

#composer install

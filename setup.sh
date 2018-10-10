#!/bin/sh
# This script will do stuff.

# Create the docker directories.
mkdir -p ./docker/{conf,database,proxy,scripts,web}

# Read the user input.
echo "Type the site name, followed by [ENTER]:"
read site_name

# Create the config file.
touch ./docker/conf/${site_name}.conf

# Create the database file.
touch ./docker/database/mysqld.cnf

# Create the nginx file.
touch ./docker/proxy/nginx.conf

# Create the script for adding to hosts file.
touch ./docker/scripts/add-to-hosts-file.sh

# Create the web files.
touch ./docker/web/development.services.yml
touch ./docker/web/php.ini-dev
touch ./docker/web/settings.dev.php
touch ./docker/web/settings.live.php
touch ./docker/web/settings.local.php

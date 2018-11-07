#!/bin/sh
# This script will do stuff.

# Load environment variables
. .env > /dev/null

cat >> ${DOMAIN}.localhost/.env <<EOF
# The domain settings.
DOCKER_DOMAIN=${DOMAIN}.localhost
HOST_IP=127.0.0.1

# Database specific environment variables.
MYSQL_DATABASE=${DOMAIN}
MYSQL_ROOT_PASSWORD=123

# Apache specific
APACHE_LOG_LEVEL=debug
APACHE_BACKEND_HOST=php
APACHE_SERVER_ROOT=/var/www/html/web

# Drupal container "php" settings.
PHP_FPM_CLEAR_ENV=no
PHP_SENDMAIL_PATH='/usr/sbin/sendmail -t -i -S mailhog:1025'
DB_HOST=database
DB_USER=root
DB_DRIVER=mysql

# Php settings.
PHP_MAX_INPUT_TIME=300
PHP_MAX_EXECUTION_TIME=300
PHP_MEMORY_LIMIT='256M'
PHP_DOCROOT=web
EOF

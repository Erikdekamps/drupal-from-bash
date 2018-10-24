#!/bin/sh
# This script will do stuff.

# Load environment variables
. .env > /dev/null

# Create other files. TODO:
touch ${DOMAIN}.localhost/docker/web/php.ini-dev
touch ${DOMAIN}.localhost/docker/web/settings.dev.php
touch ${DOMAIN}.localhost/docker/web/settings.live.php
touch ${DOMAIN}.localhost/docker/web/settings.local.php

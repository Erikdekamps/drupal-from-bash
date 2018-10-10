#!/bin/sh
# This script will do stuff.

# Create the docker directories.
mkdir -p ./docker/{conf,database,proxy,scripts,web}

# Read the user input.
echo "Type the site name, followed by [ENTER]:"
read site_name

# Create the config file.
touch ./docker/conf/${site_name}.conf
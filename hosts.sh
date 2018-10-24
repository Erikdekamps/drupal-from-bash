#!/bin/sh
# This script will do stuff.
# !) Must be ran as root.

# Read the user input.
echo "Type the domain prefix, followed by [ENTER]:"
read DOMAIN

################################################################################
# Host file.
################################################################################

echo "Adding domain to /etc/hosts file ..."

# Set host file location.
hosts=/etc/hosts

echo "# ${DOMAIN}.localhost" >> $hosts
echo "127.0.0.1      ${DOMAIN}.localhost" >> $hosts

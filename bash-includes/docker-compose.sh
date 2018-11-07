#!/bin/sh
# This script will do stuff.

# Load environment variables
. .env > /dev/null

# Create the database file.
echo "Creating /docker-compose.yml ..."

touch ${DOMAIN}.localhost/docker-compose.yml

# Write to the docker-compose.yml.
cat >> ${DOMAIN}.localhost/docker-compose.yml <<EOF
# Minimal docker for ${DOMAIN}.localhost
version: '2'
services:
  proxy:
    networks:
      default:
    image: nginx:1.13.0-alpine
    container_name: "${DOMAIN}_nginx"
    depends_on:
      - php
    volumes:
      - ./docker/proxy/nginx.conf:/etc/nginx/nginx.conf
      - ./docker/proxy/cert.crt:/usr/share/ssl/cert.crt
      - ./docker/proxy/cert.key:/usr/share/ssl/cert.key
    ports:
      - 80:80
      - 443:443
  apache:
    networks:
      default:
    image: wodby/php-apache
    working_dir: "/var/www/html/web"
    volumes:
      - ./web:/var/www/html/web:delegated
    container_name: "${DOMAIN}_apache"
    depends_on:
      - php
    env_file:
      - ./.env
  php:
    networks:
      default:
    image: wodby/drupal-php
    container_name: "${DOMAIN}_php"
    volumes:
      - ./load.environment.php:/var/www/html/load.environment.php:delegated
      - ./web:/var/www/html/web:delegated
      - ./vendor:/var/www/html/vendor:delegated
      - ./docker/web/settings.local.php:/var/www/html/web/sites/default/settings.php:delegated
      - ./docker/web/php.ini-dev:/usr/local/etc/php/php.ini:delegated
      - ./config:/var/www/html/config:delegated
      - ./docker/web/development.services.yml:/var/www/html/web/sites/development.services.yml
      - ./scripts:/var/www/html/scripts
      - ./drush:/var/www/html/drush
      - ./composer.json:/var/www/html/composer.json
      - ./composer.lock:/var/www/html/composer.lock
      - ./tmp:/var/www/tmp
    env_file:
      - ./.env
  database:
    networks:
      default:
    image: mysql:5.7.18
    ports:
      - 3307:3306
    volumes:
      - ./docker/database:/docker-entrypoint-initdb.d:delegated
      - ./docker/database/mysqld.cnf:/etc/mysql/conf.d/mysqld.cnf:delegated
    container_name: "${DOMAIN}_database"
    env_file:
      - ./.env
  mailhog:
    networks:
      default:
    ports:
      - '8025:8025'
    image: mailhog/mailhog
    container_name: "${DOMAIN}_mailhog"

networks:
  default:
    driver: bridge
EOF

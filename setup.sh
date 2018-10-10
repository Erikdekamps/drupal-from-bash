#!/bin/sh
# This script will do stuff.

# !) Temp.
rm -rf docker

# Create the docker directories.
mkdir -p ./docker/{conf,database,proxy,scripts,web}

# Read the user input.
echo "Type the site name, followed by [ENTER]:"
read site_name

# Create the config file.
touch ./docker/conf/${site_name}.conf

################################################################################
# conf/[SITE_NAME].conf
################################################################################

# Write the contents to the conf file.
cat > ./docker/conf/${site_name}.conf <<EOL
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req

[req_distinguished_name]
commonName = ${site_name}.localhost

[ v3_req ]
# Extensions to add to a certificate request
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = ${site_name}.localhost
EOL

################################################################################
# database/mysqld.cnf
################################################################################

# Create the database file.
touch ./docker/database/mysqld.cnf

# Write to the mysqld.cnf.
cat > ./docker/database/mysqld.cnf <<EOL
[mysqld]
max_allowed_packet = 2G
innodb_data_file_path = ibdata1:10M:autoextend
innodb_temp_data_file_path=ibtmp1:12M:autoextend:max:2G
innodb_buffer_pool_size = 256M
innodb_log_buffer_size = 128M
innodb_log_file_size = 128M
innodb_write_io_threads = 16
innodb_flush_log_at_trx_commit = 0
wait_timeout=30000
EOL

################################################################################
# docker/proxy/nginx.conf
################################################################################

# Create the nginx file.
touch ./docker/proxy/nginx.conf

# Write to the file.
cat > ./docker/proxy/nginx.conf <<EOL
user  nginx;
worker_processes  1;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;

events {
  worker_connections  1024;
}

http {
  include       /etc/nginx/mime.types;
  default_type  application/octet-stream;
  proxy_buffer_size   128k;
  proxy_buffers   4 256k;
  proxy_connect_timeout       600;
  proxy_send_timeout          600;
  proxy_read_timeout          600;
  send_timeout                600;
  client_max_body_size        512M;

  log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
  '$status $body_bytes_sent "$http_referer" '
  '"$http_user_agent" "$http_x_forwarded_for"';

  access_log  /var/log/nginx/access.log  main;

  sendfile        on;
  #tcp_nopush     on;

  keepalive_timeout  65;

  server {
    # Change '${site_name}.localhost' to 'localhost' for local SW development
    set $domain '${site_name}.localhost';
    listen 80;
    listen [::]:80;
    location / {
      proxy_pass http://apache:80;
      proxy_set_header Host $domain;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Host $host:80;
      proxy_set_header X-Forwarded-Port 80;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header X-Url-Scheme: http;
      fastcgi_read_timeout 300;
    }
  }

  server {
    set $domain '${site_name}.localhost';
    listen 443 ssl;

    ssl_certificate /usr/share/ssl/cert.crt;
    ssl_certificate_key /usr/share/ssl/cert.key;

    location / {
      proxy_pass http://apache:80;
      proxy_set_header Host $domain;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Host $host:443;
      proxy_set_header X-Forwarded-Port 443;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header X-Url-Scheme: http;
      fastcgi_read_timeout 300;
    }
  }
}
EOL

################################################################################
# docker/web
################################################################################

# Create the script for adding to hosts file.
touch ./docker/scripts/add-to-hosts-file.sh

# Create the web files.
touch ./docker/web/development.services.yml
touch ./docker/web/php.ini-dev
touch ./docker/web/settings.dev.php
touch ./docker/web/settings.live.php
touch ./docker/web/settings.local.php

#!/bin/sh
# This script will do stuff.

# Load environment variables
. .env > /dev/null

# Create the nginx file.
echo "Creating /docker/proxy/nginx.conf ..."
touch ${DOMAIN}.localhost/docker/proxy/nginx.conf

# Write to the file.
cat > ${DOMAIN}.localhost/docker/proxy/nginx.conf <<EOF
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

  log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
  '\$status \$body_bytes_sent "\$http_referer" '
  '"\$http_user_agent" "\$http_x_forwarded_for"';

  access_log  /var/log/nginx/access.log  main;

  sendfile        on;
  #tcp_nopush     on;

  keepalive_timeout  65;

  server {
    # Change '${DOMAIN}.localhost' to 'localhost' for local SW development
    set \$domain '${DOMAIN}.localhost';
    listen 80;
    listen [::]:80;
    location / {
      proxy_pass http://apache:80;
      proxy_set_header Host \$domain;
      proxy_set_header X-Real-IP \$remote_addr;
      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Host \$host:80;
      proxy_set_header X-Forwarded-Port 80;
      proxy_set_header X-Forwarded-Proto \$scheme;
      proxy_set_header X-Url-Scheme: http;
      fastcgi_read_timeout 300;
    }
  }

  server {
    set \$domain '${DOMAIN}.localhost';
    listen 443 ssl;

    ssl_certificate /usr/share/ssl/cert.crt;
    ssl_certificate_key /usr/share/ssl/cert.key;

    location / {
      proxy_pass http://apache:80;
      proxy_set_header Host \$domain;
      proxy_set_header X-Real-IP \$remote_addr;
      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Host \$host:443;
      proxy_set_header X-Forwarded-Port 443;
      proxy_set_header X-Forwarded-Proto \$scheme;
      proxy_set_header X-Url-Scheme: http;
      fastcgi_read_timeout 300;
    }
  }
}
EOF

#!/bin/sh
# This script will do stuff.

# Load environment variables
. .env > /dev/null

# Create the database file.
echo "Creating /docker/database/mysqld.cnf ..."
touch ${DOMAIN}.localhost/docker/database/mysqld.cnf

# Write to the mysqld.cnf.
cat > ${DOMAIN}.localhost/docker/database/mysqld.cnf <<EOL
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

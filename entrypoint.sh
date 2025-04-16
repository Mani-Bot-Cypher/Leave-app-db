#!/bin/bash

set -e

echo "[INFO] Starting MySQL server..."

# Start MySQL server in the background
mysqld &

# Wait for MySQL to be ready
echo "[INFO] Waiting for MySQL to be ready..."
until mysqladmin ping -h "127.0.0.1" --silent; do
    sleep 2
done

echo "[INFO] MySQL is up and running."

# Run SQL initialization if file exists
if [ -f /docker-entrypoint-initdb.d/init.sql ]; then
    echo "[INFO] Running initialization SQL script..."
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" < /docker-entrypoint-initdb.d/init.sql
    echo "[INFO] Initialization script executed."
else
    echo "[INFO] No initialization script found."
fi

# Keep container running in foreground
echo "[INFO] Keeping MySQL in foreground..."
wait

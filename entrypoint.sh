#!/bin/bash

set -e

# Start MySQL in the background
echo "Starting MySQL in the background..."
mysqld_safe &

# Wait until MySQL is ready
echo "Waiting for MySQL to be ready..."
until mysqladmin ping --silent; do
    sleep 2
done

# Check if database already exists
if ! mysql -u root -proot -e "USE leaveapp;" 2>/dev/null; then
    echo "Initializing database from init.sql..."
    mysql -u root -proot < /docker-entrypoint-initdb.d/init.sql
    echo "Database initialized!"
else
    echo "Database already exists, skipping init.sql."
fi

# Bring MySQL to the foreground
echo "Bringing MySQL to the foreground..."
wait

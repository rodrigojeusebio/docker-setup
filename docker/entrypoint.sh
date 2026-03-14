#!/bin/sh

# Get user/group ID from environment variables, default to 1000
PUID=${PUID:-1000}
PGID=${PGID:-1000}

# Modify the www-data user and group to match your PC's user
groupmod -o -g "$PGID" www-data
usermod -o -u "$PUID" -g www-data www-data

# Ensure Nginx has access to its required folders
chown -R www-data:www-data /var/lib/nginx /var/log/nginx /run/nginx

# Hand off control to the CMD in the Dockerfile (Supervisord)
exec "$@"
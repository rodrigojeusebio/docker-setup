#!/bin/bash

# Exit immediately if any command fails
set -e

echo "🚀 Starting Deployment for my_laravel_app..."

# 1. Export your server's User and Group IDs so the container uses them
export UID=$(id -u)
export GID=$(id -g)
CONTAINER_NAME="my_laravel_app"

# 2. Start or update the container
# We run --build in case you changed the Dockerfile or supervisord.conf
echo "📦 Ensuring the Docker container is up and running..."
docker compose up -d --build

# 3. Install PHP Dependencies
echo "🎼 Installing Composer dependencies..."
docker exec -u www-data $CONTAINER_NAME composer install --no-interaction --prefer-dist --optimize-autoloader

# 4. Build Frontend Assets
echo "🛠️ Installing NPM dependencies and building assets..."
docker exec -u www-data $CONTAINER_NAME npm install
docker exec -u www-data $CONTAINER_NAME npm run build

# 5. Database Migrations (SQLite)
# Since the folder is shared, this safely modifies the database.sqlite on your system
echo "🗄️ Running database migrations..."
docker exec -u www-data $CONTAINER_NAME php artisan migrate --force

# 6. Cache and Optimize Laravel
echo "🧹 Optimizing Laravel caches..."
docker exec -u www-data $CONTAINER_NAME php artisan optimize:clear
docker exec -u www-data $CONTAINER_NAME php artisan config:cache
docker exec -u www-data $CONTAINER_NAME php artisan event:cache
docker exec -u www-data $CONTAINER_NAME php artisan route:cache
docker exec -u www-data $CONTAINER_NAME php artisan view:cache

# 7. Restart Background Workers
# This tells the queue workers running via Supervisor to restart and pick up the new code
echo "🔄 Restarting queue workers..."
docker exec -u www-data $CONTAINER_NAME php artisan queue:restart

echo "✅ Deployment successful! Your app is live."
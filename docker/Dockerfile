FROM php:8.3-fpm-alpine

# Grab Composer from the official image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Nginx, Supervisor, permissions tools, SQLite, Node.js, and NPM
RUN apk add --no-cache \
    nginx \
    supervisor \
    shadow \
    su-exec \
    libpng-dev libzip-dev icu-dev sqlite-dev \
    nodejs npm \
    && docker-php-ext-install bcmath gd zip intl pdo_mysql pdo_sqlite

# Make Nginx run as the www-data user
RUN sed -i 's/user nginx;/user www-data;/g' /etc/nginx/nginx.conf

WORKDIR /var/www/html

# Copy our custom configuration files
COPY docker/nginx.conf /etc/nginx/http.d/default.conf
COPY docker/supervisord.conf /etc/supervisord.conf
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose port 80 (Web) and 5173 (Vite/NPM)
EXPOSE 80 5173

ENTRYPOINT ["entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
FROM php:8.3-fpm-alpine

# Install Nginx, Supervisor, and tools for permissions (shadow, su-exec)
RUN apk add --no-cache \
    nginx \
    supervisor \
    shadow \
    su-exec \
    libpng-dev libzip-dev icu-dev \
    && docker-php-ext-install bcmath gd zip intl pdo_mysql

# Make Nginx run as the www-data user
RUN sed -i 's/user nginx;/user www-data;/g' /etc/nginx/nginx.conf

WORKDIR /var/www/html

# Copy our custom configuration files
COPY docker/nginx.conf /etc/nginx/http.d/default.conf
COPY docker/supervisord.conf /etc/supervisord.conf
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 80

# Run the entrypoint script first, then start supervisor
ENTRYPOINT ["entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
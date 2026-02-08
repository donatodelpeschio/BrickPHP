FROM php:8.2-fpm

# Install extensions
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libssl-dev \
    && docker-php-ext-install pdo pdo_mysql zip

# Install Redis extension
RUN pecl install redis \
    && docker-php-ext-enable redis

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Permissions
RUN chown -R www-data:www-data /var/www/html

# Crea le cartelle necessarie e imposta i permessi
RUN mkdir -p storage/cache storage/logs storage/sessions \
    && chown -R www-data:www-data /var/www/html/storage \
    && chmod -R 775 /var/www/html/storage


CMD ["php-fpm"]

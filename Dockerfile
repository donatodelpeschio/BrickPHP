FROM php:8.2-fpm

# Installazione dipendenze di sistema e librerie necessarie
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libssl-dev \
    && docker-php-ext-install pdo pdo_mysql zip

# Installazione estensione Redis (fondamentale per RedisCache.php)
RUN pecl install redis \
    && docker-php-ext-enable redis

# Installazione Composer (copiato dall'immagine ufficiale)
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Definizione directory di lavoro (che corrisponderà al nostro BRICK_PATH)
WORKDIR /var/www/html

# Creazione della struttura storage prima di copiare i file
# Questo assicura che le cartelle esistano e abbiano i permessi corretti fin dal boot
RUN mkdir -p storage/cache storage/logs storage/sessions

# Ottimizzazione permessi:
# L'utente www-data deve poter scrivere in storage.
# Aggiungiamo anche l'utente root (usato spesso dalla CLI Docker) al gruppo www-data
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage

# Esposizione per PHP-FPM
EXPOSE 9000

CMD ["php-fpm"]
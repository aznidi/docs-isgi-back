# Étape 1 : Image de base avec PHP et extensions nécessaires
FROM php:8.2-fpm

# Installer les extensions nécessaires pour Laravel
RUN apt-get update && apt-get install -y \
    libzip-dev zip unzip mariadb-client \
    && docker-php-ext-install pdo pdo_mysql zip

# Installer Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier les fichiers du projet Laravel
COPY . .

# Installer les dépendances PHP avec Composer
RUN composer install --optimize-autoloader --no-dev

# Configurer les permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Exposer le port PHP-FPM
EXPOSE 9000

# Commande par défaut pour exécuter le serveur
CMD ["php-fpm"]

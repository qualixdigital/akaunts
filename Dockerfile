# Use an official PHP-Apache image
FROM php:8.2-apache

# Install required system packages including Oniguruma
RUN apt-get update && apt-get install -y \
    unzip git libpq-dev libpng-dev libjpeg-dev libfreetype6-dev libzip-dev zip curl \
    libonig-dev pkg-config \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_pgsql pgsql gd zip bcmath mbstring exif pcntl

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Download Akaunting (latest version)
RUN curl -L -o /tmp/akaunting.zip https://akaunting.com/download.php?version=latest \
    && unzip /tmp/akaunting.zip -d /var/www/html \
    && rm /tmp/akaunting.zip

# Set correct permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Update Apache config to use the public directory
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# Expose web port
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
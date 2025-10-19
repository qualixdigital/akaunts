#!/bin/bash

# Navigate to the app directory
cd /var/www/html

# Copy default env if not exists
if [ ! -f .env ]; then
    cp .env.example .env
fi

# Generate APP_KEY if not set
if ! grep -q "APP_KEY=" .env || grep -q "APP_KEY=$" .env; then
    echo "Generating new APP_KEY..."
    php artisan key:generate --force
fi

# Start Apache
apache2-foreground
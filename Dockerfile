# Use a multi-stage build to separate build dependencies from runtime
FROM composer:latest AS vendor

# Set working directory for composer stage
WORKDIR /app

# Copy composer files
COPY composer.json composer.lock ./

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader


# Build stage for frontend assets
FROM node:18-alpine AS assets

# Set working directory for node stage
WORKDIR /app

# Copy package files
COPY package.json yarn.lock ./

# Install node dependencies
RUN yarn install

# Copy application source code
COPY . .

# Build frontend assets
RUN yarn build


# Runtime stage
FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    supervisor \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Create working directory
WORKDIR /var/www/html

# Copy the application source code
COPY . .

# Copy vendor dependencies from composer stage
COPY --from=vendor /app/vendor ./vendor

# Copy built assets from node stage
COPY --from=assets /app/public ./public

# Create non-root user
RUN groupadd -g 1000 www-data \
    && useradd -u 1000 -ms /bin/bash -g www-data www-data \
    && chown -R www-data:www-data /var/www/html

# Switch to non-root user
USER www-data

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/api/v1/heartbeat || exit 1

# Run the application
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8080"]
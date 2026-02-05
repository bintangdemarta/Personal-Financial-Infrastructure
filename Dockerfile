FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Clone Firefly III source code
RUN git clone https://github.com/firefly-iii/firefly-iii.git ./

# Copy existing application directory contents
COPY . /var/www/html

# Install PHP dependencies
RUN composer install

# Install Node dependencies
RUN npm install
RUN npm run build

# Expose port
EXPOSE 8080

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy existing application directory permissions
RUN chown -R www:www /var/www/html
USER www

# Run the application
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8080"]
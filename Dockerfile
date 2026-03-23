FROM webdevops/php-nginx:8.1

# 1. Instalar dependencias del sistema y extensiones de PHP necesarias
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo_mysql zip bcmath

ENV WEB_DOCUMENT_ROOT=/app/public
WORKDIR /app

# 2. Copiar archivos
COPY . .

# 3. Instalar dependencias de PHP
# Usamos --ignore-platform-reqs para evitar errores de extensiones si el panel es muy estricto
RUN composer install --no-dev --optimize-autoloader --ignore-platform-reqs

# 4. Permisos correctos para Laravel
RUN chown -R www-data:www-data /app/storage /app/bootstrap/cache && \
    chmod -R 775 /app/storage /app/bootstrap/cache

# Usa una imagen base con PHP y Apache
FROM php:8.2-apache

# Instala dependencias necesarias
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git \
    curl \
    libonig-dev \
    && docker-php-ext-install pdo pdo_mysql mbstring gd

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Establece el directorio de trabajo en Laravel (NO en /var/www/html)
WORKDIR /var/www

# Copia el código del proyecto
COPY . .

# Asegurar que Apache sirva desde la carpeta `public`
RUN rm -rf /var/www/html && ln -s /var/www/public /var/www/html

# Crear las carpetas necesarias y dar permisos
RUN mkdir -p storage bootstrap/cache && chmod -R 775 storage bootstrap/cache

# Instala dependencias de Laravel
RUN composer install --no-dev --optimize-autoloader

# Expone el puerto 80 para Apache
EXPOSE 8080

# Comando para iniciar Apache
CMD ["apache2-foreground"]

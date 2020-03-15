FROM php:7.4-fpm

LABEL lehungio <me@lehungio.com>

RUN pecl install redis \
    && pecl install xdebug \
    && docker-php-ext-enable redis xdebug

# Deprecated libpng12-dev
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpq-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    libmcrypt-dev \
    libmemcached-dev \
    libssl-dev \
    libssl-doc \
    libsasl2-dev \
    zlib1g-dev \
    libicu-dev \
    g++ \
    zip


# Deprecated mbstring, mcrypt, zip
RUN docker-php-ext-install bz2
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pgsql
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install pdo_pgsql
RUN docker-php-ext-install soap

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

# exif
RUN docker-php-ext-configure exif
RUN docker-php-ext-install exif
RUN docker-php-ext-enable exif

# zip
RUN apt-get install -y libzip-dev zip && docker-php-ext-install zip

# imagick
RUN pecl install imagick

RUN php -r "phpinfo();"
RUN php --ini
RUN php --version
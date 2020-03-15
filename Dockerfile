FROM php:7.4-fpm

LABEL lehungio <me@lehungio.com>

RUN pecl install redis \
    && pecl install xdebug \
    && docker-php-ext-enable redis xdebug

RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpq-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    libmcrypt-dev \
    libpng12-dev \
    libmemcached-dev \
    libssl-dev \
    libssl-doc \
    libsasl2-dev \
    zlib1g-dev \
    libicu-dev \
    g++

RUN docker-php-ext-install \
    bz2 \
    iconv \
    mbstring \
    mcrypt \
    mysqli \
    pgsql \
    pdo_mysql \
    pdo_pgsql \
    soap \
    zip

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

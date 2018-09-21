FROM php:5.6-fpm

MAINTAINER Liho <me@lehungio.com>

RUN apt-get update && apt-get upgrade -y \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libpq-dev \
  libmagickwand-dev \
  libmcrypt-dev \
  libmcrypt-dev \
  libpng-dev \
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
  mysql \
  mysqli \
  pgsql \
  pdo_mysql \
  pdo_pgsql \
  soap \
  zip

RUN docker-php-ext-configure gd \
  --with-freetype-dir=/usr/include/ \
  --with-jpeg-dir=/usr/include/ \
  --with-png-dir=/usr/include/

RUN docker-php-ext-install gd
RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl
RUN pecl install mongodb && docker-php-ext-enable mongodb

# https://github.com/docker-library/php/issues/566
RUN pecl install xdebug-2.5.5
RUN docker-php-ext-enable xdebug

RUN pecl install redis && docker-php-ext-enable redis \
  && yes '' | pecl install imagick && docker-php-ext-enable imagick

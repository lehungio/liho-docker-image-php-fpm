FROM php:5.6-fpm

LABEL maintainer="me@lehungio.com"

WORKDIR /code

#  run sudo in docker ubuntu 16.04
RUN apt-get update && apt-get install -y sudo && rm -rf /var/lib/apt/lists/*

# init
RUN apt-get update \
  && apt-get install -y \
  wget \
  curl \
  vim \
  iputils-ping \
  mysql-client \
  make \
  g++ \
  git \
  git-core \
  gnupg

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


# rubygems gem sass
RUN apt-get update \
  && apt-get install -y rubygems gem \
  && gem install sass -v 3.4.23

# python and pip
RUN apt-get update \
    && apt-get install -y python python-dev python-pip \
    && pip install --upgrade --user awscli \
    && apt-get install -y ntp telnet \
    && apt-get install -y rsync

# node & npm
# RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN apt-get install -y nodejs
RUN npm install --quiet --production --no-progress --registry=${registry:-https://registry.npmjs.org} && \
  npm cache clean --force
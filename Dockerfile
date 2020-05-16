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
# RUN docker-php-ext-enable exif 
# warning: exif (exif.so) is already loaded!

# zip
RUN apt-get install -y libzip-dev zip && docker-php-ext-install zip
# TODO debconf: delaying package configuration, since apt-utils is not installed

# imagick
RUN pecl install imagick

# update 
RUN apt-get update

# Node dependencies
# https://github.com/nodejs/Release
ENV NVM_DIR /root/.nvm
ENV NODE_VERSION 14
# Instal nvm, node, yarn
# https://github.com/nvm-sh/nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash \
    && export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")" \
    && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && npm install yarn -g

# TODO This loads nvm
# Replace shell with bash so we can source files
# RUN rm /bin/sh && ln -s /bin/bash /bin/sh
# this command can not load properly when build, but  can run directly in ssh
# RUN [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
# https://stackoverflow.com/questions/25899912/how-to-install-nvm-in-docker

# Install git dependencies
RUN apt-get update && apt-get install -y git

# Update latest build
RUN apt-get update

# Summary installation
# 01. PHP
RUN php -r "phpinfo();"
RUN php --ini
RUN php --version

RUN uname -a

# 02. NVM / Node / Yarn
# RUN nvm --version
# RUN command -v nvm
# RUN nvm ls-remote
# RUN nvm list
# RUN node --version
# RUN yarn --version
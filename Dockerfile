FROM php:7.1-fpm

LABEL MAINTAINER="me@lehungio.com"

RUN apt-get update && \
    apt-get install -y git gnupg2 zip

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E1DD270288B4E6030699E45FA1715D88E1DF1F24
RUN su -c "echo 'deb http://ppa.launchpad.net/git-core/ppa/ubuntu trusty main' > /etc/apt/sources.list.d/git.list"

RUN pecl install redis \
    && pecl install xdebug \
    && docker-php-ext-enable redis xdebug

# TODO-01 libpng12-dev # has no installation candidate
# https://hub.docker.com/repository/registry-1.docker.io/lehungio/php-fpm/builds/e4c5c8ec-8b37-4e9e-a1cd-8ad1cb21ba4e
RUN apt-get update && apt-get upgrade -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpq-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    libmcrypt-dev \
    # TODO-01
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

# locale
# https://github.com/LaraDock/laradock/issues/167#issuecomment-234805362
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libmemcached-dev \
    curl \
    libjpeg-dev \
    libpng12-dev \
    libfreetype6-dev \
    libssl-dev \
    libmcrypt-dev \
    locales \
    --no-install-recommends \
    && rm -r /var/lib/apt/lists/* \
    && sed -i 's/# en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen \
    && sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen

FROM php:7.2-fpm

MAINTAINER j0nnybrav079

ARG remoteIp

RUN apt-get update \
    && apt-get install -y \
        git \
        curl \
        openssh-client \
        unzip \
        libpq-dev \
        libzip-dev \
        libicu-dev \
        libpng-dev \
        libjpeg62-turbo-dev \
        libfreetype6-dev \
        libmagickwand-6.q16-dev \
        libxml2-dev \
        --no-install-recommends \
    && docker-php-ext-install \
        bcmath \
        intl \
        json \
        opcache \
        pdo \
        pdo_pgsql \
        pdo_mysql \
        mysqli \
        pgsql \
        sockets \
        soap \
        zip \
        gd \
    && docker-php-ext-configure \
        gd \
        --with-jpeg-dir=/usr/lib \
        --with-freetype-dir=/usr/include/freetype2 \
    && docker-php-ext-install gd \
    && pecl install xdebug-2.6.0beta1\
        && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_host=$remoteIp" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && ln -s /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/MagickWand-config /usr/bin \
        && pecl install imagick \
        && echo "extension=imagick.so" > /usr/local/etc/php/conf.d/ext-imagick.ini \
    && pecl install apcu \
       && pecl install apcu_bc-1.0.3 \
       && docker-php-ext-enable apcu --ini-name 10-docker-php-ext-apcu.ini \
       && docker-php-ext-enable apc --ini-name 20-docker-php-ext-apc.ini \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
        && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
        && php -r "unlink('composer-setup.php');" \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update
RUN apt-get install -y zlib1g-dev libicu-dev g++
RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl
FROM composer:1 AS composer

FROM php:7.0-fpm

MAINTAINER Andrey Moretti <andrey.moretti@smartbox.com>

WORKDIR /var/www/html

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV SYMFONY_PHPUNIT_VERSION 6.5

COPY . /var/www/html

COPY --from=composer /usr/bin/composer /usr/bin/composer

#Installing and enabling features and PHP extension needed
RUN apt-get update -y \
  && apt-get install -y libxml2-dev libmcrypt-dev git unzip \
  && apt-get clean -y \
  && docker-php-ext-install soap mcrypt

RUN composer install --prefer-dist

RUN bin/simple-phpunit
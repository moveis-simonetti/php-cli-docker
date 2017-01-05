FROM php:7.1-cli

ENV http_proxy ${http_proxy}
ENV https_proxy ${http_proxy}

RUN docker-php-ext-install pdo_mysql

RUN apt-get update && apt-get install -y zip supervisor \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        git \
        libxslt-dev \
    && docker-php-ext-install -j$(nproc) iconv mcrypt zip soap \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-install -j$(nproc) bcmath

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

VOLUME ["/app"]
WORKDIR /app
FROM php:7.3-cli

ENV http_proxy ${http_proxy}
ENV https_proxy ${http_proxy}

RUN apt-get update && apt-get install -y zip \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    git \
    libxslt-dev \
    wget \
    sqlite3 \
    libsqlite3-dev \
    libicu-dev \
    libzip-dev

RUN docker-php-ext-install -j$(nproc) iconv zip soap pdo_mysql bcmath pdo_sqlite intl sockets \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

RUN echo "Install Redis" \
    && pecl install "redis-3.1.1" && docker-php-ext-enable redis

# Install xDebug (support on alpha)
RUN pecl install xdebug \
    && touch /usr/local/etc/php/conf.d/zz-xdebug.ini \
    && chown www-data:www-data /usr/local/etc/php/conf.d/zz-xdebug.ini && chmod a+rw /usr/local/etc/php/conf.d/zz-xdebug.ini

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

VOLUME ["/app"]
WORKDIR /app
